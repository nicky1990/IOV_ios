//
//  ToolRequest.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/2.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "ToolRequest.h"

@implementation ToolRequest


-(void)startRequestPostWith:(id)vc withParameters:(NSDictionary *)paraDic withTag:(NSInteger)tag{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithWindow:[[UIApplication sharedApplication].delegate window]];
    [[[UIApplication sharedApplication].delegate window] addSubview:hud];
    [hud show:YES];
    [[ToolRequest getRequestManager] POST:BASEURL parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSDictionary *dic = responseObject;
        NSLog(@"%@",responseObject);
        self.delegate = vc;
        if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
            if ([self.delegate respondsToSelector:@selector(requestSucceed:withTag:)]) {
                [self.delegate requestSucceed:dic withTag:tag];
            }
        }else{
            NSNumber *errCode = [dic objectForKey:@"error_code"];
            if ([errCode intValue] == 1004) {
                [ToolRequest relushAccessToken];
            }else{
                NSString *failMessage = [dic objectForKey:@"error_msg"];
                if ([self.delegate respondsToSelector:@selector(requestFailed:withTag:)]) {
                    [self.delegate requestFailed:dic withTag:tag];
                }
                [Tool showAlertMessage:failMessage];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        NSLog(@"失败%@",error.userInfo);
        [Tool showAlertMessage:error.localizedDescription];
    }];
}

+(void)relushAccessToken{
//    md5(access_token+sid+user_id+appsecret+t)
    NSString *accessStr = [NSString stringWithFormat:@"%@%@%@%@%@",[UserInfo sharedUserInfo].userAccess_token,[UserInfo sharedUserInfo].userS_id,[UserInfo sharedUserInfo].user_id,kSIGNATURE,[Tool getCurrentTimeStamp]];
    NSLog(@"%@",accessStr);
    NSDictionary *paraDic = @{@"c":@"public",
                              @"a":@"refToken",
                              @"t":[Tool getCurrentTimeStamp],
                              @"app_key":kAPP_KEY,
                              @"refresh_token":[Tool md5:accessStr],
                              @"user_id":[UserInfo sharedUserInfo].user_id,
                              @"sid":[UserInfo sharedUserInfo].userS_id
                              };
    [[ToolRequest getRequestManager] POST:BASEURL parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
            NSString *acc_token = [dic objectForKey:@"access_token"];
            [UserInfo sharedUserInfo].userAccess_token = acc_token;
        }else{
            NSString *failMessage = [dic objectForKey:@"error_msg"];
            [Tool showAlertMessage:failMessage];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败%@",error.userInfo);
        
        [Tool showAlertMessage:error.localizedDescription];
    }];
}

+(AFHTTPRequestOperationManager *)getRequestManager{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    operationManager.requestSerializer.timeoutInterval = 10;
    return operationManager;
}

@end
