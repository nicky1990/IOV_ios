//
//  CarSetWarnData.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/7.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarSetWarnData : NSObject

@property (nonatomic,strong) NSString *warning_code;//预警代码
@property (nonatomic,strong) NSString *warning_title;//预警名称
@property (nonatomic,assign) int enabled;//预警开关 0－关闭 1－开启

@end
