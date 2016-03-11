//
//  ChatBubbleInfo.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/11.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ChatBubbleInfo.h"

@implementation ChatBubbleInfo


-(NSString *)description {
    return [NSString stringWithFormat:@"userName:%@,chatImgName:%@,chatText:%@,time:%@ ",_userName,_chatImgName,_chatText,_time ];
}



@end
