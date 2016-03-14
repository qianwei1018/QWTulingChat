//
//  MyTulingHeader.h
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/5.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#ifndef MyTulingHeader_h
#define MyTulingHeader_h

/**
 *  短信APPkey  AppSecret
 *
 *  @return <#return value description#>
 */
#define SMSAppKey @"1013beeaf91cc"
#define SMSAppSecret @"5cf33bbe4707c9e5f85e839121d295b7"

/**
 *  图灵机器人API
 *
 *  @return <#return value description#>
 */
#define URLAPIKEY @"http://www.tuling123.com/openapi/api?key=78aaf0702f48805fdaf8d07492eef0ae"
/**
 *  屏幕的大小
 *
 *  @return <#return value description#>
 */
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

/**
 *  pictureView 中的图片数量
 *
 *  @return <#return value description#>
 */
#define NUMBEROFPICTUREIMAGE 9 

/**
 *  正则表达式
 *
 *  @return <#return value description#>
 */
#define REGEX_USER_NAME @"^[A-Za-z][A-Za-z0-9_]{5,15}"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_TELNUM @"^1[3|4|5|7|8][0-9]\\d{8}$"



#endif /* MyTulingHeader_h */
