//
//  UITextField+LeftImage.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/25.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "UITextField+LeftImage.h"

@implementation UITextField (LeftImage)

-(void)setLeftImageWithImage:(NSString *)imageName{
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    UIImageView *leftViewImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    leftViewImage.center = leftView.center;
    [leftView addSubview:leftViewImage];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
