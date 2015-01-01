//
//  CarWarnSetViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/1.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "CarWarnSetViewController.h"

@interface CarWarnSetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_typeArray;
}
@end

@implementation CarWarnSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预警设置";
    // Do any additional setup after loading the view from its nib.
    [self initDataUI];
}
-(void)initDataUI{
    _typeArray = @[@"水温预警",@"启动预警",@"故障预警",@"超低油量预警",@"低电压预警",@"震动预警",@"拖动预警",@"车门未锁提醒",@"车窗未关提醒",@"车灯未关提醒"];


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
    cell.textLabel.text = _typeArray[indexPath.row];
    return cell;
}

-(void)updateSwitchAtIndexPath:(UISwitch *)sender{
    NSLog(@"%d",sender.on);
    NSLog(@"%@",_typeArray[sender.tag - 300]);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


#pragma mark 单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了单元格");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
