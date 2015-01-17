//
//  CarStatuScanViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/2.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "CarStatuScanViewController.h"
#import "CustomView.h"
#import "UAProgressView.h"
#import "TroubleViewController.h"
#import "CarScanData.h"


@interface CarStatuScanViewController () <UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,ToolRequestDelegate>
{
    UAProgressView *_progressView;
    UILabel *_scoreLabel;
    UILabel *_timeLabel;
    UITableView *_tableView;
    NSArray *_typeArray;
    NSArray *_typeFileImage;
    NSArray *_statusInfo;
    
    //从网络接收到得二进制数据
    NSMutableData *finalData;
    //大小（总字节数）
    long long totalSize;
    
    UIImageView *_scanBtnIcon;
    UIButton *_scanBtn;
    UILabel *_healthLabel;
    UILabel *_healthNumLabel;
    UILabel *_fenLabel;
    CarScanData *_carScanData;
    UIButton *_guzhangBtn;
    UILabel *_guzhangLabel;
}
@end

@implementation CarStatuScanViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self lastScan];
    _scanBtn.hidden = NO;
    _scanBtnIcon.hidden = NO;
    _healthLabel.hidden = YES;
    _healthNumLabel.hidden = YES;
    _fenLabel.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initTableView];
}

-(void)initUI{
    UIView *headBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 230)];
    headBackView.backgroundColor = RGBCOLOR(37, 48, 68);
    [self.view addSubview:headBackView];
    UILabel *titleLabel = [CustomView getLabelWith:CGRectMake(60, 30 , (kW_SreenWidth-120),20) andSize:18];
    titleLabel.text = @"车况扫描";
    titleLabel.textColor = [UIColor whiteColor];
    [headBackView addSubview:titleLabel];
    
    UIButton *backBtn = [CustomView getButtonWithFrame:CGRectMake(10, 25, 30, 30) withImage:@"nav_back_button" withTitle:nil withTarget:self andAction:@selector(leftButtonClick)];
    [headBackView addSubview:backBtn];
    
    UAProgressView *progressViewBack = [[UAProgressView alloc]initWithFrame:CGRectMake(headBackView.center.x-70, 60, 140, 140)];
    progressViewBack.tintColor = RGBCOLOR(33, 73, 83);
    progressViewBack.borderWidth = 0;
    progressViewBack.lineWidth = 2.0;
    progressViewBack.progress = 1;
    progressViewBack.userInteractionEnabled = NO;
    [headBackView addSubview:progressViewBack];
    
    _progressView = [[UAProgressView alloc]initWithFrame:CGRectMake(headBackView.center.x-70, 60, 140, 140)];
    _progressView.tintColor = RGBCOLOR(14, 180, 147);
    _progressView.borderWidth = 0;
    _progressView.lineWidth = 2.0;
    _progressView.progress = 0.0;
    _progressView.userInteractionEnabled = NO;
    [headBackView addSubview:_progressView];
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(headBackView.center.x-60, 70, 120, 120)];
    centerView.backgroundColor = RGBCOLOR(14, 180, 147);
    centerView.layer.cornerRadius = 60;
    [self.view addSubview:centerView];
    
    UILabel *lastCheckScore = [self getLabelWithFrame:CGRectMake(15, 170 , 80,12) withTitle:@"上次检测得分" withColor:RGBCOLOR(102, 102, 102) andSize:12];
    [headBackView addSubview:lastCheckScore];
    UILabel *lastCheckTime = [self getLabelWithFrame:CGRectMake(232, 170 , 80,12) withTitle:@"上次检测时间" withColor:RGBCOLOR(102, 102, 102) andSize:12];
    [headBackView addSubview:lastCheckTime];
    
    _scoreLabel = [self getLabelWithFrame:CGRectMake(15, 185, 60, 30) withTitle:@"-" withColor:RGBCOLOR(14, 180, 147) andSize:30];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    [headBackView addSubview:_scoreLabel];
    
    UILabel *scoreTemp = [self getLabelWithFrame:CGRectMake(70, 195 , 20,12) withTitle:@"分" withColor:RGBCOLOR(102, 102, 102) andSize:12];
    [headBackView addSubview:scoreTemp];
    
    _timeLabel = [self getLabelWithFrame:CGRectMake(232, 185, 80, 30) withTitle:@"一" withColor:RGBCOLOR(14, 180, 147) andSize:12];
    _timeLabel.numberOfLines = 0;
    [headBackView addSubview:_timeLabel];
    
    _scanBtn = [CustomView getButtonWithFrame:CGRectMake(20, 70, 80, 25) withImage:nil withTitle:@"立即检测" withTarget:self andAction:@selector(startScanClick)];
    _scanBtn.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:20];
    [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [centerView addSubview:_scanBtn];
    _scanBtnIcon = [[UIImageView alloc]initWithFrame:CGRectMake(43, 20, 34, 34)];
    _scanBtnIcon.userInteractionEnabled = YES;
    _scanBtnIcon.image = [UIImage imageNamed:@"scan_scanbtnicon"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startScanClick)];
    [_scanBtnIcon addGestureRecognizer:tap];
    
    [centerView addSubview:_scanBtnIcon];
