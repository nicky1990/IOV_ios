//
//  DetailViewController.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/5.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "BaseViewController.h"
#import "PushMessage.h"

@interface DetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@property (strong,nonatomic) PushMessage *pushMesage;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end
