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
#import "ToolImage.h"

#define kUserNameY (([[UIScreen mainScreen] bounds].size.height == 568)?40:25)
#define kButtonHeight (([[UIScreen mainScreen] bounds].size.height == 568)?125:81)
#define kButtonY (([[UIScreen mainScreen] bounds].size.height == 568)?75:45)

@interface HomeViewController () <ToolRequestDelegate>
{
    UIImageView *_headImage;
    UILabel *_nameLabel;
    UILabel *_messageNumLabel;
    UIButton *_nameButton;
    
}
@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    UIButton *homebtn = (UIButton *)[self.tabBarController.view viewWithTag:397];
    [homebtn setImage:[UIImage imageNamed:@"home_home_selected"] forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    UIButton *homebtn = (UIButton *)[self.tabBarController.view viewWithTag:397];
    [homebtn setImage:[UIImage imageNamed:@"home_home_default"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self customTab];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self getHomeData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateHeadImage) name:@"userheadimagechange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nichengChange:) name:@"nichengchange" object:nil];
}
-(void)updateHeadImage{
    _headImage.image = [ToolImage getHeadImage];
}
-(void)nichengChange:(NSNotification *)notifiction{
    NSDictionary *dic = notifiction.userInfo;
    NSString *nicheng = [dic objectForKey:@"nicheng"];
     [_nameButton setTitle:[NSString stringWithFormat:@" %@",nicheng] forState:UIControlStateNormal];
}
-(void)initUI{
    UIImageView *backGround = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 210)];
    backGround.image = [UIImage imageNamed:@"home222"];
    [self.view addSubview:backGround];
    
    UIImageView *backCirle = [[UIImageView alloc]initWithFrame:CGRectMake((kW_SreenWidth-185)/2.0, 80, 185, 185)];
    backCirle.image = [UIImage imageNamed:@"home_circle"];
    [self.view addSubview:backCirle];

    UIView *functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 210, kW_SreenWidth, kH_SreenHeight-210-49)];
    functionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:functionView];
    
    _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nameButton.frame = CGRectMake(0, kUserNameY, kW_SreenWidth, 18);
    [_nameButton setImage:[UIImage imageNamed:@"home_nameicon"] forState:UIControlStateNormal];
    _nameButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:18];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton setTitle:@" hello" forState:UIControlStateNormal];
    _nameButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    [functionView addSubview:_nameButton];
    
    
    
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake((kW_SreenWidth-120)/2.0, 112.5, 120, 120)];
    _headImage.layer.cornerRadius = _headImage.frame.size.width/2.0;
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.borderWidth = 4;
    _headImage.layer.borderColor = [kMAINCOLOR CGColor];
    _headImage.image = [UIImage imageNamed:@"home_headdefault"];
    [self.view addSubview:_headImage];
    
    UIButton *todaySignin = [CustomView buttonViewWithTitle:@"每日签到" withImageName:@"home_signin" withFrame:CGRectMake(40, kButtonY, 120, kButtonHeight)];
    [todaySignin addTarget:self action:@selector(todaySignIn) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview:todaySignin];
    
    UIButton *myCarStatus = [CustomView buttonViewWithTitle:@"爱车车况" withImageName:@"home_car" withFrame:CGRectMake(160, kButtonY, 120, kButtonHeight)];
    [myCarStatus addTarget:self action:@selector(myCarStatus) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview:myCarStatus];
    
    UIButton *todayLuck = [CustomView buttonViewWithTitle:@"天天好运" withImageName:@"home_goodluck" withFrame:CGRectMake(40, 50+kButtonHeight+4, 120, kButtonHeight)];
    [todayLuck addTarget:self action:@selector(todayLuckShow) forControlEvents:UIControlEventTouchUpInside];
    [functionView addSubview:todayLuck];
    
    UIButton *message = [CustomView buttonViewWithTitle:@"消息" withImageName:@"home_message" withFrame:CGRectMake(160, 50+kButtonHeight+4, 120, kButtonHeight)];
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
    __weak UIImageView *saftHeadImage = _headImage;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([ToolImage getHeadImage]) {
            saftHeadImage.image = [ToolImage getHeadImage];
        }else{
//            [_headImage setImageWithURL:[NSURL URLWithString:homeData.avatar] placeholderImage:[UIImage imageNamed:@"home_headdefault"]];
            [_headImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:homeData.avatar]] placeholderImage:[UIImage imageNamed:@"home_headdefault"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                saftHeadImage.image = image;
                [ToolImage saveHeadImage:image];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            }];
            
        }
        [_nameButton setTitle:[NSString stringWithFormat:@" %@",homeData.nickname] forState:UIControlStateNormal];
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
    UIButton *showDLineBtn = [CustomView getButtonWithFrame:CGRectMake(kW_SreenWidth/2.0-29, -10, 58, 58) withImage:@"home_compass" withTitle:nil withTarget:self andAction:@selector(showDLineBtnClick)];
    showDLineBtn.tag = 399;
    showDLineBtn.layer.cornerRadius = 29;
    showDLineBtn.layer.backgroundColor = [RGBCOLOR(79, 92, 98)CGColor];
    showDLineBtn.layer.borderWidth = 2;
    showDLineBtn.layer.borderColor = [RGBCOLOR(79, 92, 98)CGColor];
    [view addSubview:showDLineBtn];
    
    UIButton *homeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (kW_SreenWidth-65)/2.0, 49)];
    [homeBtn setImage:[UIImage imageNamed:@"home_home_selected"] forState:UIControlStateNormal];
    
    [homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    homeBtn.tintColor = RGBCOLOR(14, 180, 147);
    homeBtn.tag = 397;
    [view addSubview:homeBtn];
    
    UIButton *personBtn = [[UIButton alloc]initWithFrame:CGRectMake((kW_SreenWidth-65)/2.0+65, 0, (kW_SreenWidth-65)/2.0, 49)];
    [personBtn setImage:[UIImage imageNamed:@"home_person_default"] forState:UIControlStateNormal];
    
    [personBtn addTarget:self action:@selector(personBtnClick) forControlEvents:UIControlEventTouchUpInside];
    personBtn.tag = 398;
    [view addSubview:personBtn];
    
    [self.tabBarController.view addSubview:view];
}
-(void)homeBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIButton *btn = (UIButton *)[self.tabBarController.view viewWithTag:399];
    [btn setImage:[UIImage imageNamed:@"home_compass"] forState:UIControlStateNormal];
    [btn setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_compass"]]];
    self.tabBarController.selectedIndex = 0;
    
    UIButton *homebtn = (UIButton *)[self.tabBarController.view viewWithTag:397];
    [homebtn setImage:[UIImage imageNamed:@"home_home_selected"] forState:UIControlStateNormal];
    UIButton *personbtn = (UIButton *)[self.tabBarController.view viewWithTag:398];
    [personbtn setImage:[UIImage imageNamed:@"home_person_default"] forState:UIControlStateNormal];
    
    
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
    
    UIButton *homebtn = (UIButton *)[self.tabBarController.view viewWithTag:397];
    [homebtn setImage:[UIImage imageNamed:@"home_home_default"] forState:UIControlStateNormal];
    UIButton *personbtn = (UIButton *)[self.tabBarController.view viewWithTag:398];
    [personbtn setImage:[UIImage imageNamed:@"home_person_default"] forState:UIControlStateNormal];
}
-(void)personBtnClick{
    NSArray *array = self.tabBarController.viewControllers;
    UINavigationController *nav = (UINavigationController *)array[2];
    [nav popToRootViewControllerAnimated:YES];

    UIButton *btn = (UIButton *)[self.tabBarController.view viewWithTag:399];
    [btn setImage:[UIImage imageNamed:@"home_compass"] forState:UIControlStateNormal];
    [btn setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_compass"]]];
    
    self.tabBarController.selectedIndex = 2;
    
    UIButton *homebtn = (UIButton *)[self.tabBarController.view viewWithTag:397];
    [homebtn setImage:[UIImage imageNamed:@"home_home_default"] forState:UIControlStateNormal];
    UIButton *personbtn = (UIButton *)[self.tabBarController.view viewWithTag:398];
    [personbtn setImage:[UIImage imageNamed:@"home_person_selected"] forState:UIControlStateNormal];
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"userheadimagechange" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"nichengchange" object:nil];
}

@end
