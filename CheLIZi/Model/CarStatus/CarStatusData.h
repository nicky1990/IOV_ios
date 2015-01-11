//
//  CarStatusData.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/5.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarStatusData : NSObject


@property (nonatomic,assign) int car_id;
@property (nonatomic,strong) NSString *car_no;          //车牌号
@property (nonatomic,assign) double avg_gas_mileage;	//平均油耗
@property (nonatomic,assign) double once_mileage;		//本次里程
@property (nonatomic,assign) double avg_speed;          //平均速度
@property (nonatomic,assign) double max_speed;		    //本次行程最大车速
@property (nonatomic,assign) double once_gas_mileage;	//本次油耗
@property (nonatomic,assign) double defeat_percent;		//击败小伙伴百分比例

@end