//    _scanBtn.hidden = YES;
//    _scanBtnIcon.hidden = YES;
    
    
    _healthLabel = [self getLabelWithFrame:CGRectMake(20, 25, 80, 12) withTitle:@"爱车健康值" withColor:[UIColor whiteColor] andSize:12];
    _healthLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:_healthLabel];
    
    _healthNumLabel = [self getLabelWithFrame:CGRectMake(20, 50, 80, 45) withTitle:@"86" withColor:[UIColor whiteColor] andSize:35];
    _healthNumLabel.font = [UIFont fontWithName:@"Arial" size:45];
    _healthNumLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:_healthNumLabel];
    
    _fenLabel = [self getLabelWithFrame:CGRectMake(95, 76, 20, 12) withTitle:@"分" withColor:[UIColor whiteColor] andSize:12];
    [centerView addSubview:_fenLabel];
    
    _healthLabel.hidden = YES;
    _fenLabel.hidden = YES;
    _healthNumLabel.hidden = YES;
}
#pragma mark Tableview
-(void)initTableView{
    _typeArray = @[@"发动机转数",@"进气压力",@"进气温度",@"节气门开度",@"三元催化剂温度"];
    _typeFileImage = @[@"scan_fadongji",@"scan_yali",@"scan_wendu",@"scan_jieqimen",@"scan_cuihuaji"];
    _statusInfo = @[@"发动机转数正常",@"进气压力正常",@"进气温度正常",@"节气门开度正常",@"三元催化剂温度正常"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 230, kW_SreenWidth, kH_SreenHeight-49-230) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return _typeArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = RGBCOLOR(0, 55, 44);
    cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Heiti SC" size:10];
    UIImageView *accessImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    cell.accessoryView = accessImage;
    accessImage.image = [UIImage imageNamed:@"scan_normal"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"电瓶电压状态良好";
            if (_carScanData != nil) {
                if ((_carScanData.battery_voltage == 0)) {
                    accessImage.image = [UIImage imageNamed:@"scan_good"];
                }else{
                    accessImage.image = [UIImage imageNamed:@"scan_warn"];
                    cell.detailTextLabel.text = @"电瓶电压状态异常";
                }
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"电瓶电压";
            cell.imageView.image = [UIImage imageNamed:@"scan_dianping"];
            
        }else{
            cell.textLabel.text = @"水温";
            cell.detailTextLabel.text = @"水温正常";
            cell.imageView.image = [UIImage imageNamed:@"scan_shuiwen"];
            if (_carScanData != nil) {
                if ((_carScanData.coolant_temperature == 0)) {
                    accessImage.image = [UIImage imageNamed:@"scan_good"];
                }else{
                    accessImage.image = [UIImage imageNamed:@"scan_warn"];
                    cell.detailTextLabel.text = @"水温异常";
                }
            }
        }
    }else{
        if (indexPath.row %2 ==0) {
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.textLabel.text = _typeArray[indexPath.row];
        cell.detailTextLabel.text = _statusInfo[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_typeFileImage[indexPath.row]];
        if (_carScanData != nil) {
            switch (indexPath.row) {
                case 0:
                {
                    if ((_carScanData.engine_rpm == 0)) {
                        accessImage.image = [UIImage imageNamed:@"scan_good"];
                    }else{
                        accessImage.image = [UIImage imageNamed:@"scan_warn"];
                        cell.detailTextLabel.text = @"发动机转数异常";
                    }
                }
                    break;
                case 1:
                {
                    if ((_carScanData.MAP == 0)) {
                        accessImage.image = [UIImage imageNamed:@"scan_good"];
                    }else{
                        accessImage.image = [UIImage imageNamed:@"scan_warn"];
                        cell.detailTextLabel.text = @"进气压力异常";
                    }
                }
                    break;
                case 2:
                {
                    if ((_carScanData.ACT == 0)) {
                        accessImage.image = [UIImage imageNamed:@"scan_good"];
                    }else{
                        accessImage.image = [UIImage imageNamed:@"scan_warn"];
                        cell.detailTextLabel.text = @"进气温度异常";
                    }
                }
                    break;
                case 3:
                {
                    if ((_carScanData.TAP == 0)) {
                        accessImage.image = [UIImage imageNamed:@"scan_good"];
                    }else{
                        accessImage.image = [UIImage imageNamed:@"scan_warn"];
                        cell.detailTextLabel.text = @"节气门开度异常";
                    }
                }
                    break;
                case 4:
                {
                    if ((_carScanData.TWC == 0)) {
                        accessImage.image = [UIImage imageNamed:@"scan_good"];
                    }else{
                        accessImage.image = [UIImage imageNamed:@"scan_warn"];
                        cell.detailTextLabel.text = @"三元催化剂异常";
                    }
                }
                    break;
                default:
                    break;
            }

        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 40;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 10, 10)];
        image.image = [UIImage imageNamed:@"scan_section"];
        [view addSubview:image];
        
        UILabel *lable = [self getLabelWithFrame:CGRectMake(30, 13, 80, 14) withTitle:@"故障码" withColor:RGBCOLOR(14, 180, 147) andSize:14];
        [view addSubview:lable];
        
        _guzhangLabel = [self getLabelWithFrame:CGRectMake(230, 12.5, 60, 15) withTitle:@"存在异常" withColor:[UIColor redColor] andSize:10];
        _guzhangLabel.font = [UIFont fontWithName:@"Heiti SC" size:10];
        [view addSubview:_guzhangLabel];
        
        _guzhangBtn = [CustomView getButtonWithFrame:CGRectMake(290, 12.5, 15, 15) withImage:@"scan_guzhang" withTitle:nil withTarget:self andAction:@selector(guzhangBtnClick)];
        [view addSubview:_guzhangBtn];
        _guzhangBtn.hidden = YES;
        _guzhangLabel.hidden = YES;
        if (_carScanData != nil) {
            if ((_carScanData.fault.count == 0)) {
            }else{
                _guzhangBtn.hidden = NO;
                _guzhangLabel.hidden = NO;
            }
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guzhangBtnClick)];
        [_guzhangLabel addGestureRecognizer:tap];
        return view;
    }else{
        return nil;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 10, 10)];
    image.image = [UIImage imageNamed:@"scan_section"];
    [view addSubview:image];
    
    UILabel *lable = [self getLabelWithFrame:CGRectMake(30, 13, 80, 14) withTitle:nil withColor:RGBCOLOR(14, 180, 147) andSize:14];
    [view addSubview:lable];
    
    if (section == 0) {
        lable.text = @"安全";
    }else{
        lable.text = @"动力系统";
    }
    return view;
}

