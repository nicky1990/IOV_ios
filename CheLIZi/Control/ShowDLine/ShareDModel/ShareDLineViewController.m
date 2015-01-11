//
//  ShareDLineViewController.m
//  ShareD
//
//  Created by newman on 15-1-1.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import "ShareDLineViewController.h"
#import "ShareDLineTitleView.h"
#import "OBDTableView.h"
#import "ToolUMShare.h"

#import "ScreenCaptureImage.h"

@interface ShareDLineViewController ()
{
    ShareDLineTitleView *shareDLineTitleView;
    OBDTableView *obdTableView;
}
@end

@implementation ShareDLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor grayColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self creatTitleView];
}

- (UIImage *)captureScreen
{
        CGRect frame = self.view.frame;
        
        float addLong = 0;
        
        for(OBDData *data in obdTableView.list)
        {
            UIFont *font = [UIFont systemFontOfSize:13];
            CGSize size = CGSizeMake(self.view.frame.size.width*(490.0/750.0),2000);
            CGRect labelRect = [data.title boundingRectWithSize:size
                                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                     attributes:[NSDictionary dictionaryWithObject:font
                                                                                            forKey:NSFontAttributeName] context:nil];
            font = [UIFont systemFontOfSize:12];
            CGRect labelRect2 = [data.content boundingRectWithSize:size
                                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                        attributes:[NSDictionary dictionaryWithObject:font
                                                                                               forKey:NSFontAttributeName] context:nil];
            double imageHeight = self.view.frame.size.width*(40.0/750.0);
            for(UIImage *im in data.imageArray)
            {
                imageHeight = imageHeight + im.size.height*(self.view.frame.size.width*1.0/im.size.width);
            }
            if(imageHeight == self.view.frame.size.width*(40.0/750.0))imageHeight = 0;
            addLong = addLong + self.view.frame.size.width*(65.0/750.0) + labelRect.size.height + labelRect2.size.height + imageHeight;
        }
        
        addLong = addLong + self.view.frame.size.width*(116.0/375.0);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, addLong)];
            [obdTableView setFrame:CGRectMake(0,
                                              self.view.frame.size.width*(116.0/375.0),
                                              self.view.frame.size.width,
                                              self.view.frame.size.height - self.view.frame.size.width*(116.0/375.0))];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[ScreenCaptureImage shareInstance] CaptureView:self.view];
            UIImage *resutltImage =  [[ScreenCaptureImage shareInstance] CaptureView:self.view];
            [self shareImage:resutltImage];
            [self.view setFrame:frame];
            [obdTableView setFrame:CGRectMake(0,
                                              self.view.frame.size.width*(116.0/375.0),
                                              self.view.frame.size.width,
                                              self.view.frame.size.height - self.view.frame.size.width*((116.0 + 49)/375.0))];
        });
    
    return nil;
}

//创建顶栏
- (void)creatTitleView
{
    shareDLineTitleView = [[ShareDLineTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*(116.0/375.0))];
    [shareDLineTitleView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:shareDLineTitleView];
    [shareDLineTitleView setUserName:@"naturephoto" userIcon:nil];
    
    obdTableView = [[OBDTableView alloc]initWithFrame:CGRectMake(0,
                                                                 self.view.frame.size.width*(116.0/375.0),
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height - self.view.frame.size.width*((116.0 + 49)/375.0))];
    [obdTableView createTableView];
    [self.view addSubview:obdTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}


-(void)shareImage:(UIImage *)image{
    
    [ToolUMShare shareWithTarget:self withImage:image];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
