//
//  UniversalSetViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/1.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "UniversalSetViewController.h"
#import "ToolClearCaches.h"
#import "UMessage.h"

@interface UniversalSetViewController ()<UIAlertViewDelegate>
{
    NSArray *_typeArray;
}
@end

@implementation UniversalSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通用设置";
    // Do any additional setup after loading the view from its nib.
    [self initDataUI];
}

-(void)initDataUI{
    _typeArray = @[@"清除缓存",@"推送通知"];
    self.universalTableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (indexPath.row == 0) {
        cell.textLabel.text = _typeArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02fMB",[ToolClearCaches getCachesSize]];
    }else{
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        NSNumber *numberPush = [[NSUserDefaults standardUserDefaults]objectForKey:@"isUMPush"];
        if (numberPush) {
            [switchview setOn:[numberPush intValue]];
        }else{
            [switchview setOn:YES];
        }
        cell.accessoryView = switchview;
        cell.textLabel.text = _typeArray[indexPath.row];
    }
    return cell;
}

-(void)updateSwitchAtIndexPath:(UISwitch *)sender{
    NSLog(@"%d",sender.on);
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:sender.on] forKey:@"isUMPush"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark 单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定清除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [ToolClearCaches clearCaches];
        [self.universalTableView reloadData];
        [Tool showAlertMessage:@"清除成功"];
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
