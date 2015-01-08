//
//  ShareDLineTitleView.m
//  ShareD
//
//  Created by newman on 15-1-1.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import "ShareDLineTitleView.h"
#import "AppDelegate.h"

//标准高度为116/667 宽度自适应
@interface ShareDLineTitleView ()
{
    int with;
    int height;
    
    //用户基本信息
    NSString *userName;
    UIImage *userIcon;
    
    //界面元素
    UIImageView *backgroundView;
    UIImageView *iconView;
    UILabel *userNameLabel;
    UIButton *arrowLeftBtn;
    UIButton *arrowRightBtn;
    UIButton *middleBtn;
    
    //日期
    __block NSDate *date;
    UILabel *dateLabel;
}
@end

@implementation ShareDLineTitleView

- (id)init
{
    if (self = [super init])
    {
        iconView = [[UIImageView alloc]init];
        userNameLabel = [[UILabel alloc]init];
        dateLabel = [[UILabel alloc]init];
        arrowLeftBtn = [[UIButton alloc]init];
        arrowRightBtn = [[UIButton alloc]init];
        middleBtn = [[UIButton alloc]init];
        [arrowLeftBtn addTarget:self action:@selector(arrowLeftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [arrowRightBtn addTarget:self action:@selector(arrowLeftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [middleBtn addTarget:self action:@selector(arrowLeftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        arrowLeftBtn.tag = 10;
        arrowRightBtn.tag = 11;
        date=[NSDate date];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        with = frame.size.width;
        height = frame.size.height;
        iconView = [[UIImageView alloc]init];
        userNameLabel = [[UILabel alloc]init];
        dateLabel = [[UILabel alloc]init];
        arrowLeftBtn = [[UIButton alloc]init];
        arrowRightBtn = [[UIButton alloc]init];
        middleBtn = [[UIButton alloc]init];
        [arrowLeftBtn addTarget:self action:@selector(arrowLeftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [arrowRightBtn addTarget:self action:@selector(arrowLeftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [middleBtn addTarget:self action:@selector(arrowLeftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        arrowLeftBtn.tag = 10;
        arrowRightBtn.tag = 11;
        date=[NSDate date];
        [self controlsFrame];
        
        [userNameLabel setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}



- (void)setUserName:(NSString *)name userIcon:(UIImage *)icon
{
    [self controlsFrame];
    userName = [NSString stringWithString:name];
    userIcon = icon;
    
    [userNameLabel setText:userName];
    [self createDate];
    
    [self addSubview:userNameLabel];
    [self addSubview:dateLabel];
    [self addSubview:iconView];
    [self addSubview:arrowLeftBtn];
    [self addSubview:arrowRightBtn];
    [self addSubview:middleBtn];
}


- (void)setFrame:(CGRect)frame
{
    with = frame.size.width;
    height = frame.size.height;

    [self controlsFrame];
    [super setFrame:frame];
}

//设置控件frame
- (void)controlsFrame
{
    if(backgroundView == nil)backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, with*(20.0/375.0), with, height-with*(20.0/375.0))];
    [backgroundView setImage:[UIImage imageNamed:@"TitleBackground"]];
    [self addSubview:backgroundView];
    [self sendSubviewToBack:backgroundView];
    
    [iconView setFrame:CGRectMake(with*(16.2/375.0), height*(35.5/116.0), with*(72.6/375.0), with*(72.6/375.0))];
//    [[iconView layer] setBorderWidth:2.0];//画线的宽度
//    [[iconView layer] setBorderColor:[UIColor greenColor].CGColor];//颜色
    [[iconView layer]setCornerRadius:with*(72.6/750.0)];//圆角
    [iconView.layer setMasksToBounds:YES];
    [iconView setImage:[UIImage imageNamed:@"head"]];
    
    [userNameLabel setFrame:CGRectMake(with*(108.0/375.0), height*(45.0/116.0), with*(268.0/375.0), height*(20.0/116.0))];
    userNameLabel.text = @"label1";
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.textAlignment = UITextAlignmentLeft;
    userNameLabel.adjustsFontSizeToFitWidth = YES;
    
    [dateLabel setFrame:CGRectMake(with*(310.0/750.0), height*(180.0/232.0), with*(270.0/750.0), height*(20.0/116.0))];
    dateLabel.text = @"label1";
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = UITextAlignmentLeft;
    dateLabel.adjustsFontSizeToFitWidth = YES;
    
    [arrowLeftBtn setFrame:CGRectMake(with*(200.0/750.0), height*(168.0/232.0), with*(100.0/750.0), height*(64.0/232.0))];
    [arrowRightBtn setFrame:CGRectMake(with*(620.0/750.0), height*(168.0/232.0), with*(100.0/750.0), height*(64.0/232.0))];
    [middleBtn setFrame:CGRectMake(with*(300.0/750.0), height*(168.0/232.0), with*(320.0/750.0), height*(64.0/232.0))];
    [arrowLeftBtn setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [arrowRightBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
}

//设置日期
- (void)createDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateAndTime = [dateFormatter stringFromDate:date];
    [dateLabel setText:dateAndTime];
}


- (void)arrowLeftBtnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 10)
    {
        NSTimeInterval secondsPerDay = 24*60*60;
        date = [date addTimeInterval:-secondsPerDay];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateAndTime = [dateFormatter stringFromDate:date];
        [dateLabel setText:dateAndTime];
    }
    else if(btn.tag == 11)
    {
        NSTimeInterval secondsPerDay = 24*60*60;
        date = [date addTimeInterval:secondsPerDay];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateAndTime = [dateFormatter stringFromDate:date];
        [dateLabel setText:dateAndTime];
    }
    else
    {

        UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIDatePicker* datePicker=[[UIDatePicker alloc]init];
        datePicker.date = date;

        __block UILabel *block_dateLabel = dateLabel;
        datePicker.datePickerMode = UIDatePickerModeDate;
        UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            date=[datePicker date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            NSString *dateAndTime = [dateFormatter stringFromDate:date];
            [block_dateLabel setText:dateAndTime];
        }];
        UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
        [alertVc.view addSubview:datePicker];
        [alertVc addAction:ok];
        [alertVc addAction:no];
        UIViewController *viewController = [self findViewController:self.superview];
        [viewController presentViewController:alertVc animated:YES completion:nil];
    }
}

                                            
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target)
    {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]])
        {
            break;
        }
    }
    return target;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
