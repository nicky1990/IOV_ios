//
//  PersonInfoViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/13.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "PersonInfo.h"
#import "ResetPsdViewController.h"
#import "UpdateNameViewController.h"
#import "UpdateNiChengViewController.h"
#import "UpdateSexViewController.h"
#import "UpdateBirthdayViewController.h"

@interface PersonInfoViewController ()<UITableViewDataSource,UITableViewDelegate,ToolRequestDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_infoTableView;
    NSArray *_typeArray;
    PersonInfo *_personInfo;
    UIImageView *_headImage;
}
@end

@implementation PersonInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getPersonInfoData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

-(void)initUI{
    _typeArray = @[@"头像",@"昵称",@"姓名",@"性别",@"生日",@"所在城市",@"我的地址"];
    NSLog(@"%f",kH_SreenHeight);
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, kW_SreenWidth,kH_SreenHeight-64-15) style:UITableViewStyleGrouped];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_infoTableView];
}

#pragma makr uitableview method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }else{
        return _typeArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _typeArray[indexPath.row];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        switch (indexPath.row) {
            case 0:
            {
                _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(kW_SreenWidth-80, 5, 40, 40)];
                _headImage.image = [UIImage imageNamed:@"person_userhead"];
                [cell addSubview:_headImage];
            }
                break;
            case 1:
            {
                cell.detailTextLabel.text = _personInfo.nickname;
            }
                break;
            case 2:
            {
                cell.detailTextLabel.text = _personInfo.realname;
            }
                break;
            case 3:
            {
                if (_personInfo.sex == 0) {
                    cell.detailTextLabel.text = @"未知";
                }else if (_personInfo.sex == 1){
                    cell.detailTextLabel.text = @"男";
                }else{
                    cell.detailTextLabel.text = @"女";
                }
                
            }
                break;
            case 4:
            {
                cell.detailTextLabel.text = [_personInfo.birthday substringToIndex:10];
            }
                break;
            case 5:
            {
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",_personInfo.province,_personInfo.city];
                cell.detailTextLabel.text = @"";
            }
                break;
            case 6:
            {
                
            }
                break;
            default:
                break;
        }
        

        return cell;
    }else{
        cell.textLabel.text = @"重置密码";
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        /*
        if (indexPath.row == 0) {
            //开启照片库
            UIImagePickerController *img = [[UIImagePickerController alloc]init];
            //判断本地图片库是否可以使用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                img.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                img.delegate = self;
                //推出图像选择视图
                [self presentViewController:img animated:YES completion:nil];
            }
         }
         */
        
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                UpdateNiChengViewController *nichengVC = [[UpdateNiChengViewController alloc]init];
                nichengVC.defaultValue = _personInfo.nickname;
                [self.navigationController pushViewController:nichengVC animated:YES];
            }
                break;
            case 2:
            {
                UpdateNameViewController *nameVC = [[UpdateNameViewController alloc]init];
                nameVC.defaultValue = _personInfo.realname;
                [self.navigationController pushViewController:nameVC animated:YES];
            }
                break;
            case 3:
            {
                UpdateSexViewController *sexVC = [[UpdateSexViewController alloc]init];
                sexVC.defaultValue = _personInfo.sex;
                [self.navigationController pushViewController:sexVC animated:YES];
            }
                break;
            case 4:
            {
                UpdateBirthdayViewController *birthdayVC = [[UpdateBirthdayViewController alloc]init];
                birthdayVC.defaultValue = [_personInfo.birthday substringToIndex:10];
                [self.navigationController pushViewController:birthdayVC animated:YES];
            }
                break;
            case 5:
            {
                
            }
                break;
            default:
                break;
        }

        
    }else{
        ResetPsdViewController *resetPsdVC = [[ResetPsdViewController alloc]init];
        [self.navigationController pushViewController:resetPsdVC animated:YES];
    }
    
}
#pragma mark getdata
-(void)getPersonInfoData{
    NSDictionary *paraDic = @{@"c":@"user",
                              @"a":@"info",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    _personInfo = [PersonInfo objectWithKeyValues:dataDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_infoTableView reloadData];
    });

}
#pragma mark select headimage
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString * tmpPath = NSTemporaryDirectory();
    //目标路径
    NSString *filePath=[tmpPath stringByAppendingPathComponent:@"head.png"];
    NSLog(@"file:%@",filePath);
    UIImage *temp = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *tempData = UIImagePNGRepresentation(temp);
    [tempData writeToFile:filePath atomically:YES];
    _headImage.image = temp;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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
