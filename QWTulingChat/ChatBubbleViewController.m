//
//  ChatBubbleViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/10.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ChatBubbleViewController.h"
#import "ChatBubbleTableViewCell.h"
#import "MyTulingHeader.h"
#import "MessageFrame.h"
#import "Message.h"
#import "ContentInfo.h"
#import "MessageCell.h"
#import "MessageCache.h"
#import <AFNetworking.h>
#import <UMSocial.h>

#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlyMSC.h>

//不带界面的语音合成控件
#import <iflyMSC/IFlySpeechSynthesizerDelegate.h>
#import <iflyMSC/IFlySpeechSynthesizer.h>

@interface ChatBubbleViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UMSocialUIDelegate,IFlyRecognizerViewDelegate>
{
    NSMutableArray  *_allMessagesFrame;
    NSString *content;    //输出的值
    IFlyRecognizerView *_iflyRecognizerView;
}
/**
 *  聊天界面主题
 */
@property (weak, nonatomic) IBOutlet UITableView *bubbleTableView;
/**
 *  输入的信息
 */
@property (weak, nonatomic) IBOutlet UITextField *messageField;
/**
 *  语音按钮（按住说话）
 */
@property (weak, nonatomic) IBOutlet UIButton *speakBtn;

- (IBAction)voiceBtnClick:(UIButton *)sender;

@property (strong, nonatomic) NSMutableArray *chatBubbleInfo;


@property (nonatomic, strong) NSMutableArray *messageFrames;

@end

@implementation ChatBubbleViewController

//
//-(NSMutableArray *)messageFrames
//{
//    if (_messageFrames == nil) {
//        
//        _messageFrames = [[NSMutableArray alloc]init];
//        
//    }
//    return _messageFrames;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bubbleTableView.delegate = self;
    self.bubbleTableView.dataSource = self;
    
    self.messageFrames = [MessageCache display];
    
   
    [self initView];
    [self initData];
    
    //button 添加手势
    
    UILongPressGestureRecognizer *longPGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
    [_speakBtn addGestureRecognizer:longPGR];
    
}


#pragma mark - 界面 数据 初始化
- (void) initView {
    self.bubbleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bubbleTableView.allowsSelection = NO;
    self.bubbleTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    
    //设置textField输入起始位置
    _messageField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _messageField.leftViewMode = UITextFieldViewModeAlways;
    
    _messageField.delegate = self;
    
    
}

