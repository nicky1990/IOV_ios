//
//  MessageTableViewCell.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/5.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@end
