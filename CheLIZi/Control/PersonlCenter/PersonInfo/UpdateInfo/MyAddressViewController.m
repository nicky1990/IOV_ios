//
//  MyAddressViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/18.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "MyAddressViewController.h"
#import "AddressInfo.h"
#import "ToolSelectArea.h"
#import "AreaInfo.h"

@interface MyAddressViewController ()<UITextFieldDelegate,ToolRequestDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *_pickView;
    NSMutableArray *_pickProvinceArray;
    NSMutableArray *_pickCityArray;
    NSMutableArray *_pickDistrictArray;
    UIView *_selectView;
    
    int provinceId;
    int cityId;
    int districtId;
    NSString *provinceName;
    NSString *cityName;
    NSString *districtName;
}
@end

@implementation MyAddressViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserAddress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的地址";
    // Do any additional setup after loading the view from its nib.
    [self initSelectView];
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

- (IBAction)saveClick:(UIButton *)sender {
    NSDictionary *paraDic = @{@"c":@"user",
                              @"a":@"infoSave",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"consignee":self.nameTextField.text,
                              @"telephone":self.phoneTextField.text,
                              @"country":[NSNumber numberWithInt:1],
                              @"province":[NSNumber numberWithInt:provinceId],
                              @"city":[NSNumber numberWithInt:cityId],
                              @"district":[NSNumber numberWithInt:districtId],
                              @"postcode":self.postTextField.text,
                              @"address":self.detailAddressTextField.text,
                              @"variate_name":@"address"
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
}
-(void)getUserAddress{
    NSDictionary *paraDic = @{@"c":@"user",
                              @"a":@"userAddress",
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
        AddressInfo *addressInfo = [AddressInfo objectWithKeyValues:dataDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nameTextField.text = addressInfo.consignee;
            self.phoneTextField.text = addressInfo.telephone;
            self.areaTextField.text = [NSString stringWithFormat:@"%@ %@ %@",addressInfo.province_name,addressInfo.city_name,addressInfo.district_name];
            self.detailAddressTextField.text = addressInfo.address;
            self.postTextField.text = addressInfo.postcode;
            provinceId = addressInfo.province_id;
            cityId = addressInfo.city_id;
            districtId = addressInfo.district_id;
            provinceName = addressInfo.province_name;
            cityName = addressInfo.city_name;
            districtName = addressInfo.district_name;
        });
    }else if(tag == REQUESTTAG+1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark selectareaView
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
    _pickDistrictArray = [[NSMutableArray alloc]init];
    _pickProvinceArray = [ToolSelectArea selectGetAreaWithId:1];
    AreaInfo *areaData = (AreaInfo *)_pickProvinceArray[0];
    provinceId = areaData.region_id;
    provinceName = areaData.region_name;
}
-(void)cancelClick{
    _selectView.hidden = YES;
}
-(void)comfirmClick{
    _selectView.hidden = YES;
    self.areaTextField.text = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,districtName];
}
-(void)getAreaData:(NSInteger)region withType:(NSInteger)type {
    NSDictionary *paraDic = @{@"c":@"user",
                              @"a":@"region",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"region_id":[NSNumber numberWithInteger:region],
                              @"region_type":[NSNumber numberWithInteger:type]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+5+type];
    
}
#pragma mark Picker Delegate Methods
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _pickProvinceArray.count;
    }else if (component == 1){
        return _pickCityArray.count;
    }else{
        return _pickDistrictArray.count;
    }
    
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        AreaInfo *areaInfo = (AreaInfo *)_pickProvinceArray[row];
        return areaInfo.region_name;
    }else if (component == 1){
        AreaInfo *areaInfo = (AreaInfo *)_pickCityArray[row];
        return areaInfo.region_name;
    }else{
        AreaInfo *areaInfo = (AreaInfo *)_pickDistrictArray[row];
        return areaInfo.region_name;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (_pickProvinceArray.count != 0) {
            AreaInfo *areaInfo = (AreaInfo *)_pickProvinceArray[row];
            provinceId = areaInfo.region_id;
            provinceName = areaInfo.region_name;
            
            _pickCityArray = [ToolSelectArea selectGetAreaWithId:areaInfo.region_id];
            dispatch_async(dispatch_get_main_queue(), ^{
                AreaInfo *tempInfo = _pickCityArray[0];
                cityId = tempInfo.region_id;
                cityName = tempInfo.region_name;
                [_pickView reloadComponent:1];
                [_pickView selectRow:0 inComponent:1 animated:YES];
                
                
                _pickDistrictArray = [ToolSelectArea selectGetAreaWithId:tempInfo.region_id];
                dispatch_async(dispatch_get_main_queue(), ^{
                    AreaInfo *tempInfo2 = _pickDistrictArray[0];
                    districtId = tempInfo2.region_id;
                    districtName = tempInfo2.region_name;
                    [_pickView reloadComponent:2];
                    [_pickView selectRow:0 inComponent:2 animated:YES];
                });
            });
            
        }
    }else if (component == 1){
        if (_pickCityArray.count != 0) {
            AreaInfo *areaInfo = (AreaInfo *)_pickCityArray[row];
            cityId = areaInfo.region_id;
            cityName = areaInfo.region_name;
            
            _pickDistrictArray = [ToolSelectArea selectGetAreaWithId:areaInfo.region_id];
            dispatch_async(dispatch_get_main_queue(), ^{
                AreaInfo *tempInfo = _pickDistrictArray[0];
                districtId = tempInfo.region_id;
                districtName = tempInfo.region_name;
                [_pickView reloadComponent:2];
                [_pickView selectRow:0 inComponent:2 animated:YES];
            });
        }
    }else{
        if (_pickDistrictArray.count != 0) {
            AreaInfo *areaInfo = (AreaInfo *)_pickDistrictArray[row];
            districtId = areaInfo.region_id;
            districtName = areaInfo.region_name;
        }
    }
}

#pragma mark textField Delete Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 603) {
        [self.view endEditing:YES];
        _selectView.hidden = NO;
        return NO;
    }else{
        return YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
  
    if ((kH_SreenHeight == 480) && (textField.tag >= 603)) {
        CGRect frame = self.view.frame;
        frame.origin.y-= 90;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ((kH_SreenHeight == 480) && (textField.tag >= 603)) {
        CGRect frame = self.view.frame;
        frame.origin.y+= 90;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

@end
