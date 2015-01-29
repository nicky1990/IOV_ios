//
//  CarScanData.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/6.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarScanData : NSObject

@property (nonatomic,assign) int scan_time;
@property (nonatomic,assign) int score;                 //得分
@property (nonatomic,assign) int battery_voltage;       //电瓶电压状况
@property (nonatomic,assign) int coolant_temperature;	//水温状况
@property (nonatomic,assign) int engine_rpm;            //发动机转数状况
@property (nonatomic,assign) int MAP;                   //进气压力状况
@property (nonatomic,assign) int ACT;                   //进气温度状况
@property (nonatomic,assign) int STD;                   //节气门开度状况
@property (nonatomic,assign) int TWC;                   //三元催化剂温度状况
@property (nonatomic,strong) NSArray *fault;           //故障码

@end
