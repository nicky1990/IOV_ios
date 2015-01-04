//
//  PersonCenterViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 14/12/25.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "CarWarnSetViewController.h"
#import "UniversalSetViewController.h"
#import "AboutUsViewController.h"

@interface PersonCenterViewController ()<UIAlertViewDelegate>
{
    NSArray *_typeArray;
    NSArray *_imageArray;
    UIImageView *_userHeadImage;
}
@end

@implementation PersonCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   _userHeadImage.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _userHeadImage.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    // Do any additional setup after loading the view from its nib.

    
    [self initDataAndUI];
}

-(void)initDataAndUI{
    _userHeadImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"person_userhead"]];
    _userHeadImage.frame = CGRectMake(10, 2, 40, 40);
    [self.navigationController.navigationBar addSubview:_userHeadImage];
    
    _typeArray = @[@"个人资料",@"积分匣子",@"奖品卡券",@"通用设置",@"关于我们"];
    _imageArray = @[@"person_info",@"person_integral",@"person_award",@"person_universal",@"person_aboutus"];
    self.personTableView.backgroundColor = [UIColor clearColor];
    self.personTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.personTableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return _typeArray.count;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellReuseId = @"personReuseId";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"车辆管理";
            cell.imageView.image = [UIImage imageNamed:@"person_mycar"];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"车辆预警";
            cell.imageView.image = [UIImage imageNamed:@"person_warnsetting"];
        }
        
    }
    
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _typeArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    }
    
    if (indexPath.section ==2) {
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, kW_SreenWidth, 20)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = @"退出当前账号";
        [cell addSubview:textLabel];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }else if(section == 1){
        return 10;
    }else{
        return 40;
    }
}

#pragma mark 单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了单元格");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                CarWarnSetViewController *carnWarnVC = [[CarWarnSetViewController alloc]init];
                [self.navigationController pushViewController:carnWarnVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
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
                UniversalSetViewController *universalVc = [[UniversalSetViewController alloc]init];
                [self.navigationController pushViewController:universalVc animated:YES];
            }
                break;
            case 4:
            {
                AboutUsViewController *aboutUsVc = [[AboutUsViewController alloc]init];
                [self.navigationController pushViewController:aboutUsVc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
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
