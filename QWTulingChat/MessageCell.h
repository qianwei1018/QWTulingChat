//
//  MessageCell.h
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/12.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageFrame;

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) MessageFrame *messageFrame;

/**
 *  接收button中的数据
 */
@property (nonatomic, strong) NSString *messageContent;
/**
 *  接收url的数组
 */
@property (nonatomic, strong) NSMutableArray *urlArray;


@property (nonatomic, strong) UIViewController *viewController;
@end
