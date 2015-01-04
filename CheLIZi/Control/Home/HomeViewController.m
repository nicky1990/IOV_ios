//
//  HomeViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/25.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomView.h"
#import "CarStatusViewController.h"
#import "LoginViewController.h"

#define kUserNameY (([[UIScreen mainScreen] bounds].size.height == 568)?45:25)
#define kButtonHeight (([[UIScreen mainScreen] bounds].size.height == 568)?125:81)
#define kButtonY (([[UIScreen mainScreen] bounds].size.height == 568)?75:50)

@interface HomeViewController ()
{
    UIImageView *_headImage;
    UILabel *_nameLabel;
}
@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    
}

-(void)initUI{
    UIImageView *backGround = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 210)];
    backGround.image = [UIImage imageNamed:@"home_backgroud"];
    [self.view addSubview:backGround];
    
    UIImageView *backCirle = [[UIImageView alloc]initWithFrame:CGRectMake((kW_SreenWidth-185)/2.0, 80, 185, 185)];
    backCirle.image = [UIImage imageNamed:@"home_circle"];
    [self.view addSubview:backCirle];

    UIView *functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 210, kW_SreenWidth, kH_SreenHeight-210-49)];
    functionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:functionView];
    
    UIImageView *userHeadIcon = [[UIImageView alloc]initWithFrame:CGRectMake(80, kUserNameY, 13, 21)];
    userHeadIcon.image = [UIImage imageNamed:@"home_nameicon"];
    [functionView addSubview:userHeadIcon];
    _nameLabel =  [[UILabel alloc]initWithFrame:CGRectMake(105, kUserNameY, kW_SreenWidth-110, 21)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont fontWithName:@"Arial" size:21];
    _nameLabel.text = @"张三李四";
    [functionView addSubview:_nameLabel];
    
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake((kW_SreenWidth-120)/2.0, 112.5, 120, 120)];
    _headImage.layer.cornerRadius = _headImage.frame.size.width/2.0;
    _headImage.layer.masksToBounds = YES;
    _headImage.image = [UIImage imageNamed:@"home_headdefault"];
    [self.view addSubview:_headImage];
    
    UIButton *todaySignin = [CustomView buttonViewWithTitle:@"每日签到" withImageName:@"home_signin" withFrame:CGRectMake(0, kButtonY, kW_SreenWidth/2, kButtonHeight)];
    [todaySignin addTarget:self action:@selector(todaySignIn) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview:todaySignin];
    
    UIButton *myCarStatus = [CustomView buttonViewWithTitle:@"爱车车况" withImageName:@"home_car" withFrame:CGRectMake(160, kButtonY, kW_SreenWidth/2, kButtonHeight)];
    [myCarStatus addTarget:self action:@selector(myCarStatus) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview:myCarStatus];
    
    UIButton *todayLuck = [CustomView buttonViewWithTitle:@"天天好运" withImageName:@"home_goodluck" withFrame:CGRectMake(0, 50+kButtonHeight+4, kW_SreenWidth/2, kButtonHeight)];
    [todayLuck addTarget:self action:@selector(todayLuckShow) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview:todayLuck];
    
    UIButton *message = [CustomView buttonViewWithTitle:@"消息" withImageName:@"home_message" withFrame:CGRectMake(160, 50+kButtonHeight+4, kW_SreenWidth/2, kButtonHeight)];
    [message addTarget:self action:@selector(messageShow) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview:message];
}
//今日签到
-(void)todaySignIn{
    NSLog(@"今日签到");
}

//爱车车况
-(void)myCarStatus{
    CarStatusViewController *carStatus = [[CarStatusViewController alloc]init];
    [self.navigationController pushViewController:carStatus animated:YES];
}

//天天好运
-(void)todayLuckShow{
    
}

//消息
-(void)messageShow{
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