- (void) initData {
    //初始数据
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"]];
    
    _allMessagesFrame = [NSMutableArray array];
    NSString *previousTime = nil;
    for (NSDictionary *dict in array) {
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        Message *message = [[Message alloc] init];
        message.dict = dict;
        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        messageFrame.message = message;
        previousTime = message.time;
        
        [_allMessagesFrame addObject:messageFrame];
    }
    
    //通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 键盘处理
//键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}
//键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark - 文本框代理方法
/**
 *  点击textField键盘的回车按钮
 *
 *  @param textField 文本框
 *
 *  @return BOOL
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 1、增加数据源
    NSString *contentText = textField.text;
       //时间格式化
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSLog(@"time:%@",time);
       //增加内容
    
    [self addMessageWithContent:contentText time:time];
    // 2、刷新表格
    [self.bubbleTableView reloadData];
    // 3、滚动至当前行
    [self scrollToBottom];
    // 4、清空文本框内容
    _messageField.text = nil;
    // 5、添加网络数据(数据回复)
    [self loadMessageByInfoByAFNetworking:contentText time:time];
    // 6、键盘回收
    [_messageField resignFirstResponder];
    return YES;
}

#pragma mark - 网络请求
/**
 *  网络请求数据  AFNetworking
 *
 *  @param infoString <#infoString description#>
 *  @param time       <#time description#>
 */
- (void) loadMessageByInfoByAFNetworking:(NSString *)infoString time:(NSString *)time {
    //http://www.tuling123.com/openapi/api?key=78aaf0702f48805fdaf8d07492eef0ae&info=
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms[@"info"] = infoString;
    [manager POST:URLAPIKEY parameters:parms progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSLog(@"responseObject%@",responseObject);
        
        //数据的判断及输出
        [self judgmentOfContentInfoWithDictionary:responseObject time:time];
        [self.bubbleTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure:%@",error);
    }];
}

#pragma mark - 返回数据的判断
/**
 *  判断返回的数据类型
 *
 *  @param dict 数据字典
 *  @param time 时间
 */
- (void)judgmentOfContentInfoWithDictionary:(NSDictionary *)dict time:(NSString *)time {
    ContentInfo *contentInfo = [[ContentInfo alloc] init];
    //返回的数据 （最外层字典）
    contentInfo.text = [dict valueForKey:@"text"];
    contentInfo.url = [dict valueForKey:@"url"];
    contentInfo.list = [dict valueForKey:@"list"];
    NSLog(@"%@",contentInfo.text);
    
//    static NSString *content;   //解析后的数据
    if ([[dict allKeys] containsObject:@"list"]) {
    //判断复杂的响应类
        NSArray *listArray = [dict valueForKey:@"list"];
        //显示text
        content = [NSString stringWithFormat:@"%@",contentInfo.text];
        NSDictionary *arrayDict;
//          //①将内容循环输出
//        for (int i = 0; i < listArray.count; i++) {
//            arrayDict = listArray[i];
        
           // ②输出第一个的内容
                //判断新闻类
              arrayDict = listArray[0];
            if ([[arrayDict allKeys] containsObject:@"article"]) {
                contentInfo.article = [arrayDict valueForKey:@"article"];
                contentInfo.source = [arrayDict valueForKey: @"source"];
                contentInfo.detailurl = [arrayDict valueForKey: @"detailurl"];
                content = [content stringByAppendingString:[NSString stringWithFormat:@"%@\n%@\n%@\n",contentInfo.article,contentInfo.source,contentInfo.detailurl]];
                //判断菜谱类
            } else if ([[arrayDict allKeys] containsObject:@"name"]) {
                contentInfo.name = [arrayDict valueForKey:@"name"];
                contentInfo.info = [arrayDict valueForKey:@"info"];
                contentInfo.detailurl = [arrayDict valueForKey:@"detailurl"];
                content = [content stringByAppendingString:[NSString stringWithFormat:@"%@\n%@\n%@\n",contentInfo.name,contentInfo.info,contentInfo.detailurl]];
                //判断其他类
            } else {
                content = [NSString stringWithFormat:@"对不起，未找到相关内容"];
            }
//        }
        
    } else if ([[dict allKeys] containsObject:@"url"]) {
        //判断仅含url 与 text 的数据类
        content = [NSString stringWithFormat:@"%@%@",contentInfo.text,contentInfo.url];
    } else {
        //判断仅含text的数据类
        content = [NSString stringWithFormat:@"%@",contentInfo.text];
    }
//    NSLog(@"%@",content);
    
    //添加回复cell
    [self addReplyMessageWithContent:content time:time];
    
    //添加长按手势
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doLongPress:)];
    [self.bubbleTableView addGestureRecognizer:longPressGR];
    //添加点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton)];
    [self.bubbleTableView addGestureRecognizer:tapGR];
}

#pragma mark 给数据源增加内容
/**
 *  增加输入内容
 *
 *  @param content 内容
 *  @param time    时间
 */
- (void)addMessageWithContent:(NSString *)contentLabel time:(NSString *)time{
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    msg.content = contentLabel;
    msg.time = time;
    msg.icon = @"pictureImage0";
    msg.type = MessageTypeMe;
    mf.message = msg;
    
    [_allMessagesFrame addObject:mf];
    
    
    //把数据存入数据库
    [MessageCache addMessage:contentLabel type:msg.type];
}

