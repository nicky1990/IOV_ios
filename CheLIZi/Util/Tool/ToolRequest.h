//
//  ToolRequest.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/2.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToolRequestDelegate.h"

@interface ToolRequest : NSObject

@property (nonatomic, weak) id<ToolRequestDelegate> delegate;

-(void)startRequestPostWith:(id)vc withParameters:(NSDictionary *)paraDic withTag:(NSInteger)tag;

//刷新access_token
+(void)relushAccessToken;

+(AFHTTPRequestOperationManager *)getRequestManager;


@end
