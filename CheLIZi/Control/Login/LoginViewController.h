//
//  LoginViewController.h
//  CheLIZi
//
//  Created by 点睛石 on 14/12/24.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
- (IBAction)loginRequest:(UIButton *)sender;
- (IBAction)registClick:(UIButton *)sender;
- (IBAction)forgetPsdClick:(UIButton *)sender;

@end
