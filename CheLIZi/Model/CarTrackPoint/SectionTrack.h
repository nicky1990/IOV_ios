//
//  SectionTrack.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/8.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionTrack : NSObject

@property (nonatomic,assign) int start_time; //本次行驶开始时间
@property (nonatomic,assign) int end_time;   //本次行驶结束时间
@property (nonatomic,assign) int rapid_accelerate; //急加速次数
@property (nonatomic,assign) int rapid_brake; //急减速次数
@property (nonatomic,assign) int rapid_turn;  //急转弯次数
@property (nonatomic,assign) int speeding_duration;//超高速时长
@property (nonatomic,assign) double mileage;     //本次行驶里程
@property (nonatomic,assign) double gas;        //本次行驶油耗
@property (nonatomic,assign) double avg_gas;    //本次平均油耗
@property (nonatomic,assign) double avg_speed;  //平均速度
@property (nonatomic,strong) NSString *stime;
@property (nonatomic,strong) NSString *etime;

@end
