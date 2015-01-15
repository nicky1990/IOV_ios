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
#import "HomeData.h"
#import "UIImageView+AFNetworking.h"
#import "MessageViewController.h"
#import "WebViewController.h"
#import "ShareDLineViewController.h"
#import "PersonCenterViewController.h"

#define kUserNameY (([[UIScreen mainScreen] bounds].size.height == 568)?45:25)
#define kButtonHeight (([[UIScreen mainScreen] bounds].size.height == 568)?125:81)
#define kButtonY (([[UIScreen mainScreen] bounds].size.height == 568)?75:50)

@interface HomeViewController () <ToolRequestDelegate>
{
    UIImageView *_headImage;
    UILabel *_nameLabel;
    UILabel *_messageNumLabel;
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
    [self customTab];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self getHomeData];
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
    _nameLabel.font = [UIFont fontWithName:@"Arial" size:19];
    _nameLabel.text = @"hello";
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
    
    _messageNumLabel = [CustomView getLabelWith:CGRectMake(90, 0, 30, 20) andSize:12];
    _messageNumLabel.layer.cornerRadius = 10;
    _messageNumLabel.layer.backgroundColor = [[UIColor redColor]CGColor];
    _messageNumLabel.textColor = [UIColor whiteColor];
    _messageNumLabel.hidden = YES;
    [message addSubview:_messageNumLabel];
    
    [functionView addSubview:message];
}
//今日签到
-(void)todaySignIn{
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.title = @"每日签到";
    NSString *urtStr = [NSString stringWithFormat:@"%@?c=html5&a=sign&access_token=%@",BASEURL,[UserInfo sharedUserInfo].userAccess_token];
    webVC.urlStr = urtStr;
    [self.navigationController pushViewController:webVC animated:YES];
}

//爱车车况
-(void)myCarStatus{
    CarStatusViewController *carStatus = [[CarStatusViewController alloc]init];
    [self.navigationController pushViewController:carStatus animated:YES];
}

//天天好运
-(void)todayLuckShow{
//    http://www.gulucar.cn/api.php?c=html5&a=lotterys&access_token=xxxx
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.title = @"天天好运";
    NSString *urtStr = [NSString stringWithFormat:@"%@?c=html5&a=lotterys&access_token=%@",BASEURL,[UserInfo sharedUserInfo].userAccess_token];
    webVC.urlStr = urtStr;
    [self.navigationController pushViewController:webVC animated:YES];
}

//消息
-(void)messageShow{
    _messageNumLabel.hidden = YES;
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark Request
-(void)getHomeData{
    NSDictionary *paraDic = @{@"c":@"user",
                              @"a":@"index",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"signature":kSIGNATURE,
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}
#pragma mark Request Succeed
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    HomeData *homeData = [HomeData objectWithKeyValues:dic];
    [UserInfo sharedUserInfo].car_id = homeData.car_id;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_headImage setImageWithURL:[NSURL URLWithString:homeData.avatar] placeholderImage:[UIImage imageNamed:@"home_headdefault"]];
        _nameLabel.text = homeData.nickname;
        if (homeData.message_new > 0) {
            _messageNumLabel.hidden = NO;
            _messageNumLabel.text = [NSString stringWithFormat:@"%d",homeData.message_new];
        }else{
            _messageNumLabel.hidden = YES;
        }
    });
}

#pragma mark Custom Tabbar
-(void)customTab{
    for(UIView *view in self.tabBarController.view.subviews){
        if([view isKindOfClass:[UITabBar class]]){
            view.hidden = YES;
            break;
        }
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kH_SreenHeight-49, kW_SreenWidth, 49)];
//    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bottomback"]];
    view.backgroundColor = RGBCOLOR(79, 92, 98);
    UIButton *showDLineBtn = [CustomView getButtonWithFrame:CGRectMake(kW_SreenWidth/2.0-32.5, -15, 56, 56) withImage:@"home_compass" withTitle:nil withTarget:self andAction:@selector(showDLineBtnClick)];
    showDLineBtn.tag = 399;
    showDLineBtn.layer.cornerRadius = 28;
    showDLineBtn.layer.backgroundColor = [RGBCOLOR(79, 92, 98)CGColor];
    showDLineBtn.layer.borderWidth = 2;
    showDLineBtn.layer.borderColor = [RGBCOLOR(79, 92, 98)CGColor];
    [view addSubview:showDLineBtn];
    
    UIButton *homeBtn = [self getButton:@"首页" withImage:@"home_home" withFrame:CGRectMake(0, 0, (kW_SreenWidth-65)/2.0, 49)];
    [homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:homeBtn];
    
    UIButton *personBtn = [self getButton:@"个人中心" withImage:@"home_person" withFrame:CGRectMake((kW_SreenWidth-65)/2.0+65, 0, (kW_SreenWidth-65)/2.0, 49)];
    [personBtn addTarget:self action:@selector(personBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:personBtn];
    
    [self.tabBarController.view addSubview:view];
}
-(void)homeBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIButton *btn = (UIButton *)[self.tabBarController.view viewWithTag:399];
    [btn setImage:[UIImage imageNamed:@"home_compass"] forState:UIControlStateNormal];
    [btn setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_compass"]]];
    self.tabBarController.selectedIndex = 0;
}
-(void)showDLineBtnClick{
    if (self.tabBarController.selectedIndex == 1) {
        NSArray *array = self.tabBarController.viewControllers;
        for (UINavigationController *nav in array) {
            if ([nav.visibleViewController isMemberOfClass:[ShareDLineViewController class]]) {
                ShareDLineViewController *share = (ShareDLineViewController *)nav.visibleViewController;
                [share captureScreen];
            }
        }
        
    }else{
        self.tabBarController.selectedIndex = 1;
        UIButton *btn = (UIButton *)[self.tabBarController.view viewWithTag:399];
        [btn setImage:[UIImage imageNamed:@"home_share"] forState:UIControlStateNormal];
        [btn setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_share"]]];
    }
}
-(void)personBtnClick{
    NSArray *array = self.tabBarController.viewControllers;
    UINavigationController *nav = (UINavigationController *)array[2];
    [nav popToRootViewControllerAnimated:YES];

    UIButton *btn = (UIButton *)[self.tabBarController.view viewWithTag:399];
    [btn setImage:[UIImage imageNamed:@"home_compass"] forState:UIControlStateNormal];
    [btn setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_compass"]]];
    self.tabBarController.selectedIndex = 2;
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
-(UIButton *)getButton:(NSString *)buttonTitle withImage:(NSString *)imgName withFrame:(CGRect) rect{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    UIImageView *messageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    float messageViewY = button.frame.size.height/5;
    messageView.frame = CGRectMake((rect.size.width-20)/2.0,messageViewY , 20, 20);
    [button addSubview:messageView];
    UILabel *messageLable = [[UILabel alloc]initWithFrame:CGRectMake(0, messageViewY+25, rect.size.width, 10)];
    messageLable.backgroundColor = [UIColor clearColor];
    messageLable.textAlignment = NSTextAlignmentCenter;
    messageLable.textColor = [UIColor whiteColor];
    messageLable.font = [UIFont fontWithName:@"Arial" size:10];
    messageLable.text = buttonTitle;
    [button addSubview:messageLable];
    return button;
}
@end