/**
 *  增加回复内容
 *
 *  @param content 显示的值
 *  @param time    time description
 */
- (void)addReplyMessageWithContent:(NSString *)contentLabel time:(NSString*)time {
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    msg.time = time;
    msg.content = contentLabel;
    msg.time = time;
    msg.icon = @"icon01.png";
    msg.type = MessageTypeOther;
    mf.message = msg;
    
    [_allMessagesFrame addObject:mf];
    
    //把数据存入数据库
    [MessageCache addMessage:msg.content type:msg.type];
    
    //刷新bubbleTableView
    [self.bubbleTableView reloadData];
    // 滚动至当前行
    [self scrollToBottom];
}

/**
 *  滑动至当前行
 */
- (void)scrollToBottom {
    if (_allMessagesFrame.count > 2) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
        [self.bubbleTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

#pragma mark - tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // 设置数据
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_allMessagesFrame[indexPath.row] cellHeight];
}

#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - 手势实现方法
//长按分享
- (void) doLongPress:(UIGestureRecognizer *)gesture {
    NSLog(@"dolongPress:%@",content);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享" message:@"是否分享" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alert addAction:cancelAction];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"分享");
        //注意：分享到新浪微博、微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈等平台需要参考各自的集成方法
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"56d68bdd67e58ede1a000b1a"
                                          shareText:content
                                         shareImage:[UIImage imageNamed:@"LOGO_64x64"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToSms,nil]
                                           delegate:self];
        
        //设置默认分享内容
        [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:self];
        
        
    }];
    [alert addAction:shareAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//点击进入url
- (void) clickButton {
    NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:5];
    NSString *urlString;
    
    //正则表达式url
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REGEX_URL options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (result) {
        urlString = [content substringWithRange:result.range];
        NSLog(@"%@",urlString);
        [urlArray addObject:urlString];
        NSLog(@"urlString:%@",urlString);
        NSLog(@"%@",urlArray);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击进入" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancleAction];
        
        UIAlertAction *entryAction;
        for (int i = 0; i < urlArray.count; i ++) {
            entryAction = [UIAlertAction actionWithTitle:urlArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               //直接调用Sarfari
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlArray[i]]];
                
            }];
            [alert addAction:entryAction];
        }
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

#pragma mark - 语音按钮点击
/**
 *  点击事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)voiceBtnClick:(UIButton *)sender {
    if (_messageField.hidden) { //输入框隐藏，按住说话按钮显示
        _messageField.hidden = NO;
        _speakBtn.hidden = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_press.png"] forState:UIControlStateHighlighted];
        [_messageField becomeFirstResponder];
    } else { //输入框处于显示状态，按住说话按钮处于隐藏状态
        _messageField.hidden = YES;
        _speakBtn.hidden = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_keyboard_press.png"] forState:UIControlStateHighlighted];
        [_messageField resignFirstResponder];
    }
    
    
    
}

- (void)longClick:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"5708c023"];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
        _iflyRecognizerView = [[IFlyRecognizerView alloc]initWithCenter:self.view.center];
        _iflyRecognizerView.delegate = self;
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
         [_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
        //    [_iflyrReco start];
        //指定返回数据格式
        //    [_iflyrReco setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        [_iflyRecognizerView start];

        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
    }
    
    
}

/**
 *  识别结果返回代理
 *
 *  @param resultArray 识别结果
 *  @param isLast      最后一次结果
 */
-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{

    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@", key];
    }
    NSString *text;
    text = [NSString stringWithFormat:@"%@%@",text, result];
    [self addMessageWithContent:[NSString stringWithFormat:@"%@%@",text,result] time:nil];
//    [self addMessageWithContent:result time:];
//    [self inputMessage:result url:nil type:MessageTypeMe];
}
/**
 *  识别会话错误返回代理
 *
 *  @param error 错误码
 */
-(void)onError:(IFlySpeechError *)error
{
    NSLog(@"error ------------ %@",error);
}




@end
