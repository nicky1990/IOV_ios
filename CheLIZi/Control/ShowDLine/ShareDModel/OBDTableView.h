//
//  OBDTableView.h
//  ShareD
//
//  Created by newman on 15-1-1.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBDTableView : UIView

- (void)createTableView;

@property(nonatomic,strong)NSMutableArray *list;

@end

@interface OBDData : NSObject
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *time;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSMutableArray *imageArray;

/**********************************************************************
 * 函数名称: initWithTitle:(NSString*)title time:(NSString*)time content:(NSString*)content image:(UIImage *)image
 * 功能描述: 创建数据实例
 * 输入参数: title:标题 time:时间 content:内容 image:图片
 * 输出参数:
 * 返 回 值：
 * 其它说明:
 * 修改日期			版本号		修改人		修改内容
 * ---------------------------------------------------------------------
 **********************************************************************/
- (id)initWithTitle:(NSString*)title time:(NSString*)time content:(NSString*)content image:(NSMutableArray *)imageArray;

@end
