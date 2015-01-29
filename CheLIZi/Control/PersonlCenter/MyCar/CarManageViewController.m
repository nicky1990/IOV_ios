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





@interface CarManageViewController ()<ToolRequestDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_carsArray;
    NSInteger currentIndex;
    CarInfoData *_currentCarInfodata;
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

    UITableViewCell *carCell = [tableView dequeueReusableCellWithIdentifier:carReuseId];
    if (!carCell) {
        carCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:carReuseId];
    }
    if (indexPath.row == (_carsArray.count)) {
        carCell.textLabel.text = @"添加我的爱车";
        carCell.imageView.image = [UIImage imageNamed:@"car_add"];
        return carCell;
    }else{
        CarInfoData *carInfo = (CarInfoData*)_carsArray[indexPath.row];
        if (carInfo.default_car == 1) {
            currentIndex = indexPath.row;
            [UserInfo sharedUserInfo].car_id = carInfo.car_id;
            carCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            carCell.accessoryType = UITableViewCellAccessoryNone;
        }
        carCell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",carInfo.car_no,carInfo.brand_name];
        [carCell.imageView setImageWithURL:[NSURL URLWithString:carInfo.brand_logo] placeholderImage:[UIImage imageNamed:@"person_carlogo"]];
            return carCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark 单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _carsArray.count ) {
        AddViewController *addVC = [[AddViewController alloc]init];
        [self.navigationController pushViewController:addVC animated:YES];
    }else{
        _currentCarInfodata = (CarInfoData *)_carsArray[indexPath.row];
        if (_currentCarInfodata.obd_bind) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设置为默认车辆",@"解绑",@"编辑", @"删除",nil];
            actionSheet.tag = 701;
            [actionSheet showInView:self.view];
        }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设置为默认车辆",@"绑定",@"编辑", @"删除",nil];
            actionSheet.tag = 702;
            [actionSheet showInView:self.view];
        }
    }
   
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            [self setDafaultCar:_currentCarInfodata];
        }
            break;
        case 1:
        {
            if (actionSheet.tag == 701) {
                 [self obdRelease:_currentCarInfodata];
            }else if(actionSheet.tag == 702){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入OBD设备号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField *textField = [alertView textFieldAtIndex:0];
                textField.text = _currentCarInfodata.obd_no;
                [alertView show];

            }
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            [self deleteCar:_currentCarInfodata];
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
}

//-(void)setTableViewDefaultCar{
//    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
//    UITableViewCell *newCell = [_carTableView cellForRowAtIndexPath:indexPath];
//    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
//        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    
//    UITableViewCell *oldCell = [_carTableView cellForRowAtIndexPath:oldIndexPath];
//    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
//        oldCell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    currentIndex=indexPath.row;
//    [self setDafaultCar:(CarInfoData *)_carsArray[indexPath.row]];
//}
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
                              @"a":@"obdRebind",
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
                              @"a":@"delete",
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //得到输入框
        UITextField *textField = [alertView textFieldAtIndex:0];
        [self bindObd:_currentCarInfodata withObnNo:textField.text];
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
