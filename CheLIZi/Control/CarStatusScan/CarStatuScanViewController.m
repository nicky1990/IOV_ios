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

@interface CarStatuScanViewController () <UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate>
{
    UAProgressView *_progressView;
    UILabel *_scoreLabel;
    UILabel *_timeLabel;
    UITableView *_tableView;
    NSArray *_typeArray;
    NSArray *_typeFileImage;
    
    //从网络接收到得二进制数据
    NSMutableData *finalData;
    //文件的大小（总字节数）
    float totalSize;
    
    UIImageView *_scanBtnIcon;
    UIButton *_scanBtn;
    UILabel *_healthLabel;
    UILabel *_healthNumLabel;
    UILabel *_fenLabel;
}
@end

@implementation CarStatuScanViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
    UILabel *titleLabel = [CustomView getLabelWith:CGRectMake(60, 27.5 , (kW_SreenWidth-120),20) andSize:18];
    titleLabel.text = @"车况扫描";
    titleLabel.textColor = [UIColor whiteColor];
    [headBackView addSubview:titleLabel];
    
    UIButton *backBtn = [CustomView getButtonWithFrame:CGRectMake(10, 25, 25, 25) withImage:@"nav_back_button" withTitle:nil withTarget:self andAction:@selector(leftButtonClick)];
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
    _progressView.progress = 0.5;
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
    
    _timeLabel = [self getLabelWithFrame:CGRectMake(232, 185, 80, 30) withTitle:@"2014-08-06 10:26" withColor:RGBCOLOR(14, 180, 147) andSize:12];
    _timeLabel.numberOfLines = 0;
    [headBackView addSubview:_timeLabel];
    
    _scanBtn = [CustomView getButtonWithFrame:CGRectMake(20, 70, 80, 25) withImage:nil withTitle:@"立即检测" withTarget:self andAction:@selector(startScanClick)];
    _scanBtn.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:20];
    [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [centerView addSubview:_scanBtn];
    _scanBtnIcon = [[UIImageView alloc]initWithFrame:CGRectMake(43, 20, 34, 34)];
    _scanBtnIcon.image = [UIImage imageNamed:@"scan_scanbtnicon"];
    [centerView addSubview:_scanBtnIcon];
    _scanBtn.hidden = YES;
    _scanBtnIcon.hidden = YES;
    
    
    _healthLabel = [self getLabelWithFrame:CGRectMake(20, 25, 80, 12) withTitle:@"爱车健康值" withColor:[UIColor whiteColor] andSize:12];
    _healthLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:_healthLabel];
    
    _healthNumLabel = [self getLabelWithFrame:CGRectMake(20, 50, 80, 45) withTitle:@"86" withColor:[UIColor whiteColor] andSize:35];
    _healthNumLabel.font = [UIFont fontWithName:@"Arial" size:45];
    _healthNumLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:_healthNumLabel];
    
    _fenLabel = [self getLabelWithFrame:CGRectMake(95, 76, 20, 12) withTitle:@"分" withColor:[UIColor whiteColor] andSize:12];
    [centerView addSubview:_fenLabel];
}
#pragma mark Tableview
-(void)initTableView{
    _typeArray = @[@"发动机转数",@"进气压力",@"进气温度",@"节气门开度",@"三元催化剂温度"];
    _typeFileImage = @[@"scan_fadongji",@"scan_yali",@"scan_wendu",@"scan_jieqimen",@"scan_cuihuaji"];
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
    accessImage.image = [UIImage imageNamed:@"scan_good"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            accessImage.image = [UIImage imageNamed:@"scan_good"];
            cell.detailTextLabel.text = @"电瓶电压状态良好";
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"电瓶电压";
            cell.imageView.image = [UIImage imageNamed:@"scan_dianping"];
            
        }else{
            cell.textLabel.text = @"水温";
            cell.imageView.image = [UIImage imageNamed:@"scan_shuiwen"];
        }
    }else{
        if (indexPath.row %2 ==0) {
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.textLabel.text = _typeArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_typeFileImage[indexPath.row]];
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
        
        UILabel *lable = [self getLabelWithFrame:CGRectMake(30, 13, 80, 14) withTitle:@"故障" withColor:RGBCOLOR(14, 180, 147) andSize:14];
        [view addSubview:lable];
        
        UIButton *guzhangBtn = [CustomView getButtonWithFrame:CGRectMake(290, 12.5, 15, 15) withImage:@"scan_guzhang" withTitle:nil withTarget:self andAction:@selector(guzhangBtnClick)];
        [view addSubview:guzhangBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guzhangBtnClick)];
        [view addGestureRecognizer:tap];
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

-(void)startScanClick{
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:BASEURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDataDelegate
//连接开始
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    finalData = [[NSMutableData alloc] init];
    totalSize=[response expectedContentLength];
    NSLog(@"totalSize=%f",totalSize);
}

//连接接收下载  (会被多次执行，因为数据不能一次就下载完成，一段一段下载)
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"接收数据");
    //反复追加数据到final对象
    [finalData appendData:data];
    float temp = finalData.length/totalSize;
    _progressView.progress = temp;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error.description);
    [Tool showAlertMessage:@"网络请求失败，请重试"];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finalData options:NSJSONReadingMutableLeaves error:nil];
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
