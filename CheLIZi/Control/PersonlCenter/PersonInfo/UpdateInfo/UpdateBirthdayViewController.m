//
//  UpdateBirthdayViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/14.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "UpdateBirthdayViewController.h"

@interface UpdateBirthdayViewController ()<UITextFieldDelegate>
{
    UIView *_dateView;
    UIDatePicker *_datePicker;
}
@end

@implementation UpdateBirthdayViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.textField.text = self.defaultValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生日修改";
    // Do any additional setup after loading the view from its nib.
    [self initDateView];
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

-(void)initDateView{
    _dateView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64-49-216-44, kW_SreenWidth, 216+44)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 44)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelBtnClick)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(comfirmBtnClick)];
    UIBarButtonItem *center = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[left,center,right]];
    
    [_dateView addSubview:toolBar];
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, kW_SreenWidth, 216)];
    // 设置时区
    [_datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [_datePicker setLocale:locale];
    // 设置当前显示时间
    [_datePicker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [_datePicker setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_dateView addSubview:_datePicker];
    [self.view addSubview:_dateView];
    _dateView.hidden = YES;
}

-(void)cancelBtnClick{
    _dateView.hidden = YES;
}

-(void)comfirmBtnClick{
    _dateView.hidden = YES;
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:_datePicker.date];
    NSDate *localeDate = [_datePicker.date  dateByAddingTimeInterval: interval];
    _textField.text = [[localeDate description]substringToIndex:10];
}

- (IBAction)updateClick:(UIButton *)sender {
    NSDictionary *paraDic = @{@"c":@"user",
                              @"a":@"infoSave",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"variate_name":@"birthday",
                              @"variate_value":_textField.text,
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _dateView.hidden = NO;
    return NO;
}

@end
