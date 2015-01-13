//
//  AddCarUI.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/12.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "AddCarUI.h"

@implementation AddCarUI

+(UITextField *)getUITextFieldWithRect:(CGRect)rect withImageName:(NSString *)imageName withStringHolder:(NSString *)stringHolder{
    
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [RGBCOLOR(215, 215, 215) CGColor];
    //    textField.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    textField.backgroundColor = [UIColor whiteColor];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, rect.size.height)];
    UIImageView *leftViewImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    leftViewImage.center = leftView.center;
    [leftView addSubview:leftViewImage];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    NSDictionary *att = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:12]};
    //    NSAttributedString *tempString = [[NSAttributedString alloc]initWithString:stringHolder attributes:att];
    //    textField.attributedPlaceholder = tempString;
    textField.placeholder = stringHolder;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return textField;
}


@end
