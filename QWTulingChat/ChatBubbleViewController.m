//
//  ChatBubbleViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/10.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ChatBubbleViewController.h"

@interface ChatBubbleViewController ()

/**
 *  聊天界面主题
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  输入的信息
 */
@property (weak, nonatomic) IBOutlet UITextField *messageField;
/**
 *  语音按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *speakBtn;


@end

@implementation ChatBubbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



/**
 *  点击事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)voiceBtnClick:(UIButton *)sender {
    

}






@end
