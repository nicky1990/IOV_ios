//
//  WebViewController.h
//  CheLIZi
//
//  Created by 点睛石 on 15/1/6.
//  Copyright (c) 2015年 骐俊通联. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong,nonatomic) NSString *urlStr;


@end