-(void)guzhangBtnClick{
    TroubleViewController *troubleVC = [[TroubleViewController alloc]init];
    troubleVC.troubleArray = _carScanData.fault;
    [self.navigationController pushViewController:troubleVC animated:YES];
}

-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark lastScan
-(void)lastScan{
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"prevScan",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"car_id":[NSNumber numberWithInt:[UserInfo sharedUserInfo].car_id],
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    _carScanData = [CarScanData objectWithKeyValues:dataDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        _scoreLabel.text = [NSString stringWithFormat:@"%d",_carScanData.score];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_carScanData.scan_time];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *time = [dateFormatter stringFromDate:date];
        _timeLabel.text = time;
        [_tableView reloadData];
    });

}
#pragma mark current Scan
-(void)startScanClick{
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:BASEURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *requestStr = [NSString stringWithFormat:@"c=%@&a=%@&access_token=%@&app_key=%@&car_id=%d&t=%@",@"car",@"faultDetect",[UserInfo sharedUserInfo].userAccess_token,kAPP_KEY,[UserInfo sharedUserInfo].car_id,[Tool getCurrentTimeStamp]];
    NSLog(@"%@",requestStr);
    NSData *data = [[requestStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDataDelegate
//连接开始
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    finalData = [[NSMutableData alloc] init];
    totalSize=[response expectedContentLength];
    NSLog(@"totalSize=%lld",[response expectedContentLength]);
}

//连接接收下载  (会被多次执行，因为数据不能一次就下载完成，一段一段下载)
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"接收数据");
    //反复追加数据到final对象
    [finalData appendData:data];
    float temp = finalData.length*1.0/totalSize;
    _progressView.progress = temp;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error.description);
    [Tool showAlertMessage:@"网络请求失败，请重试"];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finalData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
        NSDictionary *dataDic = [dic objectForKey:@"data"];
    _carScanData = [CarScanData objectWithKeyValues:dataDic];
        NSLog(@"%@",_carScanData);
        [self performSelector:@selector(timerAdvanced) withObject:nil afterDelay:0.01];
    }else{
        NSString *failMessage = [dic objectForKey:@"error_msg"];
        [Tool showAlertMessage:failMessage];
    }
}
-(void)timerAdvanced{
    if (_progressView.progress == 1.0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _scanBtn.hidden = YES;
            _scanBtnIcon.hidden = YES;
            _healthLabel.hidden = NO;
            _healthNumLabel.hidden = NO;
            _fenLabel.hidden = NO;
            _healthNumLabel.text = [NSString stringWithFormat:@"%d",_carScanData.score];
            [_tableView reloadData];
        });

    }else{
        _progressView.progress+=0.05;
        [self performSelector:@selector(timerAdvanced) withObject:nil afterDelay:0.5];
    }
    
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
