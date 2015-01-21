//
//  RegistViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/24.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "RegistViewController.h"
#import "UITextField+LeftImage.h"
#import "HomeViewController.h"
#import "PersonCenterViewController.h"
#import "ShareDLineViewController.h"

@interface RegistViewController () <UITextFieldDelegate,ToolRequestDelegate>
{
    UIButton *_getVerifyCodeBtn;
    UILabel *_timeLabel;
    int statusTime;
    NSString *_netVerifyCode;
}
@end

@implementation RegistViewController
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
    self.title = @"注册";
    // Do any additional setup after loading the view from its nib.
    [self customNavigationButton];
    [self setUI];
    NSLog(@"%@",[UserInfo sharedUserInfo].user_id);
    NSLog(@"%@",[UserInfo sharedUserInfo].userS_id);
    NSLog(@"%@",[UserInfo sharedUserInfo].userAccess_token);
}

#pragma mark 控件属性
-(void)setUI{
    [self.userPhoneNum setLeftImageWithImage:@"regist_phone"];
    [self.userPassword setLeftImageWithImage:@"regist_lock"];
    [self.userPasswordAgain setLeftImageWithImage:@"regist_lock"];
    [self.verifyCode setLeftImageWithImage:@"regist_verify"];
    UIView *rigthView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, self.verifyCode.frame.size.height)];
    _getVerifyCodeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _getVerifyCodeBtn.frame = CGRectMake(0, 10, 90, 25);
    _getVerifyCodeBtn.backgroundColor = RGBCOLOR(236, 236, 237);
    _getVerifyCodeBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    [_getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifyCodeBtn setTintColor:[UIColor blackColor]];
    [_getVerifyCodeBtn addTarget:self action:@selector(verifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 4, 30, 15)];
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    [_getVerifyCodeBtn addSubview:_timeLabel];
    
    statusTime = 60;
    [rigthView addSubview:_getVerifyCodeBtn];
    self.verifyCode.rightView = rigthView;
    self.verifyCode.rightViewMode = UITextFieldViewModeAlways;
    
}

-(void)updateTime{
    statusTime--;
    _getVerifyCodeBtn.userInteractionEnabled = NO;
    if (statusTime == 0 ) {
        _getVerifyCodeBtn.userInteractionEnabled = YES;
        [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateTime) object:nil];
        _timeLabel.text = @"";
        statusTime = 60;
        _getVerifyCodeBtn.userInteractionEnabled = YES;
    }else{
        NSString *title = [NSString stringWithFormat:@"(%d)",statusTime];
        _timeLabel.text = title;
        [self performSelector:@selector(updateTime) withObject:self afterDelay:1];
    }
    
}

