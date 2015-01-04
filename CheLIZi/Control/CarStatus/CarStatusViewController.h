//
//  CarStatusViewController.h
//  CheLIZi
//
//  Created by 点睛石 on 14/12/31.
//  Copyright (c) 2014年 骐俊通联. All rights reserved.
//

#import "BaseViewController.h"

@interface CarStatusViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *averageOilTenDigit;
@property (weak, nonatomic) IBOutlet UILabel *averageOilunitsDigit;
@property (weak, nonatomic) IBOutlet UILabel *winPercent;
@property (weak, nonatomic) IBOutlet UILabel *sumRunMIle;
@property (weak, nonatomic) IBOutlet UILabel *averageSpeed;
@property (weak, nonatomic) IBOutlet UILabel *currentOil;

- (IBAction)warnSettingClick:(UIButton *)sender;
- (IBAction)carStatusScan:(UIButton *)sender;
- (IBAction)trackClick:(id)sender;

@end
