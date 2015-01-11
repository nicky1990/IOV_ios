//
//  TrackUI.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/11.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "TrackUI.h"

@implementation TrackUI

+(UIButton *)getBtnFrame:(CGRect)rect withImageName:(NSString*)name withColor:(UIColor *)color withFontSize:(NSInteger)size{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:size];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

+(UILabel *)getLabelFrame:(CGRect)rect withTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.font = [UIFont fontWithName:@"Heiti SC" size:10];
    label.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:title];
    label.attributedText = attribute;
    return label;
    
}


@end
