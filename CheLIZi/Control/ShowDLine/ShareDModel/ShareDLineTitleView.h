//
//  ShareDLineTitleView.h
//  ShareD
//
//  Created by newman on 15-1-1.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareDLineTitleViewDelegate
-(void)titleChoseDate:(NSDate*)date;

@end

@interface ShareDLineTitleView : UIView

@property(assign,nonatomic)id<ShareDLineTitleViewDelegate> delegate;

/**********************************************************************
 * 函数名称: setUserName:(NSString *)name userIcon:(UIImage *)icon
 * 功能描述: 创建控件
 * 输入参数: name:用户名 userIcon:用户头像
 * 输出参数:
 * 返 回 值：
 * 其它说明:
 * 修改日期			版本号		修改人		修改内容
 * ---------------------------------------------------------------------
 **********************************************************************/
- (void)setUserName:(NSString *)name userIcon:(UIImage *)icon delegate:(id)DateDelegate;

@end
