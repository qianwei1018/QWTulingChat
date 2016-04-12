//
//  MessageCache.m
//  机器人
//
//  Created by gyh on 15/5/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MessageCache.h"
#import "Message.h"
#import "MessageFrame.h"
#import "FMDB.h"

@implementation MessageCache


static FMDatabaseQueue *_queue;


/**
 *  初始化，创表
 */
+(void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"Message.sqlite"];
    NSLog(@"%@",path);
    
    //创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    //创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_message (id integer primary key autoincrement, message text,type integer);"];
    }];
}



#pragma mark 存数据
+(void)addMessage:(NSString *)str type:(int)type
{
    [_queue inDatabase:^(FMDatabase *db) {
       
        NSNumber *num = [NSNumber numberWithInt:type];
        // 2.存储数据
        [db executeUpdate:@"insert into t_message (message, type) values(?, ?)", str, num];
         NSLog(@"%@,%d",str,type);
    }];

}


#pragma mark 显示数据
+(NSMutableArray *)display
{
    __block NSMutableArray *dicArray = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        
        dicArray = [NSMutableArray array];
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:@"select * from t_message"];
        
        // 2.遍历结果集
        while (rs.next) {
            NSString *name = [rs stringForColumn:@"message"];
            int type = [rs intForColumn:@"type"];
            
            NSLog(@"%@ ,%d",name,type);
            Message *msg = [[Message alloc]init];
            msg.text = name;
            msg.type = type;
            
            MessageFrame *mf = [[MessageFrame alloc]init];
            mf.message = msg;
        
            [dicArray addObject:mf];
            
        }
    }];
    
    return dicArray;
}


//删除表数据
+(void)deletetable
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_message"];
    }];
}

@end
