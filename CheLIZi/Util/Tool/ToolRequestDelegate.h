//
//  ToolRequestDelegate.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/4.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ToolRequestDelegate <NSObject>

-(void)requestSucceed:(NSDictionary *)dic wihtTag:(NSInteger)tag;

@end
