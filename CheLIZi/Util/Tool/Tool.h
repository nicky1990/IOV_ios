//
//  Tool.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/1.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject



+(NSString *)md5:(NSString *)str;
//获取时间戳
+(NSNumber *)getCurrentTimeStamp;
+(NSNumber *)dateTransTimeStamp:(NSDate *)datenow;
+(NSString *)teaEncryptWithString:(NSString *)encryptString;
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;
+ (void)showAlertMessage:(NSString *)msg;

@end
