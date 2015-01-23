//
//  WeiBoViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/4.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "WeiBoViewController.h"
#import "ToolUMShare.h"

@interface WeiBoViewController ()

@end

@implementation WeiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"官方微博";
    // Do any additional setup after loading the view from its nib.
    [self customNavigationButton];
}
-(void)customNavigationButton{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonClick)];
    leftBarButton.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_back_button"]];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"carstatus_sharebtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonClick)];
    rightBarButton.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"carstatus_sharebtn"]];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightButtonClick{
    //截图
    CGRect rect = CGRectMake(0, 0, self.contentBackView.frame.size.width,self.contentBackView.frame.size.height);
    //    UIGraphicsBeginImageContext(rect.size);
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(rect.size);
    }
    [self.contentBackView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [ToolUMShare shareWithTarget:self withImage:screenshot];
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
