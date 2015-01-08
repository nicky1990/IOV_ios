//
//  OBDTableViewCell.h
//  ShareD
//
//  Created by newman on 15-1-2.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBDTableViewCell : UITableViewCell

/**********************************************************************
 * 函数名称: createOBDTitle:(NSString *)str time:(NSString *)time content:(NSString*)content image:(NSMutableArray *)imageArray
 * 功能描述: 确定列表cell属性
 * 输入参数: str:标题 time:时间 content:内容 imageArray:图片
 * 输出参数:
 * 返 回 值：
 * 其它说明:
 * 修改日期			版本号		修改人		修改内容
 * ---------------------------------------------------------------------
 **********************************************************************/
- (void)createOBDTitle:(NSString *)str time:(NSString *)time content:(NSString*)content image:(NSMutableArray *)imageArray;

@end
