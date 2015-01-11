//
//  TrackUI.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/11.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackUI : NSObject

+(UIButton *)getBtnFrame:(CGRect)rect withImageName:(NSString*)name withColor:(UIColor *)color withFontSize:(NSInteger)size;
+(UILabel *)getLabelFrame:(CGRect)rect withTitle:(NSString *)title;
@end
