//
//  ToolRequest.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/2.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolRequest : NSObject

//刷新access_token
+(void)relushAccessToken;

+(AFHTTPRequestOperationManager *)getRequestManager;

@end
