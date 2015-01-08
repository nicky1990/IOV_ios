//
//  CarStatusViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/31.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "CarStatusViewController.h"
#import "ToolUMShare.h"
#import "CarTrackViewController.h"
#import "CarStatuScanViewController.h"
#import "CarWarnSetViewController.h"
#import "UMSocialScreenShoter.h"
#import "CarStatusData.h"
#import "CustomView.h"

#define kButtonHeight (([[UIScreen mainScreen] bounds].size.height == 568)?180:105)

@interface CarStatusViewController () <ToolRequestDelegate>
{
    UIImageView *_tenDigistImage;
    UIImageView *_unitDigistImage;
    UILabel *_oilPercent;
    UILabel *_sumMileNum;
    UILabel *_avgSpeedNum;
    UILabel *_currentOilNum;
}
@end

@implementation CarStatusViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCarStausData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"爱车车况";
    // Do any additional setup after loading the view from its nib.
    [self customNavigationButton];
    [self initUIHead];
    [self initUIFoot];
}
#pragma mark UI
-(void)initUIHead{
    UIImageView *oilIcon = [[UIImageView alloc]initWithFrame:CGRectMake(103, 20, 32, 27)];
    oilIcon.image = [UIImage imageNamed:@"carstatus_oil"];
    [self.view addSubview:oilIcon];
    
    UILabel *avgoilLabel = [self getLabelWithFrame:CGRectMake(143, 23, 74, 21) withTitle:@"平均油耗" withColor:RGBCOLOR(113, 216, 195) andSize:17];
    avgoilLabel.textColor = RGBCOLOR(113, 216, 195);
    [self.view addSubview:avgoilLabel];
    
    UIImageView *firstOil = [[UIImageView alloc]initWithFrame:CGRectMake(55, 57, 45, 100)];
    firstOil.image = [UIImage imageNamed:@"oil_default"];
    [self.view addSubview:firstOil];
    
    _tenDigistImage = [[UIImageView alloc]initWithFrame:CGRectMake(110, 57, 45, 100)];
    _tenDigistImage.image = [UIImage imageNamed:@"oil_0"];
    [self.view addSubview:_tenDigistImage];
    UIImageView *thirdOil = [[UIImageView alloc]initWithFrame:CGRectMake(165, 57, 45, 100)];
    thirdOil.image = [UIImage imageNamed:@"oil_point"];
    [self.view addSubview:thirdOil];
    _unitDigistImage = [[UIImageView alloc]initWithFrame:CGRectMake(220, 57, 45, 100)];
    _unitDigistImage.image = [UIImage imageNamed:@"oil_0"];
    [self.view addSubview:_unitDigistImage];
    
    UILabel *LLable = [self getLabelWithFrame:CGRectMake(260, 145, 40, 12) withTitle:@"（ L ）" withColor:RGBCOLOR(102, 102, 102) andSize:12];
    [self.view addSubview:LLable];
    
    UIImageView *winIcon = [[UIImageView alloc]initWithFrame:CGRectMake(50, 175, 34, 34)];
    winIcon.image = [UIImage imageNamed:@"carstatus_win"];
    [self.view addSubview:winIcon];
    
    UILabel *leftWinLabel = [self getLabelWithFrame:CGRectMake(92, 181, 68, 21) withTitle:@"您已打败" withColor:[UIColor blackColor] andSize:15];
    [self.view addSubview:leftWinLabel];
    
    _oilPercent = [self getLabelWithFrame:CGRectMake(151, 179, 50, 25) withTitle:@"0%" withColor:[UIColor blackColor] andSize:23];
    _oilPercent.font = [UIFont fontWithName:@"Kohinoor Devanagari Book" size:23];
    _oilPercent.textAlignment = NSTextAlignmentCenter;
    _oilPercent.textColor = [UIColor redColor];
    [self.view addSubview:_oilPercent];
    
    UILabel *rightWinLabel = [self getLabelWithFrame:CGRectMake(200, 181, 68, 21) withTitle:@"的小伙伴" withColor:[UIColor blackColor] andSize:15];
    [self.view addSubview:rightWinLabel];
    
    
}
-(void)initUIFoot{
    UILabel *sumMile = [self getLabelWithFrame:CGRectMake(0, 230, kW_SreenWidth/3.0, 21) withTitle:@"总里程" withColor:[UIColor blackColor] andSize:15];
    sumMile.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sumMile];
    UIImageView *sumMileIcon = [[UIImageView alloc]initWithFrame:CGRectMake(16, 252, 18, 20)];
    sumMileIcon.image = [UIImage imageNamed:@"carstatus_summile"];
    [self.view addSubview:sumMileIcon];
    _sumMileNum = [self getLabelWithFrame:CGRectMake(41, 238, 67, 51) withTitle:@"0.00km" withColor:RGBCOLOR(102, 102, 102) andSize:12];
    [self.view addSubview:_sumMileNum];
    
    
    UILabel *avgSpeed = [self getLabelWithFrame:CGRectMake(kW_SreenWidth/3.0, 230, kW_SreenWidth/3.0, 21) withTitle:@"平均时速" withColor:[UIColor blackColor] andSize:15];
    avgSpeed.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:avgSpeed];
    UIImageView *avgSpeedIcon = [[UIImageView alloc]initWithFrame:CGRectMake(123, 252, 18, 20)];
    avgSpeedIcon.image = [UIImage imageNamed:@"carstatus_averagespeed"];
    [self.view addSubview:avgSpeedIcon];
    _avgSpeedNum = [self getLabelWithFrame:CGRectMake(151, 238, 67, 51) withTitle:@"0.00km/h" withColor:RGBCOLOR(102, 102, 102) andSize:12];
    [self.view addSubview:_avgSpeedNum];
    
    UILabel *currentOil = [self getLabelWithFrame:CGRectMake(kW_SreenWidth/3.0*2, 230, kW_SreenWidth/3.0, 21) withTitle:@"当前油量" withColor:[UIColor blackColor] andSize:15];
    currentOil.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:currentOil];
    UIImageView *currentOilIcon = [[UIImageView alloc]initWithFrame:CGRectMake(242, 252, 10, 20)];
    currentOilIcon.image = [UIImage imageNamed:@"carstatus_currentoil"];
    [self.view addSubview:currentOilIcon];
    _currentOilNum = [self getLabelWithFrame:CGRectMake(259, 238, 67, 51) withTitle:@"0.00" withColor:RGBCOLOR(102, 102, 102) andSize:12];
    [self.view addSubview:_currentOilNum];
    UIButton *warnSetBtn = [self getButton:@"预警设置" withImage:@"carstatus_warnsetting" withFrame:CGRectMake(0, 282, kW_SreenWidth/3.0, kButtonHeight)];
    [warnSetBtn addTarget:self action:@selector(warnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:warnSetBtn];
    
    UIButton *carStatusScanBtn = [self getButton:@"车况扫描" withImage:@"carstatus_carstatus" withFrame:CGRectMake(kW_SreenWidth/3.0, 282, kW_SreenWidth/3.0, kButtonHeight)];
    [carStatusScanBtn addTarget:self action:@selector(carStatusScan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:carStatusScanBtn];
    
    UIButton *trackBtn = [self getButton:@"轨迹" withImage:@"carstatus_track" withFrame:CGRectMake(kW_SreenWidth/3.0*2, 282, kW_SreenWidth/3.0, kButtonHeight)];
    [trackBtn addTarget:self action:@selector(trackClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trackBtn];
    
    
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
    //截图
    CGRect rect = CGRectMake(0, 0, kW_SreenWidth, self.view.frame.size.height-49);
//    UIGraphicsBeginImageContext(rect.size);
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(rect.size);
    }
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//     UIImage *image = [[UMSocialScreenShoterDefault screenShoter] getScreenShot];
//    [ToolUMShare shareWithTarget:self withImage:[UIImage imageNamed:@"home_car"]];
    [ToolUMShare shareWithTarget:self withImage:screenshot];
}

-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Request
-(void)getCarStausData{
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"index",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"car_id":[NSNumber numberWithInt:[UserInfo sharedUserInfo].car_id],
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}
-(void)requestSucceed:(NSDictionary *)dic wihtTag:(NSInteger)tag{
    NSDictionary *dataDic = [dic objectForKeyedSubscript:@"data"];
    CarStatusData *carStatusData = [CarStatusData objectWithKeyValues:dataDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        int ten = (int)carStatusData.avg_gas_mileage/1;
        int ge = (int)(carStatusData.avg_gas_mileage *10)%10;
        _tenDigistImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"oil_%d",ten]];
        _unitDigistImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"oil_%d",ge]];;
        _oilPercent.text = [NSString stringWithFormat:@"%0.0f%@",carStatusData.defeat_percent,@"%"];
        _sumMileNum.text = [NSString stringWithFormat:@"%0.2fkm",carStatusData.total_mileage];
        _avgSpeedNum.text = [NSString stringWithFormat:@"%0.2fkm/h",carStatusData.avg_speed];
        _currentOilNum.text = [NSString stringWithFormat:@"%0.2fL",carStatusData.total_gas_mileage];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UILabel *)getLabelWithFrame:(CGRect)rect withTitle:(NSString *)title withColor:(UIColor *)color andSize:(NSInteger)size{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.font = [UIFont fontWithName:@"Heiti SC" size:size];
    label.text = title;
    label.textColor = color;
    return label;
}

