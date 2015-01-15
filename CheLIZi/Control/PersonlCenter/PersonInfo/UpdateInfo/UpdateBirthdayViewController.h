//
//  UpdateBirthdayViewController.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/14.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdateBirthdayViewController : BaseViewController

@property (strong, nonatomic) NSString *defaultValue;
- (IBAction)updateClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
