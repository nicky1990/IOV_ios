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

@interface CarManageViewController ()<ToolRequestDelegate>
{
    NSMutableArray *_carsArray;
}
@end

@implementation CarManageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCarsData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    }else{
        CarInfoData *carInfo = (CarInfoData*)_carsArray[indexPath.row];
        carCell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",carInfo.car_no,carInfo.brand_name];
        carCell.imageView.image = [UIImage imageNamed:@"person_carlogo"];
    }
    
    
    return carCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _carsArray.count ) {
        WebViewController *webVC = [[WebViewController alloc]init];
        webVC.title = @"添加我的爱车";
        NSString *urtStr = [NSString stringWithFormat:@"%@?c=html5&a=addCar&access_token=%@",BASEURL,[UserInfo sharedUserInfo].userAccess_token];
        webVC.urlStr = urtStr;
        [self.navigationController pushViewController:webVC animated:YES];
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了删除");
}

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
-(void)requestSucceed:(NSDictionary *)dic wihtTag:(NSInteger)tag{
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
