//
//  CarInfoData.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/7.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarInfoData : NSObject

@property (nonatomic,assign) int car_id; //车辆ID
@property (nonatomic,assign) int default_car;//	是否为默认车辆
@property (nonatomic,strong) NSString *car_no;//车牌;
@property (nonatomic,strong) NSString *brand_name;	//品牌
@property (nonatomic,strong) NSString *type_name;//车型
@property (nonatomic,strong) NSString *brand_logo;//品牌logo
@property (nonatomic,strong) NSString *car_serie;//车系


@end
