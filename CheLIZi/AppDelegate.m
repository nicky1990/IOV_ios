//
//  AppDelegate.m
//  CheLIZi
//
//  Created by 点睛石 on 14-12-18.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "PersonCenterViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "LoginViewController.h"
#import "UMessage.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
//    if (launchOptions) {
//        ///获取到推送相关的信息
//        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    }
//    
    
    [self checkNetworkStatus];
    [self UMShareUse];
    [self BaiduMapUse];
    [UMessage startWithAppkey:@"54aa9a0afd98c5b0bd000352" launchOptions:launchOptions];
    [self UMPush];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [loginNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    self.window.rootViewController = loginNav;
    
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)BaiduMapUse{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"VgZrztloHFGen1uapvGwkY7W"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}
#pragma mark UMShare
-(void)UMShareUse{
    [UMSocialData setAppKey:@"54aa9a0afd98c5b0bd000352"];
    [UMSocialWechatHandler setWXAppId:@"wxa4c5165010a288ba" appSecret:@"871f9f5ff4a5ba90487401cf2df0229a" url:nil];
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
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
-(void)UMPush{
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
//    [UMessage setLogEnabled:YES];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"devicetoken"];
    NSLog(@"deviceToken : %@", token);
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSNumber *numberPush = [[NSUserDefaults standardUserDefaults]objectForKey:@"isUMPush"];
    
    if ([numberPush intValue] || (numberPush == nil)) {
         [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        [UMessage unregisterForRemoteNotifications];
    }
//    如需关闭推送，请使用[UMessage unregisterForRemoteNotifications]
   
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error : %@", [error localizedDescription]);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)checkNetworkStatus {
    //获取一个网络连接
    self.reachability = [Reachability reachabilityWithHostname:@"www.apple.com"];
    //订阅系统在网络连接状态改变时发的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
    //监控网络连接状态
    [self.reachability startNotifier];
}
//在网络连接状态改变时调用
- (void)reachabilityChanged {
    NetworkStatus status = [self.reachability currentReachabilityStatus];
    NSString *msg = nil;
    switch (status) {
        case NotReachable:
        {
            msg = @"没有可用网络";
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:@"请检查网络连接!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case ReachableViaWiFi:
            msg = @"通过WiFi连接";
            NSLog(@"网络连接方式：%@",msg);
            break;
        case ReachableViaWWAN:
            msg = @"通过2G/3G/4G连接";
            NSLog(@"网络连接方式：%@",msg);
            break;
        default:
            break;
    }
    
}
@end
