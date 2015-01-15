//
//  UpdateSexViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/13.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "UpdateSexViewController.h"

@interface UpdateSexViewController ()<UITableViewDataSource,UITableViewDelegate,ToolRequestDelegate>
{
    NSArray *_typeArray;
    NSInteger currentIndex;
    UITableView *_tableView;
}
@end

@implementation UpdateSexViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    currentIndex = self.defaultValue;
    [_tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改性别";
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
-(void)initUI{
    _typeArray = @[@"未知",@"男",@"女"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = _typeArray[indexPath.row];
    if (indexPath.row == currentIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == currentIndex){
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    currentIndex=indexPath.row;
    [self updateRequest];
}
#pragma mark UpdateRequest
-(void)updateRequest{
    NSDictionary *paraDic = @{@"c":@"user",
                              @"a":@"infoSave",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"variate_name":@"sex",
                              @"variate_value":[NSNumber numberWithInteger:currentIndex]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}
-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
