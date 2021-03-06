//
//  ScreenCaptureImage.m
//  ScreenCaptureSDK
//
//  Created by newman on 1/5/15.
//  Copyright (c) 2015 weikai.xu. All rights reserved.
//

#import "ScreenCaptureImage.h"
#import <CoreMedia/CoreMedia.h>


@interface ScreenCaptureImage ()
{

}

@end

@implementation ScreenCaptureImage
static ScreenCaptureImage	*screenCaptureImage = nil;	//单例对象

+(id)shareInstance
{
    @synchronized(self)
    {
        if (nil==screenCaptureImage)
        {
            screenCaptureImage = [[ScreenCaptureImage alloc] init];
        }
    }
    return screenCaptureImage;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (screenCaptureImage == nil)
        {
            screenCaptureImage = [super allocWithZone:zone];
            return screenCaptureImage;
        }
    }
    return nil;
}


- (UIImage *)CaptureView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width*2, view.frame.size.height*2.0), YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    CGRect rect =CGRectMake(0, 0, view.frame.size.width*2.0, view.frame.size.height*2.0);
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    UIImageWriteToSavedPhotosAlbum( sendImage, nil, nil , nil ) ;
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"result"];
    [imageViewData writeToFile:savedImagePath atomically:YES];
    CGImageRelease(imageRefRect);
    
    UIImage *imageHead = [UIImage imageNamed:@"CaptureImageHead"];
    UIImage *imageBottom = [UIImage imageNamed:@"CaptureImageBottom"];

    CGSize size = CGSizeMake(sendImage.size.width, sendImage.size.height + 391.0*(sendImage.size.width/750.0));
    UIGraphicsBeginImageContext(size);
    
    [sendImage drawInRect:CGRectMake(0, 175.0*(sendImage.size.width/750.0), sendImage.size.width, sendImage.size.height)];
    
    [imageHead drawInRect:CGRectMake(0, 0, sendImage.size.width,
                                       175.0*(sendImage.size.width/750.0))];
    
    [imageBottom drawInRect:CGRectMake(0, 175.0*(sendImage.size.width/750.0) + sendImage.size.height - 40.0*(sendImage.size.width/750.0),
                                     sendImage.size.width, 256.0*(sendImage.size.width/750.0))];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(resultingImage, nil, nil , nil) ;
    
    return resultingImage;
}



@end
