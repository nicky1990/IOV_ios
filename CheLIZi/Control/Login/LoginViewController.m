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

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    // Do any additional setup after loading the view from its nib.
    [self customNavigationButton];
    [self setUI];
}

#pragma mark 控件属性
-(void)setUI{
    self.userHead.layer.cornerRadius = self.userHead.frame.size.width/2.0;
    self.userHead.layer.masksToBounds = YES;
    [self.userPhoneNum setLeftImageWithImage:@"login_user"];
    [self.userPassword setLeftImageWithImage:@"login_password"];
    
    
}

-(void)customNavigationButton{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"login_close"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonClick)];
    leftBarButton.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_close"]];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

-(void)leftButtonClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
}

- (IBAction)registClick:(UIButton *)sender {
    RegistViewController *registVC = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (IBAction)forgetPsdClick:(UIButton *)sender {
    ResetPsdViewController *resetPsdVC = [[ResetPsdViewController alloc]init];
    [self.navigationController pushViewController:resetPsdVC animated:YES];
}
@end
