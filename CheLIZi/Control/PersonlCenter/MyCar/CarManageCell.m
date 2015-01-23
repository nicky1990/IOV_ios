//
//  CarManageCell.m
//  CheLIZi
//
//  Created by 点睛石 on 15/1/23.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "CarManageCell.h"

@implementation CarManageCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<WKTableViewCellDelegate>)delegate inTableView:(UITableView *)tableView withRightButtonTitles:(NSArray *)rightButtonTitles{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier delegate:delegate inTableView:tableView withRightButtonTitles:rightButtonTitles];
    if (self) {
        self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-20)/2.0, 20, 20)];
        [self.cellContentView addSubview:self.logoImage];
        
        self.brandLable = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 250, self.frame.size.height)];
        [self.cellContentView addSubview:self.brandLable];
    }
    
    return  self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
