//
//  ChatTableTableViewCell.h
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/10.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableTableViewCell : UITableViewCell
/**
 *  聊天图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *chatPictureImageView;
/**
 *  name
 */
@property (weak, nonatomic) IBOutlet UILabel *chatNameLabel;
/**
 *  message
 */
@property (weak, nonatomic) IBOutlet UILabel *chatMessageLabel;
/**
 *  time
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@end
