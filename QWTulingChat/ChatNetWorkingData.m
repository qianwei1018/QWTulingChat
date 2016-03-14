//
//  ChatNetWorkingData.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/13.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ChatNetWorkingData.h"
#import "MyTulingHeader.h"

@implementation ChatNetWorkingData

- (void)loadMessageByInfoStringByPost:(NSString *)infoString {
    
    NSString *APIAddress = URLAPIKEY;
    
    // 1.创建URL
    NSURL *url = [NSURL URLWithString:APIAddress];
    
    // 2.创建request
    // 以POST方法想服务器请求数据
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 对request进行配置
    request.HTTPMethod = @"POST";
    
    // 参数的格式化
    
    NSString *urlStr = [NSString stringWithFormat:@"%@&info=%@", APIAddress, infoString];
    NSLog(@"urlStr:%@",urlStr);
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSData *data = [NSData dataWithBytes:urlStr.UTF8String length:urlStr.length];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"data string : %@", dataString);
    }];
    
    [dataTask resume];
}




@end
