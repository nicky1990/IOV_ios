//
//  RegistViewController.h
//  CheLIZi
//
//  Created by 点睛石 on 14/12/24.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "BaseViewController.h"

@interface RegistViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordAgain;
@property (weak, nonatomic) IBOutlet UITextField *verifyCode;
- (IBAction)registRequet:(UIButton *)sender;
- (IBAction)protocolClick:(UIButton *)sender;

@end
