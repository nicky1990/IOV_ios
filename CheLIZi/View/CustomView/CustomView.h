//
//  CustomView.h
//  CheLIZi
//
//  Created by 点睛石 on 14/12/31.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomView : NSObject

+(UIButton *)buttonViewWithTitle:(NSString *)title withImageName:(NSString *)imageName withFrame:(CGRect) rect;
+(UILabel *)getLabelWith:(CGRect)rect andSize:(NSInteger)size;
+(UIButton *)getButtonWithFrame:(CGRect)rect withImage:(NSString *)imageName withTitle:(NSString *)title withTarget:(UIViewController *)VC andAction:(SEL)action;
@end
