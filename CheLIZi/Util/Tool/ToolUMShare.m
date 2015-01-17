//
//  ToolUMShare.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/4.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "ToolUMShare.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialConfig.h"
#import "UMSocial.h"

@implementation ToolUMShare

+(void)shareWithTarget:(id)controller withImage:(UIImage *)image{
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialSnsService presentSnsIconSheetView:controller
                                    appKey:@"54aa9a0afd98c5b0bd000352"
                                      shareText:@"车咕噜"
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:controller];
    [[UMSocialDataService defaultDataService] requestAddFollow:UMShareToSina followedUsid:@[@"5455246307"] completion:nil];
//    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"5455246307"}];
    
}

@end
