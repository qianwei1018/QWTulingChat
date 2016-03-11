//
//  ChatBubbleViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/10.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ChatBubbleViewController.h"
#import "ChatBubbleTableViewCell.h"

@interface ChatBubbleViewController ()<UITableViewDelegate,UITableViewDataSource>
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


@property (strong, nonatomic) NSMutableArray *chatBubbleInfo;


//- (IBAction)voiceBtnClick:(UIButton *)sender;

@end

@implementation ChatBubbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bubbleTableView.delegate = self;
    self.bubbleTableView.dataSource = self;
    
    [self setupTableView];
    
}
//
//-(NSMutableArray *)chatBubbleInfo {
//    if (_chatBubbleInfo == nil) {
//        _chatBubbleInfo = [NSMutableArray array];
//    }
//    return _chatBubbleInfo;
//}

/**
 *  自适应高度
 */
- (void)setupTableView {
    
    self.bubbleTableView.rowHeight = UITableViewAutomaticDimension;
    self.bubbleTableView.estimatedRowHeight = 100; //给定一个初始的默认高度
    
}

#pragma mark - table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return  self.
//}

#pragma mark - table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"chatBubbleTableViewCell";
    [tableView registerNib:[UINib nibWithNibName:@"ChatBubbleTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    ChatBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatBubbleTableViewCell" owner:nil options:nil]lastObject];
    }
    
    ChatBubbleInfo *chatInfo = self.chatBubbleInfo[indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    [cell bindChatBubbleInfo:chatInfo];
    
    NSLog(@"indexpath:%ld,chatInfo:%@",(long)indexPath.row,chatInfo);
    
    return cell;
}








///**
// *  点击事件
// *
// *  @param sender <#sender description#>
// */
//- (IBAction)voiceBtnClick:(UIButton *)sender {
//}
@end
