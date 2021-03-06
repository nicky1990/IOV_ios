//
//  Tool.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/1.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "Tool.h"
#import "NSString+XXTEA.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Tool

+(NSString *)md5:(NSString *)str {

    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
/*
 *获取时间戳
 */
+(NSNumber *)getCurrentTimeStamp{
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
//    NSLog(@"%@", localeDate);
    int timeInterval = [localeDate timeIntervalSince1970];
//    NSLog(@"timeSp:%d",timeInterval); //时间戳的值
//    NSDate *a = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    NSLog(@"%@",a);
    return [NSNumber numberWithInt:timeInterval];
}
/*
 *date转时间戳
 */
+(NSNumber *)dateTransTimeStamp:(NSDate *)datenow{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    int timeInterval = [localeDate timeIntervalSince1970];
    return [NSNumber numberWithInt:timeInterval];
}

+(NSString *)teaEncryptWithString:(NSString *)encryptString{
    NSString *key = @"91b146928b1c2a87";
    NSString *encryped = [encryptString encryptXXTEA:key];
//    NSLog(@"%@",encryped);
    return encryped;
}

+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber{
    
    if (phoneNumber.length == 11) {
        return YES;
    }else{
        return NO;
    }
    
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumber];
    //    BOOL res2 = [regextestcm evaluateWithObject:phoneNumber];
    //    BOOL res3 = [regextestcu evaluateWithObject:phoneNumber];
    //    BOOL res4 = [regextestct evaluateWithObject:phoneNumber];
    //
    //    if (res1 || res2 || res3 || res4 )
    //    {
    //        return YES;
    //    }
    //    else
    //    {
    //        return NO;
    //    }
}

+ (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

+(UIImage *)combine:(UIImage*)centerImage {
    
    UIImage *imageHead = [UIImage imageNamed:@"carstatus_oiltop"];
    UIImage *imageBottom = [UIImage imageNamed:@"carstatus_oilbotton"];
    
    
    CGFloat width = centerImage.size.width;
    CGFloat height = imageHead.size.height+centerImage.size.height+imageBottom.size.height;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(offScreenSize);
    }
//    UIGraphicsBeginImageContext(offScreenSize);
    
    CGRect rect = CGRectMake(0, 0, width, imageHead.size.height);
    [imageHead drawInRect:rect];
    
    CGRect rect1 = CGRectMake(0, imageHead.size.height, width, centerImage.size.height);
    [centerImage drawInRect:rect1];
    
    CGRect rect2 = CGRectMake(0, imageHead.size.height+centerImage.size.height, width, imageBottom.size.height);
    [imageBottom drawInRect:rect2];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imagez;
}



@end
