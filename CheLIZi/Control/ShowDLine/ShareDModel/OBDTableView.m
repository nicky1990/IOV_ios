//
//  OBDTableView.m
//  ShareD
//
//  Created by newman on 15-1-1.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import "OBDTableView.h"
#import "OBDTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface OBDTableView ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    int with;
    int height;
    UITableView *tableView;
    NSInteger pessRow;
    
    //文本输入Controller
    __block UIViewController *inputController;
    NSInteger choseRow;
}
@end

@implementation OBDTableView


- (void)createTableView
{
    with = self.frame.size.width;
    height = self.frame.size.height;
    // 初始化tableView的数据
    OBDData *data1 = [[OBDData alloc]initWithTitle:@"测试测试测试测试测试测试测试" time:@"15:30" content:@"测试测试测试测试跳舞特哥不测试测" image:nil];
    OBDData *data2 = [[OBDData alloc]initWithTitle:@"测试测试测试测试测试测试测试测试测试测试测试" time:@"15:30" content:@"测试测试" image:nil];
    OBDData *data3 = [[OBDData alloc]initWithTitle:@"测试测试测试测试测试测试测试" time:@"15:30" content:@"222" image:nil];
    OBDData *data4 = [[OBDData alloc]initWithTitle:@"测试测试测试测试测试测试" time:@"15:30" content:@"测试测试测试测试测试测试测试试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试试测试测试测试测测测试测试测试" image:nil];
    OBDData *data5 = [[OBDData alloc]initWithTitle:@"测试测试测试测试测试" time:@"15:30" content:@"222" image:nil];
    OBDData *data6 = [[OBDData alloc]initWithTitle:@"测试测试测试测试测试测试测试" time:@"15:30" content:@"测试测试测试测试试测试测测试测试测试测试测试测试测试测试" image:nil];
    OBDData *data7 = [[OBDData alloc]initWithTitle:@"测试测试测试测试测试测试测试" time:@"15:30" content:@"" image:nil];
    OBDData *data8 = [[OBDData alloc]initWithTitle:@"测试测试测试测试测试测试测试" time:@"15:30" content:@"" image:nil];
    OBDData *data9 = [[OBDData alloc]initWithTitle:@"测试测试测试测试测试测试测试" time:@"15:30" content:@"" image:nil];
    pessRow = 0;
    
    _list = [@[data1,data2,data3,data4,data5,data6,data7,data8,data9]mutableCopy];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [self addSubview:tableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pressedCellImage:) name:@"pressedCellImage" object:nil];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    with = self.frame.size.width;
    height = self.frame.size.height;
    [tableView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.3, 0.3, 0.3, 1.0};
    CGColorRef color=CGColorCreate(colorspace,components);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextMoveToPoint(context, self.frame.size.width*(136.0/750), 0);
    CGContextAddLineToPoint(context, self.frame.size.width*(136.0/750), self.frame.size.height);
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

#pragma mark -
#pragma mark Table Data Source Methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBDTableViewCell *cell;
    OBDData *data = [_list objectAtIndex:indexPath.row];
    if (cell == nil)
    {
        cell = [[OBDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width*(680.0/750.0),
                                                                  self.frame.size.width*(35.0/750.0),
                                                                  self.frame.size.width*(48.0/750.0),
                                                                  self.frame.size.width*(62.0/750.0))];
        [btn setImage:[UIImage imageNamed:@"Chevron"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cellPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell createOBDTitle:data.title time:data.time content:data.content image:data.imageArray];
    });
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OBDData *data = [_list objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = CGSizeMake(self.frame.size.width*(490.0/750.0),2000);
    CGRect labelRect = [data.title boundingRectWithSize:size
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes:[NSDictionary dictionaryWithObject:font
                                                 forKey:NSFontAttributeName] context:nil];
    font = [UIFont systemFontOfSize:12];
    CGRect labelRect2 = [data.content boundingRectWithSize:size
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes:[NSDictionary dictionaryWithObject:font
                                                                                    forKey:NSFontAttributeName] context:nil];
    
    double imageHeight = with*(40.0/750.0);
    for(UIImage *im in data.imageArray)
    {
        imageHeight = imageHeight + im.size.height*(with*1.0/im.size.width);
    }
    if(imageHeight == with*(40.0/750.0))imageHeight = 0;
    if([data.content isEqualToString:@""])imageHeight = imageHeight - self.frame.size.width*(28.0/750.0);
    return self.frame.size.width*(65.0/750.0) + labelRect.size.height + labelRect2.size.height + imageHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [inputController dismissModalViewControllerAnimated:YES];
    ((OBDData*)[_list objectAtIndex:choseRow]).content = textView.text;
    [tableView reloadData];
}

