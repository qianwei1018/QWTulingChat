//
//  MessageCache.h
//  机器人
//
//  Created by gyh on 15/5/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageCache : NSObject

+(void)addMessage:(NSString *)str type:(int)type;

+(NSMutableArray *)display;

+(void)deletetable;

@end
