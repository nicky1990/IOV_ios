//
//  ToolSelectArea.m
//  中国省市区数据库使用
//
//  Created by 点睛石 on 15/1/21.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "ToolSelectArea.h"
#import "DataBase.h"


@implementation ToolSelectArea

//region_id
//parent_id
//region_name
//region_type

+(NSMutableArray*)selectGetAreaWithId:(int)regionid{
    NSMutableArray *array = nil;
    
    //获取链接
    sqlite3 *conn = [DataBase openDB];
    //创建语句对象
    sqlite3_stmt *stmt = nil;
    //给语句对象赋值
    int flag = sqlite3_prepare_v2(conn, "select * from clw_region where parent_id =(?)", -1, &stmt, nil);
    sqlite3_bind_int(stmt, 1, regionid);
    
    if (flag == SQLITE_OK) {//判断sql的有效性
        array = [[NSMutableArray alloc]init];
        while (sqlite3_step(stmt) == SQLITE_ROW) {//判断有没有行记录
            AreaInfo *areaInfo = [[AreaInfo alloc]init];
            areaInfo.region_id = (int)sqlite3_column_int(stmt, 0);
        
            char *date= (char *)sqlite3_column_text(stmt, 2);
            areaInfo.region_name = [NSString stringWithCString:date encoding:NSUTF8StringEncoding];
        
            areaInfo.region_type = (int)sqlite3_column_int(stmt, 3);

            [array addObject:areaInfo];
        }
    }
    sqlite3_finalize(stmt);//关闭语句
    return  array;
}

@end