- (void)cellPressed:(id)sender
{
    UITableViewCell * cell = (UITableViewCell *)[sender superview];
    NSIndexPath *path = [tableView indexPathForCell:cell];
    pessRow = [path row];

    __block OBDTableView *tmp = self;
    __block UITableView *block_tableView = tableView;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"上传照片"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [tmp openPhotoMenu];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"编辑"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                inputController = [[UIViewController alloc]init];
                                                choseRow = path.row;
                                                UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height)];
                                                textView.textColor = [UIColor blackColor];
                                                textView.font = [UIFont fontWithName:@"Arial" size:18.0];
                                                textView.delegate = self;
                                                textView.backgroundColor = [UIColor whiteColor];
                                                [inputController.view addSubview:textView];
                                                textView.text = ((OBDData*)[_list objectAtIndex:path.row]).content;
                                                UIViewController *viewController = [self findViewController:self];
                                                [viewController presentModalViewController:inputController animated:YES];
                                                [textView becomeFirstResponder];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *action) {
                                                [_list removeObjectAtIndex:path.row];
                                                NSIndexPath *te=[NSIndexPath indexPathForRow:path.row inSection:0];
                                                [block_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationFade];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                NSLog(@"Action 3 Handler Called");
                                            }]];
    UIViewController *viewController = [self findViewController:self];
    [viewController presentViewController:alert animated:YES completion:nil];
}

-(void)pressedCellImage:(NSNotification *)notification
{
    __block OBDTableView *tmp = self;
    __block UITableView *block_tableView = tableView;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *action) {
                                                NSDictionary *dic = [notification userInfo];
                                                NSNumber *number = [dic objectForKey:@"number"];
                                                UITableViewCell *cell = [dic objectForKey:@"cell"];
                                                NSIndexPath *path = [block_tableView indexPathForCell:cell];
                                                NSInteger n = [number integerValue];
                                                OBDData *data = [tmp.list objectAtIndex:path.row];
                                                [data.imageArray removeObjectAtIndex:n];
                                                NSIndexPath *te=[NSIndexPath indexPathForRow:path.row inSection:0];
                                                [block_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationFade];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                NSLog(@"Action 3 Handler Called");
                                            }]];
    UIViewController *viewController = [self findViewController:self];
    [viewController presentViewController:alert animated:YES completion:nil];
}

- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target)
    {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]])
        {
            break;
        }
    }
    return target;
}

#pragma mark -
#pragma mark UIImagePickerController Methods
-(void)openPhotoMenu
{
    __block OBDTableView *tmp = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开照相机"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [tmp takePhoto];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册获取"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [tmp LocalPhoto];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                NSLog(@"Action 3 Handler Called");
                                            }]];
    UIViewController *viewController = [self findViewController:self];
    [viewController presentViewController:alert animated:YES completion:nil];
    
}

//打开相机开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
//        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        UIViewController *viewController = [self findViewController:self];
        [viewController presentModalViewController:picker animated:YES];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
//    picker.allowsEditing = YES;
     UIViewController *viewController = [self findViewController:self];
    [viewController presentModalViewController:picker animated:YES];
}

//选中相片回调
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        OBDData *data = [_list objectAtIndex:pessRow];
        [data.imageArray addObject:image];
        [tableView reloadData];
    }
    [picker dismissModalViewControllerAnimated:YES];
}


@end


@implementation OBDData

- (id)initWithTitle:(NSString*)title time:(NSString*)time content:(NSString*)content image:(NSMutableArray *)imageArray
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
        if(time != nil)_time = [[NSString alloc]initWithString:time];
    }
    return self;
}

@end
