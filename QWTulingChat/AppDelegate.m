//
//  AppDelegate.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/4.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//  $(inherited) -ObjC -l"AFNetworking" -l"APOpenSdk" -l"SDAutoLayout" -l"SocialAlipayShare" -l"SocialFacebook" -l"SocialInstagram" -l"SocialLaiWang" -l"SocialLine" -l"SocialQQ" -l"SocialSina" -l"SocialSinaSSO" -l"SocialTumblr" -l"SocialTwitter" -l"SocialWechat" -l"SocialWhatsapp" -l"UMSocial_Sdk_4.4" -l"UMSocial_Sdk_Comment_4.4" -l"WeChatSDK" -l"WeiboSDK" -l"iconv" -l"icucore" -l"sqlite3" -l"stdc++" -l"z" -framework "Accounts" -framework "AddressBook" -framework "AddressBookUI" -framework "CoreData" -framework "CoreGraphics" -framework "CoreTelephony" -framework "FBSDKCoreKit" -framework "FBSDKLoginKit" -framework "FBSDKShareKit" -framework "Fabric" -framework "ImageIO" -framework "MOBFoundation" -framework "MessageUI" -framework "MobileCoreServices" -framework "SMS_SDK" -framework "Security" -framework "Social" -framework "SystemConfiguration" -framework "TencentOpenAPI" -framework "TwitterCore" -framework "TwitterKit" -framework "javascriptcore"

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
    
    //微博
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3228337151"
//                                              secret:@"e2a93a425c5f14a1867862134e2a8ecd"
//                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //微信
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    
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
