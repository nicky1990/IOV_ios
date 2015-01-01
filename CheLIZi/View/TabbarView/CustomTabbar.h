//
//  CustomTabbar.h
//  百搭
//
//  Created by 西搜 on 14-6-28.
//  Copyright (c) 2014年 sisoinfo. All rights reserved.

//  自定义导航栏

#import <UIKit/UIKit.h>

@interface CustomTabbar : UIViewController

@property (nonatomic,strong) UIView *cbCurView;
@property (nonatomic,strong) NSArray *cbViewControllers;
@property (nonatomic,strong) UIView *cbTarBar;

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, strong) NSArray *select_image;


@property (nonatomic, strong)  UINavigationController *nav1;


@end
