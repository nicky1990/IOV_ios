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
#import "UIImageView+AFNetworking.h"
#import "VPImageCropperViewController.h"
#import "ToolImage.h"
#import "MyAddressViewController.h"
#import "ToolSelectArea.h"
#import "AreaInfo.h"


@interface PersonInfoViewController ()<UITableViewDataSource,UITableViewDelegate,ToolRequestDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,VPImageCropperDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITableView *_infoTableView;
    NSArray *_typeArray;
    PersonInfo *_personInfo;
    UIImageView *_headImage;
    
    UIPickerView *_pickView;
    NSMutableArray *_pickProvinceArray;
    NSMutableArray *_pickCityArray;
    UIView *_selectView;
    int cityId;
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
    [self initSelectView];
    
}

-(void)initUI{
    _typeArray = @[@"头像",@"昵称",@"姓名",@"性别",@"生日",@"所在城市",@"我的地址"];
    NSLog(@"%f",kH_SreenHeight);
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth,kH_SreenHeight-64) style:UITableViewStyleGrouped];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_infoTableView];
    
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(kW_SreenWidth-80, 5, 40, 40)];
    _headImage.layer.cornerRadius = 20;
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.borderWidth = 2;
    _headImage.layer.borderColor = [kMAINCOLOR CGColor];
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
    if (section == 0) {
        return 15;
    }else{
        return 0.1;
    }
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
                if ([ToolImage getHeadImage]) {
                    _headImage.image = [ToolImage getHeadImage];
                }else{
                    [_headImage setImageWithURL:[NSURL URLWithString:_personInfo.avatar] placeholderImage:[UIImage imageNamed:@"home_headdefault"]];
                }
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
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",_personInfo.province,_personInfo.city];
//                cell.detailTextLabel.text = @"";
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
        switch (indexPath.row) {
            case 0:
            {
                UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"取消"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"拍照", @"从相册中选取", nil];
                [choiceSheet showInView:self.view];
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
                if (_selectView.hidden) {
                    _selectView.hidden = NO;
                }else{
                    _selectView.hidden = YES;
                }
            }
                break;
            case 6:
            {
                MyAddressViewController *addressVC = [[MyAddressViewController alloc]init];
                [self.navigationController pushViewController:addressVC animated:YES];
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
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
    if (tag == REQUESTTAG) {
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        _personInfo = [PersonInfo objectWithKeyValues:dataDic];
        cityId = _personInfo.city_id;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_infoTableView reloadData];
        });
    }else if(tag == REQUESTTAG+1){
        [self getPersonInfoData];
    }
}
#pragma mark select headimage
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
//        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        portraitImg = [ToolImage imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:1];
        imgEditorVC.delegate = self;
        
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

#pragma mark upload headImagd
-(void)uploadHeadImage:(NSString *)filePath{
    NSDictionary *paraDic = @{@"c":@"user",
                              @"a":@"infoSave",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"variate_name":@"avatar",
                              @"variate_value":@"",
                              };
//    NSString *phoneNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumberDefault"];
    [[ToolRequest getRequestManager]POST:BASEURL parameters:paraDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *error;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" error:&error];
        NSLog(@"error:%@",error);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"userheadimagechange" object:nil];
        }
        NSLog(@"success:%@",dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"上传失败%@",error.localizedDescription);
    }];

}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    NSString * tmpPath = NSTemporaryDirectory();
    //目标路径
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumberDefault"];
    NSString *filePath=[tmpPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",phoneNum]];
    NSLog(@"file:%@",filePath);
    [ToolImage saveHeadImage:editedImage];
    [self uploadHeadImage:filePath];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}
#pragma mark city select
-(void)initSelectView{
    _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, kH_SreenHeight-64-49-216-44, kW_SreenWidth, 216+44)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 44)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelClick)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(comfirmClick)];
    UIBarButtonItem *center = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[left,center,right]];
    
    [_selectView addSubview:toolBar];
    
    
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, kW_SreenWidth, 216)];
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.showsSelectionIndicator = YES;
    [_selectView addSubview:_pickView];
    _selectView.hidden = YES;
    [self.view addSubview:_selectView];
    _pickCityArray = [[NSMutableArray alloc]init];
    _pickProvinceArray = [ToolSelectArea selectGetAreaWithId:1];
}
-(void)cancelClick{
    _selectView.hidden = YES;
}
-(void)comfirmClick{
    _selectView.hidden = YES;
    NSDictionary *paraDic = @{@"c":@"user",
                              @"a":@"infoSave",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"variate_name":@"city",
                              @"variate_value":[NSNumber numberWithInt:cityId]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
}

#pragma mark Picker Delegate Methods
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _pickProvinceArray.count;
    }else{
        return _pickCityArray.count;
    }
    
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        AreaInfo *areaInfo = (AreaInfo *)_pickProvinceArray[row];
        return areaInfo.region_name;
    }else{
        AreaInfo *areaInfo = (AreaInfo *)_pickCityArray[row];
        return areaInfo.region_name;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (_pickProvinceArray.count != 0) {
            AreaInfo *areaInfo = (AreaInfo *)_pickProvinceArray[row];
            _pickCityArray = [ToolSelectArea selectGetAreaWithId:areaInfo.region_id];
            dispatch_async(dispatch_get_main_queue(), ^{
                AreaInfo *tempInfo = _pickCityArray[0];
                cityId = tempInfo.region_id;
                [_pickView reloadComponent:1];
                [_pickView selectRow:0 inComponent:1 animated:YES];
            });
        }
    }else{
        if (_pickCityArray != 0) {
            AreaInfo *areaInfo = (AreaInfo *)_pickCityArray[row];
            cityId = areaInfo.region_id;
        }
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
