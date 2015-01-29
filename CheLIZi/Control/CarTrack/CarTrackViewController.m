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
#import "TrackPoint.h"
#import "SectionTrack.h"
#import "TrackUI.h"
@interface CarTrackViewController ()<BMKMapViewDelegate,ToolRequestDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView *_mapView;
    BMKGeoCodeSearch *_searchGeo;
    UILabel *_dateLabel;
    NSDate *_currentDate;
    NSDateFormatter *_format;
    UIDatePicker *_datePicker;
    UIView *_dateView;
    
    NSMutableArray *_pointArrays;
    NSMutableArray *_sectionTrackArray;
    int _trackIndex;
    UIButton *_upTrack;
    UIButton *_nextTrack;
    
    UIView *_detailView;
    UIButton *_locationInfo;
    UIButton *_theRunMile;
    UIButton *_theRunOil;
    UIButton *_theRunTime;
    UILabel *_timeLabel;
    UILabel *_accelerateLabel;
    UILabel *_brakeLabel;
//    UILabel *_highSpeedLabel;
    UILabel *_sharpTurnLabel;
    NSDictionary *labelColorDic;
    
    
}
@end

@implementation CarTrackViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    [self getSectionTrack:_dateLabel.text];
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
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.showMapScaleBar = YES;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(24.2646, 118.0404);
    [self.view addSubview:_mapView];
    [self dateSelectView];
    _pointArrays = [[NSMutableArray alloc]init];
    _sectionTrackArray = [[NSMutableArray alloc]init];
    [self initDetailView];
    [self initChageBtn];
}
-(UIView *)customTitleView{
    _currentDate = [NSDate date];
    _format = [[NSDateFormatter alloc] init];
    [_format setTimeZone:[NSTimeZone systemTimeZone]];
    [_format setDateFormat:@"yyyy-MM-dd"];
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
    [self getSectionTrack:selectDate];
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
//    NSLog(@"%@",[_format stringFromDate:_currentDate]);
    NSString *selectDate = [upDateStr substringToIndex:10];
    _dateLabel.text = selectDate;
    [self getSectionTrack:selectDate];
}
-(void)nextDay{
    NSDate *nextDate = [[NSDate alloc]initWithTimeInterval:3600*24 sinceDate:_currentDate];
    _currentDate = nextDate;
    NSString *nextDateStr = [_format stringFromDate:_currentDate];
//    NSLog(@"%@",[_format stringFromDate:_currentDate]);
    NSString *selectDate = [nextDateStr substringToIndex:10];
    _dateLabel.text = selectDate;
    [self getSectionTrack:selectDate];
}
#pragma mark  获取轨迹数据
-(void)getSectionTrack:(NSString *)selectDate{
    if ((int)_mapView.overlays.count > 0) {
        [_mapView removeOverlays:_mapView.overlays];
    }
    if ((int)_mapView.annotations.count > 0) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
    }
    
    NSDate *tripDate = [_format dateFromString:selectDate];
    NSNumber *tripTime = [Tool dateTransTimeStamp:tripDate];
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"trip",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"car_id":[NSNumber numberWithInt:[UserInfo sharedUserInfo].car_id],
                              @"trip_date":tripTime
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}
-(void)getPositions:(SectionTrack *)sectionTrack{
    NSLog(@"%@",[NSNumber numberWithInt:[UserInfo sharedUserInfo].car_id]);
    NSLog(@"%@",[UserInfo sharedUserInfo].userAccess_token);
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"track",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"car_id":[NSNumber numberWithInt:[UserInfo sharedUserInfo].car_id],
                              @"start_time":[NSNumber numberWithInt:sectionTrack.start_time],
                              @"end_time":[NSNumber numberWithInt:sectionTrack.end_time]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
}

