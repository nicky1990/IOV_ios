//
//  ToolSelectArea.h
//  中国省市区数据库使用
//
//  Created by 点睛石 on 15/1/21.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaInfo.h"

@interface ToolSelectArea : NSObject

+(NSMutableArray*)selectGetAreaWithId:(int)regionid;

@end
