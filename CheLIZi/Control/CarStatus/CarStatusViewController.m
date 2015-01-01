//
//  CarStatusViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/31.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "CarStatusViewController.h"

@interface CarStatusViewController ()

@end

@implementation CarStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"爱车车况";
    // Do any additional setup after loading the view from its nib.
    
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

- (IBAction)warnSettingClick:(UIButton *)sender {
}

- (IBAction)averageSpeedClick:(UIButton *)sender {
}
@end