#pragma mark Request Succeed
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    NSString *phoneNum = [self.userPhoneNum.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.userPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSUserDefaults *phoneNumDefault = [NSUserDefaults standardUserDefaults];
    [phoneNumDefault setObject:phoneNum forKey:@"phoneNumberDefault"];
    [phoneNumDefault setObject:password forKey:@"passwordDefault"];
    [phoneNumDefault setBool:YES forKey:@"isLogin"];
    [phoneNumDefault synchronize];
    
    NSNumber *userid = [dic objectForKey:@"user_id"];
    NSString *usersid = [dic objectForKey:@"sid"];
    NSString *useraccess_token = [dic objectForKey:@"access_token"];
    [UserInfo sharedUserInfo].user_id = userid;
    [UserInfo sharedUserInfo].userS_id = usersid;
    [UserInfo sharedUserInfo].userAccess_token = useraccess_token;
    
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [homeNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    
    PersonCenterViewController *personCenterVC = [[PersonCenterViewController alloc]init];
    UINavigationController *personCenterNav = [[UINavigationController alloc]initWithRootViewController:personCenterVC];
    [personCenterNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    
    
    ShareDLineViewController *shareDLineViewController = [[ShareDLineViewController alloc]init];
    UINavigationController *showDLineNav = [[UINavigationController alloc]initWithRootViewController:shareDLineViewController];
    [showDLineNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
     UITabBarController *tabBarC = [[UITabBarController alloc]init];
    [tabBarC setViewControllers:[NSArray arrayWithObjects:homeNav,showDLineNav,personCenterNav, nil]];
    [self.navigationController pushViewController:tabBarC animated:YES];
}

#pragma textField Delete Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (kH_SreenHeight == 480 && (textField.tag == 101 ||textField.tag == 102)) {
        CGRect frame = self.view.frame;
        frame.origin.y-= 70;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (kH_SreenHeight == 480 && (textField.tag == 101||textField.tag == 102)) {
        CGRect frame = self.view.frame;
        frame.origin.y+= 70;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

-(void)customNavigationButton{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonClick)];
    leftBarButton.tintColor = RGBCOLOR(161, 164, 167);
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
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
-(void)verifyBtnClick{
    _getVerifyCodeBtn.userInteractionEnabled = NO;
    NSString *phoneNum = [self.userPhoneNum.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([Tool checkPhoneNumber:phoneNum]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *paraDic = @{@"c":@"public",
                                  @"a":@"verify",
                                  @"t":[Tool getCurrentTimeStamp],
                                  @"app_key":kAPP_KEY,
                                  @"telephone":phoneNum,
                                  @"type":[NSNumber numberWithInt:0]
                                  };        
        [[ToolRequest getRequestManager] POST:BASEURL parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",responseObject);
            NSDictionary *dic = responseObject;
            if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
                [Tool showAlertMessage:@"验证码已发出，请查看短信"];
                statusTime = 60;
                [self performSelector:@selector(updateTime) withObject:nil afterDelay:1];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *failMessage = [dic objectForKey:@"error_msg"];
                [Tool showAlertMessage:failMessage];
                _getVerifyCodeBtn.userInteractionEnabled = YES;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"失败%@",error);
            [Tool showAlertMessage:@"网络请求失败，请重试！"];
            _getVerifyCodeBtn.userInteractionEnabled = YES;
        }];
    }else{
        _getVerifyCodeBtn.userInteractionEnabled = YES;
        [Tool showAlertMessage:@"请输入正确的手机号！"];
    }
}

- (IBAction)registRequet:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"devicetoken"];
    if (!deviceToken) {
        deviceToken = @"";
    }
    NSString *phoneNum = [self.userPhoneNum.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.userPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordAgain = [self.userPasswordAgain.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *veifyCode = [self.verifyCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([Tool checkPhoneNumber:phoneNum]) {
        if(password.length == 0){
            [Tool showAlertMessage:@"请输入密码！"];
        }else if(passwordAgain.length == 0){
            [Tool showAlertMessage:@"请输入确认密码！"];
        }else if(veifyCode.length == 0){
            [Tool showAlertMessage:@"请输入验证码！"];
        }else if(![passwordAgain isEqualToString:password]){
            [Tool showAlertMessage:@"密码与验证密码不一致！请重新输入！"];
        }else if([passwordAgain isEqualToString:password]){
            NSDictionary *paraDic = @{@"c":@"public",
                                      @"a":@"register",
                                      @"t":[Tool getCurrentTimeStamp],
                                      @"device_token":deviceToken,
                                      @"device_system":kDEVICE_SYSTEM,
                                      @"app_key":kAPP_KEY,
                                      @"mobile":phoneNum,
                                      @"signature":kSIGNATURE,
                                      @"password":[Tool teaEncryptWithString:password],
                                      @"verify_code":veifyCode
                                      };
            ToolRequest *toolRequest = [[ToolRequest alloc]init];
            [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
        }
    }else{
        [Tool showAlertMessage:@"请输入正确的手机号！"];
    }
}

- (IBAction)protocolClick:(UIButton *)sender {
}
@end
