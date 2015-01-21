//
//  AreaInfo.h
//  中国省市区数据库使用
//
//  Created by 点睛石 on 15/1/21.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaInfo : NSObject

@property (nonatomic,assign) int region_id;
@property (nonatomic,assign) int region_type;
@property (nonatomic,strong) NSString *region_name;

@end
