//
//  ScreenCaptureImage.h
//  ScreenCaptureSDK
//
//  Created by newman on 1/5/15.
//  Copyright (c) 2015 weikai.xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScreenCaptureImage : NSObject

+(id)shareInstance;
- (UIImage *)CaptureView:(UIView *)view;

@end
