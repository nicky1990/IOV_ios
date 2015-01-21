//
//  MessageViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/5.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "DetailViewController.h"
#import "PushMessage.h"

@interface MessageViewController ()<ToolRequestDelegate>
{
    NSMutableArray *_listArray;
    NSIndexPath *deleteIndex;;
}
@end

@implementation MessageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMessageList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.messageTable.tableFooterView = [[UIView alloc]init];
    _listArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark uitableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *messageReuseId = @"messageid";
    MessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:messageReuseId];
    if (!messageCell) {
        [tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:messageReuseId];
        messageCell = [tableView dequeueReusableCellWithIdentifier:messageReuseId];
    }
    if (_listArray.count != 0) {
        PushMessage *pushMessage = (PushMessage *)_listArray[indexPath.row];
        messageCell.dateLable.text = pushMessage.msg_date;
        messageCell.timeLabel.text = pushMessage.msg_time;
        messageCell.contentLable.text = pushMessage.content;
    }
    return messageCell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(MessageTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.pushMesage = (PushMessage *)_listArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    deleteIndex = indexPath;
    PushMessage *pushMessage = (PushMessage *)_listArray[indexPath.row];
    NSDictionary *paraDic = @{@"c":@"message",
                              @"a":@"delete",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"message_ids":[NSNumber numberWithInt:pushMessage.message_id]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG+1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getdata
-(void)getMessageList{
    NSDictionary *paraDic = @{@"c":@"message",
                              @"a":@"lists",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"p":[NSNumber numberWithInt:0],
                               @"num":[NSNumber numberWithInt:100],
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}

-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    
    if (REQUESTTAG == tag) {
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        [_listArray removeAllObjects];
        for (NSDictionary *temp in dataDic) {
            PushMessage *pushMessage = [PushMessage objectWithKeyValues:temp];
            [_listArray addObject:pushMessage];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageTable reloadData];
        });
    }else{
        [_listArray removeObjectAtIndex:deleteIndex.row];
        [self.messageTable deleteRowsAtIndexPaths:@[deleteIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.messageTable endEditing:NO];
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
