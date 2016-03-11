//
//  ChatBubbleTableViewCell.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/10.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ChatBubbleTableViewCell.h"

@implementation ChatBubbleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 *  绑定数据
 *
 *  @param chatBubbleInfo 聊天数据
 */
-(void)bindChatBubbleInfo:(ChatBubbleInfo *)chatBubbleInfo {
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//    });
//
    
    self.chatImageView.layer.cornerRadius = self.chatImageView.bounds.size.height/2;
    self.chatImageView.image = [UIImage imageNamed:@"pictureImage1"];
    self.timeLabel.text = @"一分钟前";
    self.chatContentLabel.text = @"测试dsbvhdbvbdsbvdbvbuvbudsbvubvubcfcycufyufuyfufuyfuyfuyfutfdbvdbvbsdvbdsvbdsbvudsbvoudsbvubdsvbdsbvdbvdbvbdsj";
    
    self.backgroungImgView.layer.cornerRadius = 15;
    self.backgroungImgView.layer.masksToBounds = YES;
    
    
}


@end
