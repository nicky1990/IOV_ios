//
//  CustomTabbar.m
//  百搭
//
//  Created by 西搜 on 14-6-28.
//  Copyright (c) 2014年 sisoinfo. All rights reserved.
//
//  自定义导航栏

#import "CustomTabbar.h"
#import "HomeViewController.h"
#import "PersonCenterViewController.h"
#import "ShowDLineViewController.h"

@interface CustomTabbar ()

@end

@implementation CustomTabbar

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cbCurView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kW_SreenWidth, kH_SreenHeight)];
        _cbTarBar = [[UIView alloc] initWithFrame:CGRectMake(0, kH_SreenHeight-49, kW_SreenWidth, 49)];
        _cbTarBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bottomback"]];
//        _cbTarBar.alpha = 0.3;
//        _cbTarBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
//        _cbTarBar.layer.borderWidth = 0.32;
//        _cbTarBar.layer.borderColor = [[UIColor grayColor] CGColor];
        _cbViewControllers = [[NSArray alloc] init];
        
        _cbTarBar.tag = 20080;
        _cbCurView.tag = 20081;
    }
    return self;
}




-(void)tabbartest{
    if (_cbTarBar.center.y < kH_SreenHeight) {
        [UIView animateWithDuration:0.3f animations:^{
            _cbTarBar.center = CGPointMake(_cbTarBar.center.x, _cbTarBar.center.y+49+30);
        }];
    }
}

-(void)moveTabbar{
    if (_cbTarBar.center.y > kH_SreenHeight) {
        [UIView animateWithDuration:0.3f animations:^{
            _cbTarBar.center = CGPointMake(_cbTarBar.center.x, _cbTarBar.center.y-49-30);
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏tabbar
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabbartest) name:@"hideTabbar" object:Nil];
    //显示tabbar
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveTabbar) name:@"moveTabbar" object:Nil];
    
    
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:_cbCurView];
    [self.view addSubview:_cbTarBar];
 
    [self _initUI2];

    
    [_cbCurView addSubview:self.nav1.view];
    NSArray *tabbarArr=[[NSArray alloc]initWithObjects:@"首页",@"",@"个人中心", nil];
    self.imageArr = [[NSMutableArray alloc]initWithObjects:@"home_home",@"home_compass",@"home_person", nil];
    self.select_image = [[NSMutableArray alloc]initWithObjects:@"home_home",@"home_compass",@"home_person", nil];
    

    //设置TabBar的button按钮
    for (int i = 0; i < _cbViewControllers.count; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        
        b.titleLabel.font=[UIFont systemFontOfSize:11];
        b.titleLabel.textAlignment = NSTextAlignmentCenter;

        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        b.frame= CGRectMake(kW_SreenWidth/_cbViewControllers.count*i, 0, kW_SreenWidth/_cbViewControllers.count, 49);
        
        b.tag = 100 + i;
        
        [b setImage:[UIImage imageNamed:self.imageArr[i]] forState:UIControlStateNormal];
        [b setTitle:[NSString stringWithFormat:@"%@",tabbarArr[i]] forState:UIControlStateNormal];
        
        if (i != 2) {
            [b setImageEdgeInsets:UIEdgeInsetsMake(-7, 21, 5, 12)];
            [b setTitleEdgeInsets:UIEdgeInsetsMake(30, -22, 0, 0)];
         
        }else{
            b.frame= CGRectMake(kW_SreenWidth/_cbViewControllers.count*i-3, 0, kW_SreenWidth/_cbViewControllers.count+6, 49);
            [b setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
            [b setTitleEdgeInsets:UIEdgeInsetsMake(27, -65, 0, 0)];
        }
        if (0 == i) {
            [b setImageEdgeInsets:UIEdgeInsetsMake(-7, 70, 5, 12)];
            [b setTitleEdgeInsets:UIEdgeInsetsMake(30, 30, 0, 0)];
            
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [b addTarget:self action:@selector(changeNav:) forControlEvents:UIControlEventTouchUpInside];
        [_cbTarBar addSubview:b];
    }

}




-(void)_initUI2{
//   self.nav1 = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [homeNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    PersonCenterViewController *personCenterVC = [[PersonCenterViewController alloc]init];
    UINavigationController *personCenterNav = [[UINavigationController alloc]initWithRootViewController:personCenterVC];
    [personCenterNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    ShowDLineViewController *showDLineVC = [[ShowDLineViewController alloc]init];
    UINavigationController *showDLineNav = [[UINavigationController alloc]initWithRootViewController:showDLineVC];
    [showDLineNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    
    self.cbViewControllers = @[homeNav,showDLineNav,personCenterNav];
}


int preTag = 100;

- (void)changeNav:(UIButton *)b
{
    
    int x = (int)b.tag-100;
    int y = preTag-100;
    NSLog(@"Y:%d",y);
    UIButton * preBtn = (UIButton *)[self.view viewWithTag:preTag];
    
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [preBtn setImage:[UIImage imageNamed:self.imageArr[y]] forState:UIControlStateNormal];
    
    [b setImage:[UIImage imageNamed:self.select_image[x]] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    preTag = (int)b.tag;
    UINavigationController *nav = self.cbViewControllers[b.tag-100];
    for (UIView *obj in _cbCurView.subviews)
    {
        [obj removeFromSuperview];
    }
    [_cbCurView addSubview:nav.view];
    
}



-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}




-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideTabbar" object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"moveTabbar" object:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
