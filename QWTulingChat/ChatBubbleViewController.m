//
//  ChatBubbleViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/10.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ChatBubbleViewController.h"
#import "ChatBubbleTableViewCell.h"
#import "ChatNetWorkingData.h"
#import "MyTulingHeader.h"
#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"

@interface ChatBubbleViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray  *_allMessagesFrame;
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


@end

@implementation ChatBubbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bubbleTableView.delegate = self;
    self.bubbleTableView.dataSource = self;
//    [self setupTableView];
   
    [self initView];
    [self initData];
    
}

#pragma mark - 初始化
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
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 1、增加数据源
    NSString *content = textField.text;
       //时间格式化
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSLog(@"time:%@",time);
      //增加内容
    [self addMessageWithContent:content time:time];
    // 2、刷新表格
    [self.bubbleTableView reloadData];
    // 3、滚动至当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    [self.bubbleTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    // 4、清空文本框内容
    _messageField.text = nil;
    
    //添加网络数据
//    [self loadMessageByInfoStringByPost:content];
    [self addReplyMessageWithContent:content time:time];
    [self.bubbleTableView reloadData];
    
    
    [_messageField resignFirstResponder];
    
    return YES;
}

#pragma mark 给数据源增加内容
/**
 *  增加内容
 *
 *  @param content 内容
 *  @param time    时间
 */
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time{
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    msg.content = content;
    msg.time = time;
    msg.icon = @"icon01.png";
    msg.type = MessageTypeMe;
    mf.message = msg;
    
    [_allMessagesFrame addObject:mf];
}

- (void)addReplyMessageWithContent:(NSString *)content time:(NSString*)time {
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    
    [self loadMessageByInfoStringByPost:content];
    
    msg.content = content;
    msg.time = time;
    msg.icon = @"icon01.png";
    msg.type = MessageTypeOther;
    mf.message = msg;
    
    [_allMessagesFrame addObject:mf];
}


- (void)loadMessageByInfoStringByPost:(NSString *)infoString {
    
    NSString *APIAddress = URLAPIKEY;

    // 1.创建URL
    NSURL *url = [NSURL URLWithString:APIAddress];
    
    // 2.创建request
    // 以POST方法想服务器请求数据
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 对request进行配置
    request.HTTPMethod = @"POST";
    
    // 参数的格式化
    NSString *urlStr = [NSString stringWithFormat:@"%@&info=%@", APIAddress, infoString];
    NSLog(@"urlStr:%@",urlStr);
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSData *data = [NSData dataWithBytes:urlStr.UTF8String length:urlStr.length];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict=[NSDictionary dictionaryWithObject:response forKey:@"result"];
        NSLog(@"%@",dict);
        
//        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"data string : %@", dataString);
        
        
    }];
    
    [dataTask resume];
    
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















//
///**
// *  自适应高度
// */
//- (void)setupTableView {
//    self.bubbleTableView.rowHeight = UITableViewAutomaticDimension;
//    self.bubbleTableView.estimatedRowHeight = 10; //给定一个初始的默认高度
////     autoHeightRatio() 传0则根据文字自动计算高度（传大于0的值则根据此数值设置高度和宽度的比值）
//    _messageField.sd_layout.autoHeightRatio(0);
//    
//}
//#pragma mark - table view data source
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return  1;
//}
//
//#pragma mark - table view delegate
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *reuseIdentifier = @"chatBubbleTableViewCell";
//    [tableView registerNib:[UINib nibWithNibName:@"ChatBubbleTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
//    ChatBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatBubbleTableViewCell" owner:nil options:nil]lastObject];
//    }
//    
//    ChatBubbleInfo *chatInfo = self.chatBubbleInfo[indexPath.row];
//    
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    cell.backgroundColor = [UIColor lightGrayColor];
//    
//    
//    
//    [cell bindChatBubbleInfo:chatInfo];
//    
//    NSLog(@"indexpath:%ld,chatInfo:%@",(long)indexPath.row,chatInfo);
//    
//    return cell;
//}


@end
