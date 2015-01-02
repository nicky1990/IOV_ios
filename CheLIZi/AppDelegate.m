//
//  AppDelegate.m
//  CheLIZi
//
//  Created by 点睛石 on 14-12-18.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomTabbar.h"
#import "HomeViewController.h"
#import "PersonCenterViewController.h"
#import "ShowDLineViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self UMShareUse];
    [self BaiduMapUse];
//    CustomTabbar *root = [[CustomTabbar alloc] init];
    
    [self createTabBar];
    
    
    self.window.rootViewController = _tabBarC;
    return YES;
}
-(void)BaiduMapUse{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"t1NHBIEzCIMfRFnyvEGNGHMr"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
-(void)createTabBar{
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [homeNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    homeVC.tabBarItem.title = @"首页";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"home_home"];
    homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"home_home"];
    
    PersonCenterViewController *personCenterVC = [[PersonCenterViewController alloc]init];
    UINavigationController *personCenterNav = [[UINavigationController alloc]initWithRootViewController:personCenterVC];
    [personCenterNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    personCenterVC.tabBarItem.title = @"个人中心";
    personCenterVC.tabBarItem.image = [UIImage imageNamed:@"home_person"];
    personCenterVC.tabBarItem.selectedImage = [UIImage imageNamed:@"home_person"];
    
    ShowDLineViewController *showDLineVC = [[ShowDLineViewController alloc]init];
    UINavigationController *showDLineNav = [[UINavigationController alloc]initWithRootViewController:showDLineVC];
    [showDLineNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    showDLineNav.tabBarItem.image = [UIImage imageNamed:@"home_compass"];
    
    _tabBarC = [[UITabBarController alloc]init];
    _tabBarC.tabBar.backgroundImage = [UIImage imageNamed:@"home_bottomback"];
    _tabBarC.tabBar.translucent  = NO;
    _tabBarC.tabBar.tintColor = [UIColor greenColor];
    
    [_tabBarC setViewControllers:[NSArray arrayWithObjects:homeNav,showDLineNav,personCenterNav, nil]];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}
#pragma mark UMShare
-(void)UMShareUse{
    
    [UMSocialData setAppKey:@"53843dba56240bc4661b1867"];
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    [UMSocialData openLog:YES];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
