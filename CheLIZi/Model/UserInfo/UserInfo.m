//
//  UserInfo.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/3.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

static UserInfo *shareInstance = nil;
+(UserInfo *)sharedUserInfo{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[UserInfo alloc]init];
    });
    return shareInstance;
}

@end
