//
//  CarManageCell.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/23.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "WKTableViewCell.h"

@interface CarManageCell : WKTableViewCell

@property (nonatomic,strong) UIImageView *logoImage;
@property (nonatomic,strong) UILabel *brandLable;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<WKTableViewCellDelegate>)delegate inTableView:(UITableView *)tableView withRightButtonTitles:(NSArray *)rightButtonTitles;

@end
