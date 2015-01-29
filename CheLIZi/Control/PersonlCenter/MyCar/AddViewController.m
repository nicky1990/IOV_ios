//
//  AddViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/12.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "AddViewController.h"
#import "AddCarUI.h"
#import "CarType.h"
#import "UIButtonWithBottomLine.h"
#import "ScanQrcodeViewController.h"

#define kTextFieldHight 44
#define kTextFieldWidth 300
#define kScrollViewContentHeight (([[UIScreen mainScreen] bounds].size.height == 568)?600:700)

@interface AddViewController ()<UITextFieldDelegate,ToolRequestDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>
{
    UIScrollView *_scrollView;
    UITextField *_selectBrandField;
    UITextField *_selectSeriesField;
    UITextField *_selectModelField;
    UITextField *_inputPlateField;
    UITextField *_inputObdidField;
    UITextField *_inputFrameField;
    UITextField *_inputEngineField;
    UIPickerView *_pickView;
    NSMutableArray *_pickData;
    
    CarType *currentCarType;
    UITextField *currentTextField;
    UIView *_selectView;
    int carBrandId ;//当前选中品牌的id
}
@end

@implementation AddViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加我的爱车";
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getObdNo:) name:@"qrcodesuccessget" object:nil];
}

-(void)initUI{
    _pickData = [[NSMutableArray alloc]init];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, kH_SreenHeight-64)];
    _scrollView.contentSize = CGSizeMake(kW_SreenWidth, kScrollViewContentHeight+40);
    [self.view addSubview:_scrollView];
    
    _selectBrandField = [AddCarUI getUITextFieldWithRect:CGRectMake(10, 10, kTextFieldWidth, kTextFieldHight) withImageName:@"add_pinpai" withStringHolder:nil];
    _selectBrandField.delegate = self;
    _selectBrandField.tag = 500;
    _selectBrandField.text = @"请选择品牌";
    UIButton *selectBrandBtn = [[UIButton alloc]initWithFrame:CGRectMake(kW_SreenWidth-44, 0, kTextFieldHight, kTextFieldHight)];
    [selectBrandBtn setImage:[UIImage imageNamed:@"add_xiala"] forState:UIControlStateNormal];
    [selectBrandBtn addTarget:self action:@selector(selectCarBrand) forControlEvents:UIControlEventTouchUpInside];
    _selectBrandField.rightView = selectBrandBtn;
    _selectBrandField.rightViewMode = UITextFieldViewModeAlways;
    
    [_scrollView addSubview:_selectBrandField];
    
    _selectSeriesField = [AddCarUI getUITextFieldWithRect:CGRectMake(10, 10+kTextFieldHight+10, kTextFieldWidth, kTextFieldHight) withImageName:@"add_chexi" withStringHolder:nil];
    _selectSeriesField.delegate = self;
    _selectSeriesField.tag = 501;
    _selectSeriesField.text = @"请选择车系";
    UIButton *selectSeriesBtn = [[UIButton alloc]initWithFrame:CGRectMake(kW_SreenWidth-44, 0, kTextFieldHight, kTextFieldHight)];
    [selectSeriesBtn setImage:[UIImage imageNamed:@"add_xiala"] forState:UIControlStateNormal];
    [selectSeriesBtn addTarget:self action:@selector(selectCarSeries) forControlEvents:UIControlEventTouchUpInside];
    _selectSeriesField.rightView = selectSeriesBtn;
    _selectSeriesField.rightViewMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_selectSeriesField];
    
    _selectModelField = [AddCarUI getUITextFieldWithRect:CGRectMake(10, kTextFieldHight*2+10*3, kTextFieldWidth, kTextFieldHight) withImageName:@"add_chexing" withStringHolder:nil];
    _selectModelField.text = @"请选择车型";
    _selectModelField.delegate = self;
    _selectModelField.tag = 502;
    UIButton *selectModelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kW_SreenWidth-44, 0, kTextFieldHight, kTextFieldHight)];
    [selectModelBtn setImage:[UIImage imageNamed:@"add_xiala"] forState:UIControlStateNormal];
    [selectModelBtn addTarget:self action:@selector(selectCarModel) forControlEvents:UIControlEventTouchUpInside];
    _selectModelField.rightView = selectModelBtn;
    _selectModelField.rightViewMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_selectModelField];
    
    _inputPlateField = [AddCarUI getUITextFieldWithRect:CGRectMake(10, kTextFieldHight*3+10*4, kTextFieldWidth, kTextFieldHight) withImageName:@"add_chepai" withStringHolder:@"请输入车牌号(必填)"];
    _inputPlateField.delegate = self;
    [_scrollView addSubview:_inputPlateField];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10,kTextFieldHight*4+10*5-5 , kTextFieldWidth, 15)];
    label.font = [UIFont fontWithName:@"Arial" size:12];
