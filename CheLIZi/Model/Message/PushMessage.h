//
//  PushMessage.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/13.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushMessage : NSObject

@property (nonatomic,assign) int message_id;//消息ID
@property (nonatomic,assign) int add_time;  //添加时间
@property (nonatomic,assign) int read_status;//查看状态
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *msg_date;
@property (nonatomic,strong) NSString *msg_time;

@end
