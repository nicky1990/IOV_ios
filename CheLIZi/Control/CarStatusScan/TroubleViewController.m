//
//  TroubleViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/4.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "TroubleViewController.h"
#import "CustomView.h"

@interface TroubleViewController ()

@end

@implementation TroubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"故障码";
    // Do any additional setup after loading the view from its nib.
//    self.troubleArray = @[@"P0123",@"P0123",@"P0123",@"P0123",@"P0123"];
}
#pragma mark Tableview
-(void)initTableView{
}

#pragma mark uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.troubleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"troubleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    NSDictionary *dic = self.troubleArray[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"p"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW_SreenWidth, 30)];
    view.backgroundColor = RGBCOLOR(249, 249, 249);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 6, 6)];
    image.image = [UIImage imageNamed:@"scan_section"];
    [view addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 150, 11)];
    label.font = [UIFont fontWithName:@"Heiti SC" size:10];
    label.text = [NSString stringWithFormat:@"本次有%ld条故障码",self.troubleArray.count];
    label.textColor = RGBCOLOR(102, 102, 102);
    [view addSubview:label];
    
    return view;
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
