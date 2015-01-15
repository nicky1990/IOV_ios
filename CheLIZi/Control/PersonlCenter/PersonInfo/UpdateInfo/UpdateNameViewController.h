//
//  UpdateNameViewController.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/13.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdateNameViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)updateClick:(UIButton *)sender;
@property (strong, nonatomic) NSString *defaultValue;

@end
