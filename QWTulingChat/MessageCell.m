//
//  MessageCell.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/12.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import "MessageFrame.h"
@class ChatBubbleViewController;

@interface MessageCell ()
{
    UIButton     *_timeBtn;
    UIImageView *_iconView;
    UIButton    *_contentBtn;
//    UILabel *_contentLabel;
}

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //#warning 必须先设置为clearColor，否则tableView的背景会被遮住
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        [_timeBtn setBackgroundImage:[UIImage imageNamed:@"chat_timeline_bg.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = _iconView.bounds.size.height/2;
        [self.contentView addSubview:_iconView];
        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        
        [self.contentView addSubview:_contentBtn];
        
//        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.userInteractionEnabled = YES;
//        _contentLabel.textColor = [UIColor blackColor];
//        _contentLabel.font = kContentFont;
//        _contentLabel.numberOfLines = 0;
//        [self.contentView addSubview:_contentLabel];
        
        
    }
    return self;
}

- (void)setMessageFrame:(MessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    Message *message = _messageFrame.message;
    
    // 1、设置时间
    [_timeBtn setTitle:message.time forState:UIControlStateNormal];
    
    _timeBtn.frame = _messageFrame.timeF;
    
    // 2、设置头像
    _iconView.image = [UIImage imageNamed:message.icon];
    _iconView.frame = _messageFrame.iconF;
    
    // 3、设置内容
    [_contentBtn setTitle:message.content forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentBtn.frame = _messageFrame.contentF;
    
    
    
    if (message.type == MessageTypeMe) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    
    _messageContent = message.content;
    
    
    UIImage *normal , *focused;
    //判断发送方
    if (message.type == MessageTypeMe) {
        normal = [UIImage imageNamed:@"chatto_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatto_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }else{
        
        normal = [UIImage imageNamed:@"chatfrom_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
        
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];

//    [_contentLabel setBackgroundColor:[UIColor greenColor]];
}

//#pragma  mark - 点击事件
//- (void) clickButton {
//    _urlArray = [NSMutableArray arrayWithCapacity:5];
//    NSString *urlString;
//    
//    NSError *error;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?" options:NSRegularExpressionCaseInsensitive error:&error];
//    NSTextCheckingResult *result = [regex firstMatchInString:_messageContent options:0 range:NSMakeRange(0, [_messageContent length])];
//    if (result) {
//        urlString = [_messageContent substringWithRange:result.range];
//        NSLog(@"%@",urlString);
//        [_urlArray addObject:urlString];
//        NSLog(@"%@",_urlArray);
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击进入" preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alert addAction:cancleAction];
//        
//        [_viewController presentViewController:alert animated:YES completion:^{
//            
//        }];
//         
//        
//    }
//}




@end
