//
//  DataBase.m
//  TestSQLite
//
//  Created by 点睛石 on 14-8-25.
//  Copyright (c) 2014年 点睛石. All rights reserved.
//

#import "DataBase.h"

@implementation DataBase

static sqlite3 *dbPoint = nil;

+ (sqlite3 *)openDB
{
    if(dbPoint)
    {
        return dbPoint;
    }
    //目标路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *sqlFilePath = [docPath stringByAppendingPathComponent:@"gulu.sqlite"];

    //原始路径
    NSString *orignFilePath = [[NSBundle mainBundle] pathForResource:@"gulu" ofType:@"sqlite"];
    
//    NSLog(@"%@\n%@",sqlFilePath,orignFilePath);
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:sqlFilePath] == NO)//如果doc下没有数据库，从bundle里面拷贝过来
    {
        NSError *err = nil;
        if([fm copyItemAtPath:orignFilePath toPath:sqlFilePath error:&err] == NO)//如果拷贝失败
        {
            NSLog(@"open database error %@",[err localizedDescription]);
            return nil;
        }
    }
//    NSLog(@"open DB at path:%@",sqlFilePath);
    sqlite3_open([sqlFilePath UTF8String], &dbPoint);
    return dbPoint;
}


+ (void)closeDB
{
    if(dbPoint)
    {
        sqlite3_close(dbPoint);
    }
}


@end
