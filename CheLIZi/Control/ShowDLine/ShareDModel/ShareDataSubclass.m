//
//  ShareDataSubclass.m
//  ShareD
//
//  Created by newman on 15-1-11.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import "ShareDataSubclass.h"

@implementation OBDData

- (id)initWithTitle:(NSString*)title time:(NSDate*)date content:(NSString*)content image:(NSMutableArray *)imageArray
{
    if (self = [super init])
    {
        if(title != nil)_title = [[NSString alloc]initWithString:title];
        if(content != nil)_content = [[NSString alloc]initWithString:content];
        if(imageArray != nil)
        {
            _imageArray = [[NSMutableArray alloc]initWithArray:imageArray];
        }
        else
        {
            _imageArray = [[NSMutableArray alloc]init];
        }
        if(date != nil)_date = date;
    }
    return self;
}


@end

