//
//  LoginViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/24.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "LoginViewController.h"
#import "UITextField+LeftImage.h"
#import "RegistViewController.h"
#import "ResetPsdViewController.h"
#import "HomeViewController.h"
#import "PersonCenterViewController.h"
#import "CustomView.h"
#import "ShareDLineViewController.h"


@interface LoginViewController ()<UITextFieldDelegate,ToolRequestDelegate>
{
    UITabBarController *_tabBarC;
}
@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"]) {
        [self autoLogin];
    }
    
    self.title = @"登录";
    // Do any additional setup after loading the view from its nib.
    [self customNavigationButton];
    [self setUI];
    
}
-(void)autoLogin{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"devicetoken"];
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumberDefault"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordDefault"];
    NSDictionary *paraDic = @{@"c":@"public",
                              @"a":@"login",
                              @"t":[Tool getCurrentTimeStamp],
                              @"device_system":kDEVICE_SYSTEM,
                              @"device_token":deviceToken,
                              @"app_key":kAPP_KEY,
                              @"user_name":phoneNum,
                              @"signature":kSIGNATURE,
                              @"password":[Tool teaEncryptWithString:password]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
    
    
}

#pragma mark 控件属性
-(void)setUI{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumberDefault"] != nil) {
        self.userPhoneNum.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumberDefault"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"passwordDefault"] != nil) {
        self.userPassword.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordDefault"];
    }
    self.userHead.layer.cornerRadius = self.userHead.frame.size.width/2.0;
    self.userHead.layer.masksToBounds = YES;
    [self.userPhoneNum setLeftImageWithImage:@"login_user"];
    [self.userPassword setLeftImageWithImage:@"login_password"];
}

-(void)customNavigationButton{
    self.navigationItem.leftBarButtonItem = nil;
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"login_close"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonClick)];
//    leftBarButton.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_close"]];
//    self.navigationItem.leftBarButtonItem = leftBarButton;
}

-(void)leftButtonClick{
    [self.navigationController pushViewController:_tabBarC animated:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma textField Delete Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (kH_SreenHeight == 480) {
        CGRect frame = self.view.frame;
        frame.origin.y-= 70;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
   
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (kH_SreenHeight == 480) {
        CGRect frame = self.view.frame;
        frame.origin.y+= 70;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = frame;
        [UIView commitAnimations];
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

- (IBAction)loginRequest:(UIButton *)sender {

    [self.view endEditing:YES];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"devicetoken"];
    NSString *phoneNum = [self.userPhoneNum.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.userPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([Tool checkPhoneNumber:phoneNum]) {
        if(password.length == 0){
            [Tool showAlertMessage:@"请输入密码！"];
        }else{
            NSUserDefaults *phoneNumDefault = [NSUserDefaults standardUserDefaults];
            [phoneNumDefault setObject:phoneNum forKey:@"phoneNumberDefault"];
            [phoneNumDefault setObject:password forKey:@"passwordDefault"];
            [phoneNumDefault setBool:YES forKey:@"isLogin"];
            [phoneNumDefault synchronize];
            NSDictionary *paraDic = @{@"c":@"public",
                                      @"a":@"login",
                                      @"t":[Tool getCurrentTimeStamp],
                                      @"device_system":kDEVICE_SYSTEM,
                                      @"device_token":deviceToken,
                                      @"app_key":kAPP_KEY,
                                      @"user_name":phoneNum,
                                      @"signature":kSIGNATURE,
                                      @"password":[Tool teaEncryptWithString:password]
                                      };
            ToolRequest *toolRequest = [[ToolRequest alloc]init];
            [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
        }
    }else{
        [Tool showAlertMessage:@"请输入正确的手机号！"];
    }

}

- (IBAction)registClick:(UIButton *)sender {
    RegistViewController *registVC = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}
-(void)createTabBar{
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [homeNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];

    PersonCenterViewController *personCenterVC = [[PersonCenterViewController alloc]init];
    UINavigationController *personCenterNav = [[UINavigationController alloc]initWithRootViewController:personCenterVC];
    [personCenterNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];

    
    ShareDLineViewController *shareDLineViewController = [[ShareDLineViewController alloc]init];
    UINavigationController *showDLineNav = [[UINavigationController alloc]initWithRootViewController:shareDLineViewController];
    [showDLineNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    _tabBarC = [[UITabBarController alloc]init];
    [_tabBarC setViewControllers:[NSArray arrayWithObjects:homeNav,showDLineNav,personCenterNav, nil]];
}

#pragma mark Request Succeed
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    NSNumber *userid = [dic objectForKey:@"user_id"];
    NSString *usersid = [dic objectForKey:@"sid"];
    NSString *useraccess_token = [dic objectForKey:@"access_token"];
    [UserInfo sharedUserInfo].user_id = userid;
    [UserInfo sharedUserInfo].userS_id = usersid;
    [UserInfo sharedUserInfo].userAccess_token = useraccess_token;
    [self createTabBar];
    [self.navigationController pushViewController:_tabBarC animated:YES];
}

- (IBAction)forgetPsdClick:(UIButton *)sender {
    ResetPsdViewController *resetPsdVC = [[ResetPsdViewController alloc]init];
    [self.navigationController pushViewController:resetPsdVC animated:YES];
}
@end
