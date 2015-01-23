//
//  CarManageViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/7.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "CarManageViewController.h"
#import "WebViewController.h"
#import "CarInfoData.h"
#import "UIImageView+AFNetworking.h"
#import "AddViewController.h"
#import "CarManageCell.h"
#import "WKTableViewCell.h"



@interface CarManageViewController ()<ToolRequestDelegate,UITableViewDataSource,UITableViewDelegate,WKTableViewCellDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_carsArray;
    NSInteger currentIndex;
}
@end

@implementation CarManageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCarsData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex = -1;
    self.title = @"我的爱车";
    _carsArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _carsArray.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *carReuseId = @"carreuseid";
    
    
//    UITableViewCell *carCell = [tableView dequeueReusableCellWithIdentifier:carReuseId];
//    if (!carCell) {
//        carCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:carReuseId];
//    }

    if (indexPath.row == (_carsArray.count)) {
        UITableViewCell *carCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        carCell.textLabel.text = @"添加我的爱车";
        carCell.imageView.image = [UIImage imageNamed:@"car_add"];
        return carCell;
    }else{
        CarInfoData *carInfo = (CarInfoData*)_carsArray[indexPath.row];
        CarManageCell *carCell;
        if (carInfo.obd_bind) {
            carCell = [[CarManageCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:carReuseId
                                                                delegate:self
                                                             inTableView:tableView withRightButtonTitles:@[@"解绑",@"删除"]];
        }else{
            carCell = [[CarManageCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:carReuseId
                                                                delegate:self
                                                             inTableView:tableView withRightButtonTitles:@[@"绑定",@"删除"]];
        }
        if (carInfo.default_car == 1) {
            currentIndex = indexPath.row;
            [UserInfo sharedUserInfo].car_id = carInfo.car_id;
            carCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        carCell.brandLable.text = [NSString stringWithFormat:@"%@(%@)",carInfo.car_no,carInfo.brand_name];
        [carCell.logoImage setImageWithURL:[NSURL URLWithString:carInfo.brand_logo] placeholderImage:[UIImage imageNamed:@"person_carlogo"]];
            return carCell;
//        carCell.imageView.image = [UIImage imageNamed:@"person_carlogo"];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"解绑";
//}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}
#pragma mark 单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _carsArray.count ) {
        AddViewController *addVC = [[AddViewController alloc]init];
        [self.navigationController pushViewController:addVC animated:YES];
    }else{
        if(indexPath.row == currentIndex){
            return;
        }
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        if (newCell.accessoryType == UITableViewCellAccessoryNone) {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
        if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        currentIndex=indexPath.row;
        [self setDafaultCar:(CarInfoData *)_carsArray[indexPath.row]];
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [Tool showAlertMessage:@"您不能解绑"];
////    [self obdRelease:(CarInfoData *)_carsArray[indexPath.row]];
//}

#pragma  mark Get Car List
-(void)getCarsData{
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"lists",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
    
}
-(void)setDafaultCar:(CarInfoData *)carInfo{
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"select",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"car_id":[NSNumber numberWithInt:carInfo.car_id]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
}
#pragma mark Delete Car
-(void)obdRelease:(CarInfoData *)carInfo{
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"obdRelease",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"car_id":[NSNumber numberWithInt:carInfo.car_id]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
}
-(void)bindObd:(CarInfoData *)carInfo withObnNo:(NSString *)obdNo{
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"obdRelease",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"car_id":[NSNumber numberWithInt:carInfo.car_id],
                              @"obd_no":obdNo
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
}

-(void)deleteCar:(CarInfoData *)carInfo{
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"obdRelease",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"car_id":[NSNumber numberWithInt:carInfo.car_id]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
}
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
     if(tag == (REQUESTTAG + 1)) {
        [self getCarsData];
    }else{
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        [_carsArray removeAllObjects];
        for (NSDictionary *temp in dataDic) {
            CarInfoData *carInfoData = [CarInfoData objectWithKeyValues:temp];
            [_carsArray addObject:carInfoData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.carTableView reloadData];
        });
    }
}

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row == currentIndex){
//        return UITableViewCellAccessoryCheckmark;
//    }
//    else{
//        return UITableViewCellAccessoryNone;
//    }
//}

#pragma mark - WKTableViewCellDelegate
-(void)buttonTouchedOnCell:(WKTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath atButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"row:%ld,buttonIndex:%ld",(long)indexPath.row,(long)buttonIndex);
    if (buttonIndex == 0){
        CarInfoData *carInfodata = (CarInfoData *)_carsArray[indexPath.row];
        if (carInfodata.obd_bind) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            [self obdRelease:carInfodata];
        }else{
            
        }
    }
    else if (buttonIndex == 1){
        [Tool showAlertMessage:@"暂时无法删除"];
    }
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
