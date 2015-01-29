//
//  UIButtonWithBottomLine.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/28.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "UIButtonWithBottomLine.h"

@implementation UIButtonWithBottomLine


+ (UIButtonWithBottomLine*) hyperlinksButton {
    UIButtonWithBottomLine* button = [UIButtonWithBottomLine buttonWithType:UIButtonTypeRoundedRect];
    return button;
}

- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y+1 + textRect.size.height + descender);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y+1 + textRect.size.height + descender);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
