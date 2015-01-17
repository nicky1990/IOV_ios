//
//  ToolImage.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/17.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolImage : NSObject

+(UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
+(UIImage *)getHeadImage;
+(void)saveHeadImage:(UIImage *)image;
@end
