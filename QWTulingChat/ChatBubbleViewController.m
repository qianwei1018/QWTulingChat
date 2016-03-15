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
#import <AFNetworking.h>
#import "MessageFrame.h"
#import "Message.h"
#import "ContentInfo.h"
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
    [self scrollToBottom];
    // 4、清空文本框内容
    _messageField.text = nil;
    // 5、添加网络数据(数据回复)
    [self loadMessageByInfoByAFNetworking:content time:time];
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure:%@",error);
    }];
}

- (void)judgmentOfContentInfoWithDictionary:(NSDictionary *)dict time:(NSString *)time {
    ContentInfo *contentInfo = [[ContentInfo alloc] init];
    //返回的数据
    contentInfo.text = [dict valueForKey:@"text"];
    contentInfo.url = [dict valueForKey:@"url"];
    contentInfo.list = [dict valueForKey:@"list"];
    contentInfo.article = [dict valueForKey:@"article"];
    contentInfo.source = [dict valueForKey:@"source"];
    contentInfo.icon = [dict valueForKey:@"icon"];
    contentInfo.detailurl = [dict valueForKey:@"detailurl"];
    contentInfo.name = [dict valueForKey:@"name"];
    contentInfo.song = [dict valueForKey:@"song"];
    contentInfo.singer = [dict valueForKey:@"singer"];
    contentInfo.info = [dict valueForKey:@"info"];
    
    NSLog(@"%@",contentInfo.text);
    NSString *content;
    if ([[dict allKeys] containsObject:@"list"]) {
        NSArray *listArray = [dict valueForKey:@"list"];
        //输出text
        content = [NSString stringWithFormat:@"%@",contentInfo.text];
        //判断新闻类
        for (int i = 0; i < listArray.count; i++) {
            NSDictionary *arrayDict = listArray[i];
//                for (NSDictionary *dict in listArray[i]) {
            if ([[arrayDict allKeys] containsObject:@"article"]) {
                for (NSDictionary *listArrayDict in arrayDict) {
                    contentInfo.article = listArrayDict[@"article"];
                    contentInfo.source = listArrayDict[@"source"];
                    contentInfo.detailurl = listArrayDict[@"detailurl"];
                    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@\n%@\n%@",contentInfo.article,contentInfo.source,contentInfo.detailurl]];
                }
                
            } else {
            
            }
        }

    } else if ([[dict allKeys] containsObject:@"url"]) {
        content = [NSString stringWithFormat:@"%@%@",contentInfo.text,contentInfo.url];
    } else {
        content = [NSString stringWithFormat:@"%@",contentInfo.text];
    }
    
    //添加回复cell
    [self addReplyMessageWithContent:content time:time];
    [self.bubbleTableView reloadData];
}

#pragma mark 给数据源增加内容
/**
 *  增加输入内容
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

/**
 *  增加回复内容
 *
 *  @param content <#content description#>
 *  @param time    <#time description#>
 */
- (void)addReplyMessageWithContent:(NSString *)content time:(NSString*)time {
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    
    msg.content = content;
    msg.time = time;
    msg.icon = @"icon01.png";
    msg.type = MessageTypeOther;
    mf.message = msg;
    
    [_allMessagesFrame addObject:mf];
    
    //刷新bubbleTableView
    [self.bubbleTableView reloadData];
    // 滚动至当前行
    [self scrollToBottom];
}

/**
 *  滑动至当前行
 */
- (void)scrollToBottom {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    [self.bubbleTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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



@end
