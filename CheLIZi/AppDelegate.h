//
//  AppDelegate.h
//  CheLIZi
//
//  Created by 点睛石 on 14-12-18.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarC;
@property (strong,nonatomic) BMKMapManager *mapManager;
@end
