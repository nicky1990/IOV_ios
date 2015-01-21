//
//  DataBase.h
//  TestSQLite
//
//  Created by 点睛石 on 14-8-25.
//  Copyright (c) 2014年 点睛石. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DataBase : NSObject


+ (sqlite3 *)openDB;
+ (void)closeDB;



@end
