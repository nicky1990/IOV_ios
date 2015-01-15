//
//  OBDTableView.h
//  ShareD
//
//  Created by newman on 15-1-1.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareDataSubclass.h"

@interface OBDTableView : UIView

/**********************************************************************
 * 函数名称: createTableView
 * 功能描述: 创建列表
 * 输入参数:
 * 输出参数:
 * 返 回 值：
 * 其它说明:
 * 修改日期			版本号		修改人		修改内容
 * ---------------------------------------------------------------------
 **********************************************************************/
- (void)createTableView;

/**********************************************************************
 * 函数名称: choseDataForDate:(NSDate*)date
 * 功能描述: 根据日期确定列表数据
 * 输入参数: date:日期
 * 输出参数:
 * 返 回 值：
 * 其它说明:
 * 修改日期			版本号		修改人		修改内容
 * ---------------------------------------------------------------------
 **********************************************************************/
- (void)choseDataForDate:(NSDate*)date;

@property(nonatomic,strong)NSMutableArray *list;

@end


