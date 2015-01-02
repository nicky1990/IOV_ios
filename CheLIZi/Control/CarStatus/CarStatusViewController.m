//
//  CarStatusViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/31.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "CarStatusViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialConfig.h"
#import "UMSocial.h"
#import "CarTrackViewController.h"

@interface CarStatusViewController ()<UMSocialUIDelegate,UMSocialUIDelegate>

@end

@implementation CarStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"爱车车况";
    // Do any additional setup after loading the view from its nib.
    [self customNavigationButton];
}

-(void)customNavigationButton{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"carstatus_sharebtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonClick)];
    rightBarButton.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"carstatus_sharebtn"]];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonClick)];
    leftBarButton.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_back_button"]];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}
#pragma mark UMShare
-(void)rightButtonClick{
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"53843dba56240bc4661b1867"
                                      shareText:@"你要分享的文字"
                                     shareImage:[UIImage imageNamed:@"home_car"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)trackClick:(id)sender {
    CarTrackViewController *carTrack = [[CarTrackViewController alloc]init];
    [self.navigationController pushViewController:carTrack animated:YES];
}
@end
