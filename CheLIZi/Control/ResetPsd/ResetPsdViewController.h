//
//  ResetPsdViewController.h
//  CheLIZi
//
//  Created by 点睛石 on 14/12/25.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "BaseViewController.h"

@interface ResetPsdViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *verifyCode;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordAgain;
- (IBAction)comfirmClick:(UIButton *)sender;

@end
