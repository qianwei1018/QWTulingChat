//
//  AppDelegate.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/4.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTulingHeader.h"
#import <SMS_SDK/SMSSDK.h>
#import <UMSocial.h>
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //短信验证key
    [SMSSDK registerApp:SMSAppKey withSecret:SMSAppSecret];
    
    //友盟分享KEY
    [UMSocialData setAppKey:@"56d68bdd67e58ede1a000b1a"];
    
//    //微博
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3228337151"
//                                              secret:@"e2a93a425c5f14a1867862134e2a8ecd"
//                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    //微信   AppID：wxd5d4138162361362
    [UMSocialWechatHandler setWXAppId:@"wxd5d4138162361362" appSecret:@"9abe7f50a793deca4c0b3cba815300c6" url:@"http://www.umeng.com/social"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
