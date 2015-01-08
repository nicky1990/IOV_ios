//
//  CustomUITabBarController.m
//  ShareD
//
//  Created by newman on 15-1-5.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import "CustomUITabBarController.h"
#import "ShareDLineViewController.h"
#import "SphereMenu.h"

@interface CustomUITabBarController ()<SphereMenuDelegate>
{
    ShareDLineViewController *shareDLineViewController;
}
@end

@implementation CustomUITabBarController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIViewController *viewController = [[UIViewController alloc]init];
        
        //*************秀D线通过UINavigationController与UITabBarController集成方式********************//
        shareDLineViewController = [[ShareDLineViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:shareDLineViewController];
        viewController.view.backgroundColor = [UIColor greenColor];
        self.viewControllers = @[viewController,navigationController];
        //******************************************************************************************//
 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        UIViewController *viewController = [[UIViewController alloc]init];
        viewController.view.backgroundColor = [UIColor greenColor];
        shareDLineViewController = [[ShareDLineViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:shareDLineViewController];
        self.viewControllers = @[viewController,navigationController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hideRealTabBar];
    
    //创建底栏背景
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                          self.view.frame.size.height - self.view.frame.size.width*(49.0/375.0),
                                                                          self.view.frame.size.width,
                                                                          self.view.frame.size.width*(49.0/375.0))];
    [imageView setImage:[UIImage imageNamed:@"UITabBarBackground"]];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    //创建按钮
    UIButton *btn0 = [UIButton buttonWithType:0];
    [btn0 setFrame:CGRectMake(0, 0, self.view.frame.size.width/2.0, self.view.frame.size.width*(49.0/375.0))];
    btn0.tag = 0;
    [btn0 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn0 setImage:[UIImage imageNamed:@"LocalHomePage"] forState:UIControlStateNormal];
    [btn0 setImage:[UIImage imageNamed:@"LocalHomePage_P"] forState:UIControlStateHighlighted];
    [imageView addSubview:btn0];
    
    UIButton *btn1 = [UIButton buttonWithType:0];
    [btn1 setFrame:CGRectMake(self.view.frame.size.width/2.0, 0, self.view.frame.size.width/2.0, self.view.frame.size.width*(49.0/375.0))];
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
     [btn1 setImage:[UIImage imageNamed:@"PersonalCenter"] forState:UIControlStateNormal];
     [btn1 setImage:[UIImage imageNamed:@"PersonalCenter_P"] forState:UIControlStateHighlighted];
    [imageView addSubview:btn1];
    
    UIImage *startImage = [UIImage imageNamed:@"UITabBarBtn1"];
    UIImage *image1 = [UIImage imageNamed:@"UITabBarBtn2"];
    UIImage *image2 = [UIImage imageNamed:@"UITabBarBtn2"];
    UIImage *image3 = [UIImage imageNamed:@"UITabBarBtn2"];
    NSArray *images = @[image1, image2, image3];
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(self.view.frame.size.width/2.0,
                                                                                self.view.frame.size.height - self.view.frame.size.width*(49.0/375.0))
                                                         startImage:startImage
                                                      submenuImages:images];
    sphereMenu.delegate = self;
    [self.view addSubview:sphereMenu];
}

- (void)sphereDidSelected:(int)index
{
    NSLog(@"sphere %d selected", index);
    [shareDLineViewController captureScreen];
}

- (void)btnPressed:(UIButton *)sender
{
    self.selectedIndex = sender.tag;
}

- (void)hideRealTabBar{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
