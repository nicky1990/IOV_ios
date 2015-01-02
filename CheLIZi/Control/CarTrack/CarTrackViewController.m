//
//  CarTrackViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/2.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "CarTrackViewController.h"
#import "BMapKit.h"
#import "CustomView.h"

@interface CarTrackViewController ()<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    UILabel *_dateLabel;
    NSDate *_currentDate;
    NSDateFormatter *_format;
    UIDatePicker *_datePicker;
    UIView *_dateView;
}
@end

@implementation CarTrackViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [self customTitleView];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, kH_SreenHeight-64-49 )];
    [self.view addSubview:_mapView];
    [self dateSelectView];
}
-(UIView *)customTitleView{
    _currentDate = [NSDate date];
    _format = [[NSDateFormatter alloc] init];
    [_format setTimeZone:[NSTimeZone systemTimeZone]];
    [_format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [_format stringFromDate:_currentDate];
    NSLog(@"%@",[_format stringFromDate:_currentDate]);
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    _dateLabel = [CustomView getLabelWith:CGRectMake(40 ,12 , 120, 20) andSize:18];
    _dateLabel.text = [currentDateStr substringToIndex:10];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDate)];
    [_dateLabel addGestureRecognizer:tap];
    _dateLabel.userInteractionEnabled = YES;
    
    [titleView addSubview:_dateLabel];
    
    UIButton *upButton = [CustomView getButtonWithFrame:CGRectMake(20, 10, 24, 24) withImage:@"date_up" withTitle:nil withTarget:self andAction:@selector(upDay)];
    [titleView addSubview:upButton];
    
    UIButton *nextButton = [CustomView getButtonWithFrame:CGRectMake(176-20, 10, 24, 24) withImage:@"date_next" withTitle:nil withTarget:self andAction:@selector(nextDay)];
    [titleView addSubview:nextButton];
    
    return titleView;
}

-(void)dateSelectView{
    _dateView = [[UIView alloc]initWithFrame:_mapView.frame];
    _dateView.backgroundColor = [UIColor whiteColor];
    _dateView.alpha = 0.9;
    _dateView.hidden = YES;
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 20, kW_SreenWidth, 216)];
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
    
    UIButton *comfimBtn = [CustomView getButtonWithFrame:CGRectMake(220, 240, 50, 30) withImage:nil withTitle:@"确定" withTarget:self andAction:@selector(comfirmBtnClick)];
    [_dateView addSubview:comfimBtn];
    UIButton *cancelBtn = [CustomView getButtonWithFrame:CGRectMake(50, 240, 50, 30) withImage:nil withTitle:@"取消" withTarget:self andAction:@selector(cancelBtnClick)];
    [_dateView addSubview:cancelBtn];
}

-(void)cancelBtnClick{
    _dateView.hidden = YES;
}

-(void)comfirmBtnClick{
    _dateView.hidden = YES;
    _currentDate = _datePicker.date;
    NSString *upDateStr = [_format stringFromDate:_currentDate];
    NSString *selectDate = [upDateStr substringToIndex:10];
    _dateLabel.text = selectDate;
    NSLog(@"%@",upDateStr);
    
}
#pragma mark 日期选择
-(void)selectDate{
    if (_dateView.hidden) {
        _dateView.hidden = NO;
    }else{
        _dateView.hidden = YES;
    }
}
-(void)upDay{
    NSDate *upDate=[[NSDate alloc]initWithTimeInterval:-3600*24 sinceDate:_currentDate];
    _currentDate = upDate;
    NSString *upDateStr = [_format stringFromDate:_currentDate];
    NSLog(@"%@",[_format stringFromDate:_currentDate]);
    NSString *selectDate = [upDateStr substringToIndex:10];
    _dateLabel.text = selectDate;
}

-(void)nextDay{
    NSDate *nextDate = [[NSDate alloc]initWithTimeInterval:3600*24 sinceDate:_currentDate];
    _currentDate = nextDate;
    NSString *nextDateStr = [_format stringFromDate:_currentDate];
    NSLog(@"%@",[_format stringFromDate:_currentDate]);
    NSString *selectDate = [nextDateStr substringToIndex:10];
    _dateLabel.text = selectDate;
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

@end
