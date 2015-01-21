//
//  AddressInfo.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/18.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject

@property (nonatomic,strong) NSString *consignee;//收货人
@property (nonatomic,strong) NSString *telephone;//收货人手机
@property (nonatomic,strong) NSString *country_name;//国家名称
@property (nonatomic,strong) NSString *province_name;//省份名称
@property (nonatomic,strong) NSString *city_name;//城市名称
@property (nonatomic,strong) NSString *district_name;//区名称
@property (nonatomic,strong) NSString *address;//详细地址
@property (nonatomic,strong) NSString *postcode;
@property (nonatomic,assign) int country_id;
@property (nonatomic,assign) int province_id;
@property (nonatomic,assign) int city_id;
@property (nonatomic,assign) int district_id;

@end
