//
//  CustomView.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/31.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView
+(UIButton *)buttonViewWithTitle:(NSString *)title withImageName:(NSString *)imageName withFrame:(CGRect) rect{
    
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempButton.frame = rect;
    UIImageView *contentImage = [[UIImageView alloc]initWithFrame:CGRectMake((rect.size.width-67)/2.0, 0, 67, 67)];
    contentImage.image = [UIImage imageNamed:imageName];
    [tempButton addSubview:contentImage];
    
    UILabel *contentLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, 70, rect.size.width, 14)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont fontWithName:@"Arial" size:14];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = title;
    [tempButton addSubview:contentLabel];
    return tempButton;
}

+(UILabel *)getLabelWith:(CGRect)rect andSize:(NSInteger)size{
    UILabel *label =  [[UILabel alloc]initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Heiti SC" size:size];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+(UIButton *)getButtonWithFrame:(CGRect)rect withImage:(NSString *)imageName withTitle:(NSString *)title withTarget:(UIViewController *)VC andAction:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:imageName]]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:VC action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
