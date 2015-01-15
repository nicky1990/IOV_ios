//
//  ShareDatabate.h
//  ShareD
//
//  Created by newman on 15-1-10.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareDatabate : NSObject

+(id)ServiceInstance;


- (void)saveTheArray:(NSArray *)array forDate:(NSDate*)date;
- (NSArray *)readTheArrayForeDate:(NSDate*)date;

- (NSArray *)readTheArrayForeDate:(NSDate*)date FromNetworkDataArray:(NSArray *)networkArray;

@end
