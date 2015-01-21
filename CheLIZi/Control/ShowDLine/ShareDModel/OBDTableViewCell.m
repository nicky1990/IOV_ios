//
//  OBDTableViewCell.m
//  ShareD
//
//  Created by newman on 15-1-2.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import "OBDTableViewCell.h"
#import <CoreText/CoreText.h>

@interface OBDTableViewCell ()
{
    UIImageView *backgroundView;
    
    UILabel *timeLabel;
    UILabel *titleLabel;
    UILabel *contentLabel;
    UIImageView *iconView;
    UIImageView *coordinatesIconView;
    float width;
    NSMutableArray *imageViewArray;
}
@end

@implementation OBDTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        titleLabel = [[UILabel alloc]init];
        contentLabel = [[UILabel alloc]init];
        timeLabel = [[UILabel alloc]init];
        backgroundView = [[UIImageView alloc]init];
        iconView = [[UIImageView alloc]init];
        coordinatesIconView = [[UIImageView alloc]init];
        imageViewArray = [[NSMutableArray alloc]initWithObjects: nil];
        [self addSubview:backgroundView];
    }
    return self;
}

//确定列表cell属性
- (void)createOBDTitle:(NSString *)str time:(NSDate *)time content:(NSString*)content image:(NSMutableArray *)imageArray
{
    width = self.frame.size.width;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [backgroundView setFrame:CGRectMake(-1,
                                        self.frame.size.width*(21.0/750.0),
                                        self.frame.size.width+2,
                                        self.frame.size.height - self.frame.size.width*(20.0/750.0))];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    [[backgroundView layer] setBorderWidth:0.5];//画线的宽度
    [[backgroundView layer] setBorderColor:[UIColor lightGrayColor].CGColor];//颜色
    [backgroundView.layer setMasksToBounds:YES];
    backgroundView.userInteractionEnabled = NO;

    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = CGSizeMake(width*(490.0/750.0),2000);
    CGRect labelRect = [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];

    [titleLabel setFrame:CGRectMake(width*(178.0/750.0), width*(25.0/750.0), labelRect.size.width, labelRect.size.height)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = str;
    titleLabel.font = [UIFont systemFontOfSize:13];
    [backgroundView addSubview: titleLabel];
    
    [coordinatesIconView setFrame:CGRectMake([self getSeparatedLinesFromLabel:titleLabel] + width*(21.0/750.0),
                                             titleLabel.frame.size.height - width*(28.0/750.0),
                                             width*(21.0/750.0),
                                             width*(28.0/750.0))];
    [coordinatesIconView setImage:[UIImage imageNamed:@"coordinates"]];
    [titleLabel addSubview:coordinatesIconView];
    
    font = [UIFont systemFontOfSize:12];
    labelRect = [content boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    [contentLabel setFrame:CGRectMake(width*(178.0/750.0), titleLabel.frame.size.height + width*(25.0/750.0), labelRect.size.width, labelRect.size.height)];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.numberOfLines = 0;
    contentLabel.text = content;
    contentLabel.font = [UIFont systemFontOfSize:12];
    [backgroundView addSubview: contentLabel];
    
    for(UIImageView *imageView in imageViewArray)
    {
        [imageView removeFromSuperview];
        [imageViewArray removeObject:imageView];
    }
    
    float imageHeight = contentLabel.frame.origin.y + contentLabel.frame.size.height + (width*(40.0/750.0));
    if([contentLabel.text isEqualToString:@""])imageHeight = imageHeight - contentLabel.frame.size.height;
    if(imageArray != nil)
    {
        for(UIImage *image in imageArray)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width*(60.0/750.0), imageHeight, width*(630.0/750.0), image.size.height*(width*(630.0/750.0)/image.size.width))];
            [imageView setImage:image];
            imageHeight = imageHeight + image.size.height*(width*(630.0/750.0)/image.size.width);
            [imageViewArray addObject:imageView];
            [self addSubview:imageView];
            
            imageView.userInteractionEnabled = YES;
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressedImage:)];
            longPressGestureRecognizer.minimumPressDuration = 1.0;
            [imageView addGestureRecognizer:longPressGestureRecognizer];

        }
    }
    
    float iconViewY = (contentLabel.frame.origin.y + contentLabel.frame.size.height)/2.0 - width*(30/750.0);
    if(![contentLabel.text isEqualToString:@""])iconViewY = iconViewY + width*(20.0/750.0);
    [iconView setFrame:CGRectMake(self.frame.size.width*(136.0/750)+1 - width*(22.5/750.0),
                                  iconViewY,
                                  width*(45.0/750.0),
                                  width*(45.0/750.0))];
    
    [timeLabel setFrame:CGRectMake(width*(25.0/750.0), iconViewY + width*(5.0/750.0), width*(84.0/750.0), width*(31.0/750.0))];
    timeLabel.numberOfLines = 1;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateAndTime = [dateFormatter stringFromDate:time];
    timeLabel.text = dateAndTime;
    timeLabel.font = [UIFont systemFontOfSize:13];
    [backgroundView addSubview: timeLabel];
    
    NSDateFormatter *dateH = [[NSDateFormatter alloc] init];
    [dateH setDateFormat:@"HH"];
    NSString *strH = [dateH stringFromDate:time];
    if([strH intValue] >= 18 || [strH intValue] <= 5)
    {
        [iconView setImage:[UIImage imageNamed:@"moon"]];
    }
    else
    {
       [iconView setImage:[UIImage imageNamed:@"sun"]];
    }
    [backgroundView addSubview:iconView];
    
    UIGraphicsBeginImageContext(backgroundView.frame.size);
    [backgroundView.image drawInRect:CGRectMake(0, 0, backgroundView.frame.size.width, backgroundView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.5);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.8, 0.8, 0.8, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.frame.size.width*(136.0/750)+1, 0);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.frame.size.width*(136.0/750)+1, self.frame.size.height);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    backgroundView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


 -(float)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    id line = [lines lastObject];
    CTLineRef lineRef = (__bridge CTLineRef )line;
    CFRange lineRange = CTLineGetStringRange(lineRef);
    NSRange range = NSMakeRange(lineRange.location, lineRange.length);
    NSString *lineString = [text substringWithRange:range];
    CGSize size = CGSizeMake(self.frame.size.width*(490.0/750.0),2000);
    CGRect labelRect = [lineString boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return labelRect.size.width;
}


//长按照片删除手势
- (void)pressedImage:(UIGestureRecognizer *)ges
{
    if(ges.state == 1)
    {
        NSNumber *number = [NSNumber numberWithInteger:[imageViewArray indexOfObject:ges.view]];
        NSDictionary *dictionary = @{ @"number": number, @"cell" : self};
       [[NSNotificationCenter defaultCenter]postNotificationName:@"pressedCellImage" object:self userInfo:dictionary];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