//    label.textColor = [UIColor redColor];
    label.text = @"  * 填写后不可修改，请填写真实信息。";
    [_scrollView addSubview:label];
    
    _inputObdidField = [AddCarUI getUITextFieldWithRect:CGRectMake(10, kTextFieldHight*4+10*5+20, kTextFieldWidth, kTextFieldHight) withImageName:@"add_obdid" withStringHolder:@"请输入OBD设备号(必填)"];
    _inputObdidField.delegate = self;
    
    UIButton *addQrcodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kW_SreenWidth-44, 0, kTextFieldHight, kTextFieldHight)];
    [addQrcodeBtn setImage:[UIImage imageNamed:@"add_qrcode"] forState:UIControlStateNormal];
    [addQrcodeBtn addTarget:self action:@selector(startScanQrcode) forControlEvents:UIControlEventTouchUpInside];
    _inputObdidField.rightView = addQrcodeBtn;
    _inputObdidField.rightViewMode = UITextFieldViewModeAlways;
    
    [_scrollView addSubview:_inputObdidField];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10,kTextFieldHight*5+10*6+15 , kTextFieldWidth-90, 15)];
    label2.font = [UIFont fontWithName:@"Arial" size:12];
//    label2.textColor = [UIColor redColor];
    label2.text = @"  * 绑定车咕噜OBD设备才可显示数据。";
    [_scrollView addSubview:label2];
    
    UIButtonWithBottomLine *buyBtn = [UIButtonWithBottomLine hyperlinksButton];
    buyBtn.frame = CGRectMake(kTextFieldWidth-95, kTextFieldHight*5+10*6+15+1.5, 60, 12);
    [buyBtn setTitle:@"去购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
//    [_scrollView addSubview:buyBtn];
    
    
    
    _inputFrameField = [AddCarUI getUITextFieldWithRect:CGRectMake(10, kTextFieldHight*5+10*6+40, kTextFieldWidth, kTextFieldHight) withImageName:@"add_chejiahao" withStringHolder:@"请输入车架号(选填)"];
    _inputFrameField.delegate = self;
    [_scrollView addSubview:_inputFrameField];
    
    _inputEngineField = [AddCarUI getUITextFieldWithRect:CGRectMake(10, kTextFieldHight*6+10*7+40, kTextFieldWidth, kTextFieldHight) withImageName:@"add_chepai" withStringHolder:@"请输入发动机号(选填)"];
    _inputEngineField.delegate = self;
    [_scrollView addSubview:_inputEngineField];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(10, kTextFieldHight*7+10*9+40, kTextFieldWidth, kTextFieldHight);
    saveButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:20];
    saveButton.layer.borderWidth = 1;
    saveButton.layer.borderColor = [RGBCOLOR(51, 162, 178) CGColor];
    saveButton.backgroundColor = RGBCOLOR(14, 180, 147);
    [saveButton setTitle:@"添加" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:saveButton];
    
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
}

