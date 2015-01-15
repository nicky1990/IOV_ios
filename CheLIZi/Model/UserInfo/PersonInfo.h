//
//  PersonInfo.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/13.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonInfo : NSObject

@property (strong,nonatomic) NSString *mobile;//帐号
@property (strong,nonatomic) NSString *avatar;//用户头像
@property (strong,nonatomic) NSString *nickname;//昵称
@property (strong,nonatomic) NSString *realname;//真实姓名
@property (assign,nonatomic) int sex; //性别
@property (strong,nonatomic) NSString *birthday;//出生日期
@property (strong,nonatomic) NSString *country;//国家
@property (strong,nonatomic) NSString *province;//省份
@property (strong,nonatomic) NSString *city;//城市
@property (strong,nonatomic) NSString *address;//我的地址


@end
