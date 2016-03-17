//
//  ChatBubbleTableViewCell.h
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/10.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBubbleInfo.h"

@interface ChatBubbleTableViewCell : UITableViewCell
/**
 *  聊天图像
 */
@property (weak, nonatomic) IBOutlet UIImageView *chatImageView;
/**
 *  聊天时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  聊天内容
 */
@property (weak, nonatomic) IBOutlet UILabel *chatContentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backgroungImgView;


- (void) bindChatBubbleInfo:(ChatBubbleInfo *)chatBubbleInfo;




@end






