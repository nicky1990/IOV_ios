//
//  ResetPsdViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/25.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "ResetPsdViewController.h"
#import "UITextField+LeftImage.h"

@interface ResetPsdViewController ()<UITextFieldDelegate,ToolRequestDelegate>
{
    UIButton *_getVerifyCodeBtn;
    UILabel *_timeLabel;
    int statusTime;
}
@end

@implementation ResetPsdViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    // Do any additional setup after loading the view from its nib.
    [self customNavigationButton];
    [self setUI];
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
        
    }else{
        NSString *title = [NSString stringWithFormat:@"(%d)",statusTime];
        _timeLabel.text = title;
        [self performSelector:@selector(updateTime) withObject:self afterDelay:1];
    }
    
}
#pragma textField Delete Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (kH_SreenHeight == 480 && (textField.tag == 103 ||textField.tag == 104)) {
        CGRect frame = self.view.frame;
        frame.origin.y-= 70;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (kH_SreenHeight == 480 && (textField.tag == 103||textField.tag == 104)) {
        CGRect frame = self.view.frame;
        frame.origin.y+= 70;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

-(void)customNavigationButton{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonClick)];
    leftBarButton.tintColor = RGBCOLOR(161, 164, 167);
    self.navigationItem.leftBarButtonItem = leftBarButton;
}
-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Request Succeed
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    [Tool showAlertMessage:@"密码重置成功，请重新登录"];
    
    if (self.tabBarController != nil) {
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
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
                                  @"type":[NSNumber numberWithInt:1]
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
        [Tool showAlertMessage:@"请输入正确的手机号！"];
    }
}

- (IBAction)comfirmClick:(UIButton *)sender {
    [self.view endEditing:YES];
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
                                      @"a":@"forget",
                                      @"t":[Tool getCurrentTimeStamp],
                                      @"app_key":kAPP_KEY,
                                      @"telephone":phoneNum,
                                      @"signature":kSIGNATURE,
                                      @"password":[Tool teaEncryptWithString:password],
                                      @"verify_code":veifyCode
                                      };
            ToolRequest *toolRequest = [[ToolRequest alloc]init];
            [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
        }
    }else{
        [Tool showAlertMessage:@"请输入正确的手机号！"];
    }

}
@end