-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    if (tag == REQUESTTAG) {
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        NSArray *tripsDic = [dataDic objectForKey:@"trips"];
        [_sectionTrackArray removeAllObjects];
        for (NSDictionary *temp in tripsDic) {
            SectionTrack *sectionTrack = [SectionTrack objectWithKeyValues:temp];
            [_sectionTrackArray addObject:sectionTrack];
        }
//        NSLog(@"%ld",_sectionTrackArray.count);
        if (_sectionTrackArray.count == 1) {
            _nextTrack.hidden = YES;
        }else{
            _nextTrack.hidden = NO;
        }
        _trackIndex = 0;
        _upTrack.hidden = YES;
        SectionTrack *sectionTrack = (SectionTrack *)_sectionTrackArray[0];
        [self getPositions:sectionTrack];
        [self updateUI:sectionTrack];
    }else{
        [_pointArrays removeAllObjects];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        NSArray *positions = [dataDic objectForKey:@"positions"];
        for (NSDictionary *temp in positions) {
            TrackPoint *pointTrack = [TrackPoint objectWithKeyValues:temp];
            [_pointArrays addObject:pointTrack];
        }
        [self getCarDriveLine:_pointArrays];
        
        //    CarStatusData *carStatusData = [CarStatusData objectWithKeyValues:dataDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
}
#pragma mark Change Section  Track
-(void)initChageBtn{
    UIButton *showDetaiBtn = [CustomView getButtonWithFrame:CGRectMake(10, 40, 33, 37) withImage:@"track_showbtn" withTitle:nil withTarget:self andAction:@selector(showDetailView)];
    [self.view addSubview:showDetaiBtn];
    _upTrack = [CustomView getButtonWithFrame:CGRectMake(10, (_mapView.frame.size.height/2.0)-20, 40, 40) withImage:@"track_up" withTitle:nil withTarget:self andAction:@selector(upTrack)];
    [self.view addSubview:_upTrack];
    _nextTrack = [CustomView getButtonWithFrame:CGRectMake(kW_SreenWidth-50, (_mapView.frame.size.height/2.0)-20, 40, 40) withImage:@"track_next" withTitle:nil withTarget:self andAction:@selector(nextTrack)];
    [self.view addSubview:_nextTrack];
    _upTrack.hidden = YES;
    _nextTrack.hidden = YES;
    
}
-(void)upTrack{
    if (_sectionTrackArray.count == 0) {
        return;
    }
    _nextTrack.hidden = NO;
    _trackIndex--;
    if (_trackIndex == 0) {
        _upTrack.hidden = YES;
    }
    [self updateUI:(SectionTrack *)_sectionTrackArray[_trackIndex]];
    [self getPositions:(SectionTrack *)_sectionTrackArray[_trackIndex]];
}
-(void)nextTrack{
    if (_sectionTrackArray.count == 0) {
        return;
    }
    _upTrack.hidden = NO;
    _trackIndex++;
    if (_trackIndex == (_sectionTrackArray.count-1)) {
        _nextTrack.hidden = YES;
    }
    [self updateUI:(SectionTrack *)_sectionTrackArray[_trackIndex]];
    [self getPositions:(SectionTrack *)_sectionTrackArray[_trackIndex]];
}
-(void)showDetailView{
    if (_detailView.hidden) {
        _detailView.hidden = NO;
    }else{
        _detailView.hidden = YES;
    }
}
#pragma mark 行车路线
-(void)getCarDriveLine:(NSMutableArray *)pointsArray{
    if ((int)_mapView.overlays.count > 0) {
        [_mapView removeOverlays:_mapView.overlays];
    }
    if ((int)_mapView.annotations.count > 0) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
    }
    CLLocationCoordinate2D *array=(CLLocationCoordinate2D*)calloc(pointsArray.count,sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < pointsArray.count; i++) {
        TrackPoint *point = pointsArray[i];
        CLLocationCoordinate2D temp = CLLocationCoordinate2DMake(point.lat, point.lng);
        array[i] = [self transformToBaidu:temp];
    }
    CLLocationCoordinate2D top = array[0];
    CLLocationCoordinate2D botton = array[0];
    CLLocationCoordinate2D left = array[0];
    CLLocationCoordinate2D right = array[0];
    for (int i = 0; i < pointsArray.count-1; i++) {
        CLLocationCoordinate2D temp = array[i];
        if (temp.latitude > top.latitude ) {
            top = temp;
        }
        if (temp.latitude < botton.latitude) {
            botton = temp;
        }
        if (temp.longitude > right.longitude) {
            right = temp;
        }
        if (temp.longitude < left.longitude) {
            left = temp;
        }
    }
    double latDeta = [self getDistance:top with:botton];
    double longitudeDeta = [self getDistance:left with:right];
    double latDetaPre = latDeta/1000/20.0;
    double longitudeDetaPre = longitudeDeta/1000/20.0;
    if (latDetaPre < 0.025) {
        latDetaPre = 0.025;
    }else{
        latDetaPre/= 5;
    }
    if (longitudeDetaPre < 0.025) {
        longitudeDetaPre = 0.025;
    }else{
        longitudeDetaPre/= 5;
    }
    BMKCoordinateSpan span = BMKCoordinateSpanMake(latDetaPre,longitudeDetaPre);//显示大小精度
    
    BMKCoordinateRegion region = BMKCoordinateRegionMake(array[pointsArray.count/2], span);
    [_mapView setRegion:region animated:YES];
    
    
    NSArray *annotionArray = @[[self getPointAnnotation:array[0] withTitle:@"起点"],[self getPointAnnotation:array[pointsArray.count - 1] withTitle:@"终点"]];
    [_mapView addAnnotations:annotionArray];
    [self setCarLocationName:array[pointsArray.count - 1]];
    
    BMKPolyline *polyLine = [BMKPolyline polylineWithCoordinates:array count:pointsArray.count];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    
    free(array);//释放数组
}
//装换成百度坐标
-(CLLocationCoordinate2D)transformToBaidu:(CLLocationCoordinate2D)temp{
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(temp,BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D clloca = BMKCoorDictionaryDecode(testdic);
    return clloca;
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = RGBCOLOR(14, 180, 147);
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}
//添加大头针标注
-(BMKPointAnnotation *)getPointAnnotation:(CLLocationCoordinate2D)coor withTitle:(NSString *)title{
    //添加标注
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = coor;
    annotation.title = title;
    return annotation;
}
#pragma mark BMKAnnotationView delete method
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;//设置标注动画显示
        [newAnnotationView setSelected:YES animated:YES];
        
        return newAnnotationView;
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 计算两坐标的距离
-(double)getDistance:(CLLocationCoordinate2D) coorOne with:(CLLocationCoordinate2D) coorTwo{
    //计算两个坐标之间的距离，单位米
    BMKMapPoint point1 = BMKMapPointForCoordinate(coorOne);
    BMKMapPoint point2 = BMKMapPointForCoordinate(coorTwo);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    return distance;
}

-(void)initDetailView{
    _detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    _detailView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.9];
    
    UIView *locationInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 26)];
    locationInfoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.09];
    
    _locationInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationInfo.frame = CGRectMake(10, 6, 250, 14);
    [_locationInfo setImage:[UIImage imageNamed:@"track_circle"] forState:UIControlStateNormal];
    _locationInfo.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:11];
    [_locationInfo setTitleColor:RGBCOLOR(14, 180, 147) forState:UIControlStateNormal];
    [_locationInfo setTitle:@"" forState:UIControlStateNormal];
    _locationInfo.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [locationInfoView addSubview:_locationInfo];
    
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(245, 0, 80, 26)];
    _timeLabel.font = [UIFont fontWithName:@"Heiti SC" size:10];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.text = @"00:00-00:00";
    [locationInfoView addSubview:_timeLabel];
    
    
    UILabel *theMile = [CustomView getLabelWith:CGRectMake(55, 30, 50, 15) andSize:12];
    theMile.text = @"本次里程";
    [_detailView addSubview:theMile];
    
    UILabel *avgOil = [CustomView getLabelWith:CGRectMake(150, 30, 50, 15) andSize:12];
    avgOil.text = @"本次油耗";
    [_detailView addSubview:avgOil];
    
    UILabel *driveTime = [CustomView getLabelWith:CGRectMake(245, 30, 50, 15) andSize:12];;
    driveTime.text = @"行驶时间";
    [_detailView addSubview:driveTime];
    
    
    _theRunMile = [TrackUI getBtnFrame:CGRectMake(45, 48, 80, 18) withImageName:@"track_runmile" withColor:[UIColor grayColor] withFontSize:13];
    [_theRunMile setTitle:@" 0.00km" forState:UIControlStateNormal];
    [_detailView addSubview:_theRunMile];
    _theRunOil = [TrackUI getBtnFrame:CGRectMake(145, 48, 80, 18) withImageName:@"track_oil" withColor:[UIColor grayColor] withFontSize:13];
     [_theRunOil setTitle:@" 0.00L" forState:UIControlStateNormal];
    [_detailView addSubview:_theRunOil];
    _theRunTime = [TrackUI getBtnFrame:CGRectMake(240, 48, 70, 18) withImageName:@"track_runtime" withColor:[UIColor grayColor] withFontSize:13];
    [_theRunTime setTitle:@" 0min" forState:UIControlStateNormal];
    [_detailView addSubview:_theRunTime];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(55, 70, 250, 1)];
    lineView.backgroundColor = RGBCOLOR(207, 207, 207);
    [_detailView addSubview:lineView];
    
    labelColorDic = @{NSForegroundColorAttributeName:RGBCOLOR(14, 180, 147)};
    _accelerateLabel = [TrackUI getLabelFrame:CGRectMake(55, 75, 70, 12) withTitle:@"急加速0次"];
    NSMutableAttributedString *attributAccelerate = [[NSMutableAttributedString alloc]initWithAttributedString:_accelerateLabel.attributedText];
    [attributAccelerate setAttributes:labelColorDic range:NSMakeRange(3, 1)];
    _accelerateLabel.attributedText = attributAccelerate;
    [_detailView addSubview:_accelerateLabel];
    
    _brakeLabel = [TrackUI getLabelFrame:CGRectMake(140, 75, 70, 12) withTitle:@"急刹车0次"];
    NSMutableAttributedString *attributBrake = [[NSMutableAttributedString alloc]initWithAttributedString:_brakeLabel.attributedText];
    [attributBrake setAttributes:labelColorDic range:NSMakeRange(3, 1)];
    _brakeLabel.attributedText = attributBrake;
    [_detailView addSubview:_brakeLabel];
    
    _sharpTurnLabel = [TrackUI getLabelFrame:CGRectMake(240, 75, 70, 12) withTitle:@"急转弯0次"];
    NSMutableAttributedString *attributHighSpeed = [[NSMutableAttributedString alloc]initWithAttributedString:_sharpTurnLabel.attributedText];
    [attributHighSpeed setAttributes:labelColorDic range:NSMakeRange(3, 1)];
    _sharpTurnLabel.attributedText = attributHighSpeed;
    [_detailView addSubview:_sharpTurnLabel];
    
    [_detailView addSubview:locationInfoView];
    [self.view addSubview:_detailView];
}

