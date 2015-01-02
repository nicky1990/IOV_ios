//
//  ToolClearCaches.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/2.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolClearCaches : NSObject

//获取缓存
+(float)getCachesSize;
//清除缓存
+(void)clearCaches;
//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath;
//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath;

@end
