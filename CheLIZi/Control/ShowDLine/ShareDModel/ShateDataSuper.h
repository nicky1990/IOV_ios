//
//  ShateDataSuper.h
//  ShareD
//
//  Created by newman on 15-1-10.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShateDataSuper : NSObject

/**********************************************************************
 * 函数名称: - (NSArray*)propertyKeys
 * 功能描述: 创建数据保存对象
 * 输入参数:
 * 输出参数:
 * 返 回 值：
 * 其它说明:
 * 修改日期			版本号		修改人		修改内容
 * ---------------------------------------------------------------------
 **********************************************************************/
- (NSDictionary *)convertDictionary;

/**********************************************************************
 * 函数名称: - (BOOL)reflectDataFromOtherObject:(NSObject*)dataSource
 * 功能描述: 还原数据保存对象
 * 输入参数:
 * 输出参数:
 * 返 回 值：
 * 其它说明:
 * 修改日期			版本号		修改人		修改内容
 * ---------------------------------------------------------------------
 **********************************************************************/
- (BOOL)reflectDataFromOtherObject:(NSObject*)dataSource;

@end