//根据坐标获取车辆具体位置名称
-(void)setCarLocationName:(CLLocationCoordinate2D)coor{
    //初始化检索对象

    _searchGeo = [[BMKGeoCodeSearch alloc]init];
    _searchGeo.delegate = self;
    BMKReverseGeoCodeOption *reverGer = [[BMKReverseGeoCodeOption alloc]init];
    reverGer.reverseGeoPoint = coor;
    BOOL flag = [_searchGeo reverseGeoCode:reverGer];
    if (flag) {
        NSLog(@"反检索发送成功");
    }else{
        NSLog(@"反检索发送失败");
    }
}
#pragma mark BMKGeoCodeSearch delegate method
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSString *address = result.address;
        NSLog(@"反检索结果：%@",address);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_locationInfo setTitle:address forState:UIControlStateNormal];
        });
    }
}

#pragma mark update UI
-(void)updateUI:(SectionTrack*)sectionTrack{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_theRunMile setTitle:[NSString stringWithFormat:@"%0.2fkm",sectionTrack.mileage] forState:UIControlStateNormal];
        [_theRunOil setTitle:[NSString stringWithFormat:@"% 0.2fL",sectionTrack.gas] forState:UIControlStateNormal];
        [_theRunTime setTitle:[NSString stringWithFormat:@"%dmin",(sectionTrack.end_time-sectionTrack.start_time)/60] forState:UIControlStateNormal];
        _timeLabel.text = [NSString stringWithFormat:@"%@-%@",sectionTrack.stime,sectionTrack.etime];
        
        NSString *speedUp = [NSString stringWithFormat:@"%d",sectionTrack.rapid_accelerate];
        NSString *brakeDown = [NSString stringWithFormat: @"%d",sectionTrack.rapid_brake];
        NSString *sharpTurn = [NSString stringWithFormat:@"%d",sectionTrack.rapid_turn];
        _accelerateLabel.text = [NSString stringWithFormat:@"急加速%@次",speedUp];
        _brakeLabel.text = [NSString stringWithFormat:@"急刹车%@次",brakeDown];
        _sharpTurnLabel.text = [NSString stringWithFormat:@"急转弯%@次",sharpTurn];
        
        NSMutableAttributedString *attributAccelerate = [[NSMutableAttributedString alloc]initWithAttributedString:_accelerateLabel.attributedText];
        [attributAccelerate setAttributes:labelColorDic range:NSMakeRange(3, speedUp.length)];
        _accelerateLabel.attributedText = attributAccelerate;
  
        NSMutableAttributedString *attributBrake = [[NSMutableAttributedString alloc]initWithAttributedString:_brakeLabel.attributedText];
        [attributBrake setAttributes:labelColorDic range:NSMakeRange(3, brakeDown.length)];
        _brakeLabel.attributedText = attributBrake;
        
        NSMutableAttributedString *attributHighSpeed = [[NSMutableAttributedString alloc]initWithAttributedString:_sharpTurnLabel.attributedText];
        [attributHighSpeed setAttributes:labelColorDic range:NSMakeRange(3, sharpTurn.length)];
        _sharpTurnLabel.attributedText = attributHighSpeed;
    });
}
-(void)requestFailed:(NSDictionary *)dic withTag:(NSInteger)tag{
    
    if (tag == REQUESTTAG) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _nextTrack.hidden = YES;
            _upTrack.hidden = YES;
            [_locationInfo setTitle:@"" forState:UIControlStateNormal];
            [_theRunMile setTitle:@" 0.00km" forState:UIControlStateNormal];
            [_theRunOil setTitle:@" 0.00L" forState:UIControlStateNormal];
            [_theRunTime setTitle:@" 0min" forState:UIControlStateNormal];
            _timeLabel.text = @"00:00-00:00";
            
            NSMutableAttributedString *attributAccelerate = [[NSMutableAttributedString alloc]initWithString:@"急加速0次"];
            [attributAccelerate setAttributes:labelColorDic range:NSMakeRange(3, 1)];
            _accelerateLabel.attributedText = attributAccelerate;
            
            NSMutableAttributedString *attributBrake = [[NSMutableAttributedString alloc]initWithString:@"急刹车0次"];
            [attributBrake setAttributes:labelColorDic range:NSMakeRange(3, 1)];
            _brakeLabel.attributedText = attributBrake;
            
            NSMutableAttributedString *attributHighSpeed = [[NSMutableAttributedString alloc]initWithString:@"急转弯0次"];
            [attributHighSpeed setAttributes:labelColorDic range:NSMakeRange(3, 1)];
            _sharpTurnLabel.attributedText = attributHighSpeed;
        });
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
