//
//  CarType.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/12.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarType : NSObject

@property (nonatomic,assign) int cb_id;//	是否为默认车辆
@property (nonatomic,strong) NSString *name;//车牌;
@property (nonatomic,assign) int type;//	类型 1品牌 2车系 3车型
@property (nonatomic,strong) NSString *logo;//

@end
