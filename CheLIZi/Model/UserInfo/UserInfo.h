//
//  UserInfo.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/3.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


@property (strong,nonatomic) NSNumber *user_id;
@property (assign,nonatomic) int car_id;
@property (strong,nonatomic) NSString *userS_id;
@property (strong,nonatomic) NSString *userAccess_token;
@property (strong,nonatomic) NSString *userNiCheng;
@property (strong,nonatomic) NSString *userAge;
@property (strong,nonatomic) NSString *userAddress;
@property (strong,nonatomic) NSString *userPhone;
@property (strong,nonatomic) NSString *userSex;
@property (strong,nonatomic) NSString *userBirthday;



+(UserInfo *)sharedUserInfo;

@end