-(UIButton *)getButton:(NSString *)buttonTitle withImage:(NSString *)imgName withFrame:(CGRect) rect{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.backgroundColor = [UIColor whiteColor];
    UIImageView *messageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    float messageViewY = button.frame.size.height/5;
    messageView.frame = CGRectMake((rect.size.width-30)/2.0,messageViewY , 30, 30);
    [button addSubview:messageView];
    UILabel *messageLable = [[UILabel alloc]initWithFrame:CGRectMake(0, messageViewY+40, rect.size.width, 14)];
    messageLable.backgroundColor = [UIColor clearColor];
    messageLable.textAlignment = NSTextAlignmentCenter;
    messageLable.font = [UIFont fontWithName:@"Arial" size:14];
    messageLable.text = buttonTitle;
    [button addSubview:messageLable];
    return button;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)warnSettingClick:(UIButton *)sender {
    CarWarnSetViewController *carWarnSetVC = [[CarWarnSetViewController alloc]init];
    [self.navigationController pushViewController:carWarnSetVC animated:YES];
}

- (void)carStatusScan:(UIButton *)sender {
    CarStatuScanViewController *carStatusScanVC = [[CarStatuScanViewController alloc]init];
    [self.navigationController pushViewController:carStatusScanVC animated:YES];
}

- (void)trackClick:(UIButton *)sender {
    CarTrackViewController *carTrack = [[CarTrackViewController alloc]init];
    [self.navigationController pushViewController:carTrack animated:YES];
}


@end
