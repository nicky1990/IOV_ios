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
#import "WebViewController.h"
#import "CarManageViewController.h"
#import "PersonInfoViewController.h"
#import "VPImageCropperViewController.h"
#import "ToolImage.h"


@interface PersonCenterViewController ()<UIAlertViewDelegate,ToolRequestDelegate>
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
    UIButton *personbtn = (UIButton *)[self.tabBarController.view viewWithTag:398];
    [personbtn setImage:[UIImage imageNamed:@"home_person_selected"] forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _userHeadImage.hidden = YES;
    
    UIButton *personbtn = (UIButton *)[self.tabBarController.view viewWithTag:398];
    [personbtn setImage:[UIImage imageNamed:@"home_person_default"] forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.navigationItem.leftBarButtonItem = nil;
    // Do any additional setup after loading the view from its nib.
    [self initDataAndUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateHeadImage) name:@"userheadimagechange" object:nil];
}
-(void)updateHeadImage{
    _userHeadImage.image = [ToolImage getHeadImage];
}

-(void)initDataAndUI{
    _userHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 40, 40)];
    _userHeadImage.layer.cornerRadius = 20;
    _userHeadImage.layer.masksToBounds = YES;
    _userHeadImage.layer.borderWidth = 2;
    _userHeadImage.layer.borderColor = [kMAINCOLOR CGColor];
    if ([ToolImage getHeadImage]) {
        _userHeadImage.image = [ToolImage getHeadImage];
    }else{
        _userHeadImage.image =  [UIImage imageNamed:@"home_headdefault"];
    }

    
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
            cell.textLabel.text = @"预警设置";
            cell.imageView.image = [UIImage imageNamed:@"person_warnsetting"];
        }
        
    }
    
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _typeArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    }
    
    if (indexPath.section ==2) {
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, kW_SreenWidth, 20)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = @"退出当前账号";
        [cell addSubview:textLabel];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                CarManageViewController *carnManageVC = [[CarManageViewController alloc]init];
                [self.navigationController pushViewController:carnManageVC animated:YES];
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
//                WebViewController *webVC = [[WebViewController alloc]init];
//                webVC.title = @"个人资料";
//                NSString *urtStr = [NSString stringWithFormat:@"%@?c=html5&a=userInfo&access_token=%@",BASEURL,[UserInfo sharedUserInfo].userAccess_token];
//                webVC.urlStr = urtStr;
//                [self.navigationController pushViewController:webVC animated:YES];
                PersonInfoViewController *personInfoVC = [[PersonInfoViewController alloc]init];
                [self.navigationController pushViewController:personInfoVC animated:YES];
                
            }
                break;
            case 1:
            {
                WebViewController *webVC = [[WebViewController alloc]init];
                webVC.title = @"积分匣子";
                NSString *urtStr = [NSString stringWithFormat:@"%@?c=html5&a=integral&access_token=%@",BASEURL,[UserInfo sharedUserInfo].userAccess_token];
                webVC.urlStr = urtStr;
                [self.navigationController pushViewController:webVC animated:YES];

            }
                break;
            case 2:
            {
                WebViewController *webVC = [[WebViewController alloc]init];
                webVC.title = @"奖品卡券";
                NSString *urtStr = [NSString stringWithFormat:@"%@?c=html5&a=prize&access_token=%@",BASEURL,[UserInfo sharedUserInfo].userAccess_token];
                webVC.urlStr = urtStr;
                [self.navigationController pushViewController:webVC animated:YES];
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
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
        NSDictionary *paraDic = @{@"c":@"user",
                                  @"a":@"logout",
                                  @"t":[Tool getCurrentTimeStamp],
                                  @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                                  @"app_key":kAPP_KEY,
                                  };
        ToolRequest *toolRequest = [[ToolRequest alloc]init];
        [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
    }
}

#pragma mark Request Succeed
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
//    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"userheadimagechange" object:nil];
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
