//
//  UpdateNameViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/13.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "UpdateNameViewController.h"

@interface UpdateNameViewController ()<ToolRequestDelegate>

@end

@implementation UpdateNameViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.textField.text = self.defaultValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改名称";
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

- (IBAction)updateClick:(UIButton *)sender {
    NSDictionary *paraDic = @{@"c":@"user",
                              @"a":@"infoSave",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"variate_name":@"realname",
                              @"variate_value":_textField.text,
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
