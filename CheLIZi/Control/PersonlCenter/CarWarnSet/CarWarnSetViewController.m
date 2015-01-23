//
//  CarWarnSetViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/1.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "CarWarnSetViewController.h"
#import "CarSetWarnData.h"


@interface CarWarnSetViewController ()<UITableViewDataSource,UITableViewDelegate,ToolRequestDelegate>
{
    NSMutableArray *_typeArray;
}
@end

@implementation CarWarnSetViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getWarnSetData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预警设置";
    // Do any additional setup after loading the view from its nib.
    [self initDataUI];

}
-(void)initDataUI{
//    NSArray *array = @[@"水温预警",@"启动预警",@"故障预警",@"超低油量预警",@"低电压预警",@"震动预警",@"拖动预警",@"车门未锁提醒",@"车窗未关提醒",@"车灯未关提醒"];
    _typeArray = [[NSMutableArray alloc]init];

    self.setTableView.tableFooterView = [[UIView alloc]init];
}


#pragma mark uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _typeArray.count;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellReuseId = @"warnSetReuseId";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchview.tag = [indexPath row]+300;
    [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchview;
    CarSetWarnData *carSetWarnData = (CarSetWarnData*)_typeArray[indexPath.row];
    cell.textLabel.text = carSetWarnData.warning_title;
    [switchview setOn:carSetWarnData.enabled];
    
    return cell;
}

-(void)updateSwitchAtIndexPath:(UISwitch *)sender{
    NSLog(@"%d",sender.on);
    CarSetWarnData *carSetWarnData = (CarSetWarnData*)_typeArray[sender.tag - 300];
    NSDictionary *paraDic = @{@"c":@"warning",
                              @"a":@"setting",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"warning_code":carSetWarnData.warning_code,
                              @"enabled":[NSNumber numberWithInt:sender.on]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark 单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getWarnSetData{
    NSDictionary *paraDic = @{@"c":@"warning",
                              @"a":@"view",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                            };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
    
}
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    if(tag == (REQUESTTAG + 1)){
        [self getWarnSetData];
    }else{
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        [_typeArray removeAllObjects];
        for (NSDictionary *temp in dataDic) {
            CarSetWarnData *carSetWarn = [CarSetWarnData objectWithKeyValues:temp];
            [_typeArray addObject:carSetWarn];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.setTableView reloadData];
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
