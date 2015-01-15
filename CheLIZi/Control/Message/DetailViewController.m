//
//  DetailViewController.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/5.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<ToolRequestDelegate>

@end

@implementation DetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMessageDetail];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    // Do any additional setup after loading the view from its nib.
}

-(void)getMessageDetail{
    NSDictionary *paraDic = @{@"c":@"message",
                              @"a":@"view",
                              @"t":[Tool getCurrentTimeStamp],
                              @"access_token":[UserInfo sharedUserInfo].userAccess_token,
                              @"app_key":kAPP_KEY,
                              @"message_id":[NSNumber numberWithInt:self.pushMesage.message_id]
                              };
    ToolRequest *toolRequest = [[ToolRequest alloc]init];
    [toolRequest startRequestPostWith:self withParameters:paraDic withTag:REQUESTTAG];
}

-(void)requestSucceed:(NSDictionary *)dic withTag:(NSInteger)tag{
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    self.pushMesage = [PushMessage objectWithKeyValues:dataDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        _dateLable.text = self.pushMesage.msg_date;
        _timeLabel.text = self.pushMesage.msg_time;
        _textView.text = self.pushMesage.content;
        
    });
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
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
