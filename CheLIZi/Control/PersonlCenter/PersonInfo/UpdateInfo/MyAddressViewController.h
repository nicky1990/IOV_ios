//
//  MyAddressViewController.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/18.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "BaseViewController.h"

@interface MyAddressViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *postTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;
- (IBAction)saveClick:(UIButton *)sender;

@end