-(void)cancelClick{
    _selectView.hidden = YES;
}
-(void)comfirmClick{
    _selectView.hidden = YES;
}
#pragma mark scan Qrcode
-(void)startScanQrcode{
    ScanQrcodeViewController * scanQrcodeVC = [[ScanQrcodeViewController alloc]init];
    [self presentViewController:scanQrcodeVC animated:YES completion:^{
        
    }];
}
-(void)getObdNo:(NSNotification *)notifiction{
    NSDictionary *dic = notifiction.userInfo;
    NSString *obdno = [dic objectForKey:@"obdno"];
    _inputObdidField.text = obdno;
}

#pragma mark Request data
-(void)saveClick{
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"add",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"car_no":_inputPlateField.text,
                              @"car_vin":_inputFrameField.text,
                              @"car_engine_no":_inputEngineField,
                              @"obd_no":_inputObdidField.text,
                              @"ct_id":[NSNumber numberWithInt:currentCarType.cb_id],
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}

-(void)getCarDataWithType:(int)type withValue:(int)value{
    NSDictionary *paraDic = @{@"c":@"car",
                              @"a":@"carType",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"type":[NSNumber numberWithInt:type],
                              @"value":[NSNumber numberWithInt:value]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
}
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    if (tag == REQUESTTAG) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSArray *dataDic = [dic objectForKey:@"data"];
        [_pickData removeAllObjects];
        for (NSDictionary *temp in dataDic) {
            CarType *carType = [CarType objectWithKeyValues:temp];
            [_pickData addObject:carType];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_pickView reloadAllComponents];
            [_pickView selectRow:0 inComponent:0 animated:YES];
        });
    }
}

-(void)requestFailed:(NSDictionary *)dic withTag:(NSInteger)tag{
    [_pickData removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_pickView reloadAllComponents];
    });
}

#pragma mark Select View
-(void)selectCarBrand{
    [self.view endEditing:YES];
    [self getCarDataWithType:1 withValue:0];
    currentTextField = (UITextField *)[_scrollView viewWithTag:500];
    if (_selectView.hidden) {
        _selectView.hidden = NO;
    }else{
        _selectView.hidden = YES;
    }
}

-(void)selectCarSeries{
    [self.view endEditing:YES];
    if ([_selectBrandField.text isEqualToString:@"请选择品牌"]) {
        [Tool showAlertMessage:@"请先选择品牌"];
        return;
    }

    currentTextField = (UITextField *)[_scrollView viewWithTag:501];
    if (currentCarType.type == 1) {
        carBrandId = currentCarType.cb_id;
        [self getCarDataWithType:2 withValue:currentCarType.cb_id];
    }else if(currentCarType.type == 3) {
        [self getCarDataWithType:2 withValue:carBrandId];
    }
    if (_selectView.hidden) {
        _selectView.hidden = NO;
    }else{
        _selectView.hidden = YES;
    }
}

-(void)selectCarModel{
    [self.view endEditing:YES];
    if ([_selectSeriesField.text isEqualToString:@"请选择车系"]) {
        [Tool showAlertMessage:@"请先选择车系"];
        return;
    }
    currentTextField = (UITextField *)[_scrollView viewWithTag:502];
    if (currentCarType.type == 2) {
        [self getCarDataWithType:3 withValue:currentCarType.cb_id];
    }
    if (_selectView.hidden) {
        _selectView.hidden = NO;
    }else{
        _selectView.hidden = YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ((textField.tag == 500) || (textField.tag == 501) || (textField.tag == 502)) {
        return NO;
    }else{
        return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Picker Delegate Methods
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickData.count;
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_pickData.count == 0) {
        return nil;
    }
    CarType *carType = (CarType *)[_pickData objectAtIndex:row];
    return carType.name;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_pickData.count == 0) {
        return;
    }
    currentCarType = (CarType *)[_pickData objectAtIndex:row];
    
    currentTextField.text = currentCarType.name;
    
    if (currentTextField.tag == 500) {
        _selectSeriesField.text = @"请选择车系";
        _selectModelField.text = @"请选择车型";
    }
    if (currentTextField.tag == 501) {
        _selectModelField.text = @"请选择车型";
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qrcodesuccessget" object:nil];
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
