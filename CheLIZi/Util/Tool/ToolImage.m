//
//  ToolImage.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/17.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "ToolImage.h"
#define ORIGINAL_MAX_WIDTH 240

@implementation ToolImage

#pragma mark image scale utility
+(UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+(UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    NSLog(@"=====%@",NSStringFromCGSize(newImage.size));
    return newImage;
}

+(UIImage *)getHeadImage{
    NSString * tmpPath = NSTemporaryDirectory();
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumberDefault"];
    NSString *filePath=[tmpPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",phoneNum]];
    NSData *tempData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:[filePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], 1);
    NSLog(@"====%ld",tempData.length);
    
    return [UIImage imageWithContentsOfFile:[filePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}
+(void)saveHeadImage:(UIImage *)image{
    NSString * tmpPath = NSTemporaryDirectory();
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumberDefault"];
    NSString *filePath=[tmpPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",phoneNum]];
    NSData *tempData = UIImageJPEGRepresentation(image, 0.5);
    NSLog(@"====%ld",tempData.length);
    
    [tempData writeToFile:filePath atomically:YES];
}
@end
