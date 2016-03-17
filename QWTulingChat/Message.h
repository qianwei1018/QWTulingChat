//
//  Message.h
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/12.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    MessageTypeMe = 0, // 自己发的
    MessageTypeOther = 1 //别人发得
    
} MessageType;

@interface Message : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) MessageType type;

@property (nonatomic, copy) NSDictionary *dict;


@end
