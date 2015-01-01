//
//  Tool.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/1.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+(float)getCachesSize{
    //Library目录
    NSArray * array2 = NSSearchPathForDirectoriesInDomains(
                                                           NSLibraryDirectory,
                                                           NSUserDomainMask, YES);
    NSString * libPath = [array2 objectAtIndex:0]; //Library目录
    
    NSString *cachePath = [NSString stringWithFormat:@"%@/Caches",libPath];
    return [Tool folderSizeAtPath:cachePath];
}

+(void)clearCaches{
    //Library目录
    NSArray * array2 = NSSearchPathForDirectoriesInDomains(
                                                           NSLibraryDirectory,
                                                           NSUserDomainMask, YES);
    NSString * libPath = [array2 objectAtIndex:0]; //Library目录
    
    NSString *cachePath = [NSString stringWithFormat:@"%@/Caches",libPath];
    [[NSFileManager defaultManager]removeItemAtPath:cachePath error:nil];
}

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

@end
