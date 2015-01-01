//
//  RegistViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/24.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "RegistViewController.h"
#import "UITextField+LeftImage.h"

@interface RegistViewController () <UITextFieldDelegate>
{
    UIButton *_getVerifyCodeBtn;
    UILabel *_timeLabel;
    int statusTime;
}
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
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
    [_getVerifyCodeBtn addTarget:self action:@selector(updateTime) forControlEvents:UIControlEventTouchUpInside];
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

- (IBAction)registRequet:(UIButton *)sender {
}

- (IBAction)protocolClick:(UIButton *)sender {
}
@end
