//
//  Common.h
//  CheLIZi
//
//  Created by 点睛石 on 14/12/24.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#ifndef CheLIZi_Common_h
#define CheLIZi_Common_h

#define BASEURL @"http://192.168.8.146/api.php"

#define SYSTEM_VERSION8 ([[[UIDevice currentDevice] systemVersion] floatValue]>= 8.0)

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define kH_SreenHeight [UIScreen mainScreen].bounds.size.height
#define kW_SreenWidth [UIScreen mainScreen].bounds.size.width

#define kH_StatusBar 20
#define kH_NavBar 44
#define kH_TabBar 49

#define APP_DELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate

#define REQUESTTIMEOUT 10
#define REQUESTTAG 400 //通用的默认网络请求标志，用于区分在同一个控制器多个请求的返回结果


#pragma mark Request Para

#define kDEVICE_SYSTEM @"iOS"
#define kAPP_KEY @"17382354"
#define kSIGNATURE @"91b146928b1c2a87"


#endif
