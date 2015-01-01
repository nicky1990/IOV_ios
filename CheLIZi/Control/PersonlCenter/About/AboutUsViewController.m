//
//  AboutUsViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/1.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()<UIAlertViewDelegate>
{
    NSArray *_typeArray;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    // Do any additional setup after loading the view from its nib.
    [self initDataUI];
}
-(void)initDataUI{
    _typeArray = @[@"慷慨善良的去评分",@"官方微信",@"官方微博",@"功能介绍",@"版本更新"];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 4) {
        cell.textLabel.text = _typeArray[indexPath.row];
        cell.detailTextLabel.text = @"已是最新版";
    }else{
        cell.textLabel.text = _typeArray[indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 80)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    protocolBtn.frame = CGRectMake(0, 15, kW_SreenWidth, 20);
    protocolBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    [protocolBtn setTitle:@"车咕噜服务使用协议及隐私条款" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:RGBCOLOR(3, 81, 147) forState:UIControlStateNormal];
    [protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:protocolBtn];
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, kW_SreenWidth, 15)];
    versionLabel.text = @"骐俊通联科技 版权所有";
    versionLabel.font = [UIFont fontWithName:@"Arial" size:12];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = RGBCOLOR(170, 170, 170);
    [view addSubview:versionLabel];
    
    
    UILabel *versionEngLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, kW_SreenWidth, 15)];
    versionEngLabel.text = @"Copyright© 2015-2018 Cheerzing. All rights reserved.";
    versionEngLabel.font = [UIFont fontWithName:@"Arial" size:12];
    versionEngLabel.textAlignment = NSTextAlignmentCenter;
    versionEngLabel.textColor = RGBCOLOR(170, 170, 170);
    [view addSubview:versionEngLabel];
    
    return view;
}

-(void)protocolBtnClick{
    
}

#pragma mark 单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 4) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeCustomView;
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_warn"]];
        image.frame = CGRectMake(0, 0, 32, 32);
        hud.customView = image;
        hud.labelText = @"当前已是最新版本";
        [hud show:YES];
        [hud hide:YES afterDelay:2];
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"已是最新版" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
//        [alert show];
        
    }else{
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                
            }
                break;
            default:
                break;
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"清除");
        
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
