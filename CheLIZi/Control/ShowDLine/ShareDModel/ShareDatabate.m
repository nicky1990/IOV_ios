//
//  ShareDatabate.m
//  ShareD
//
//  Created by newman on 15-1-10.
//  Copyright (c) 2015年 XWK. All rights reserved.
//

#import "ShareDatabate.h"
#import "ShareDataSubclass.h"

@implementation ShareDatabate

static ShareDatabate *instance = nil;	//单例对象

- (id)init{
    self = [super init];
    if (self) {

    }
    return self;
}

+(id)ServiceInstance
{
    @synchronized(self)
    {
        if (nil==instance)
        {
            instance = [[ShareDatabate alloc] init];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (void)saveTheArray:(NSArray *)array forDate:(NSDate*)date
{
    //保存文件名字
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];

    NSMutableArray *saveArray = [[NSMutableArray alloc]init];
    for(id data in array)
    {
        if([data respondsToSelector:@selector(convertDictionary)])
        {
            NSDictionary *saveData = [data performSelector:@selector(convertDictionary)];
            [saveArray addObject:saveData];
        }
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:dateString];
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:saveArray forKey:@"OBData"];//
    [archiver finishEncoding];//此方法调用，则将数据存入data
    
    if([data writeToFile:path atomically:NO])
    {
        NSLog(@"对象存入文件成功");
    }
}

- (NSArray *)readTheArrayForeDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:dateString];
    NSData *readData = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver2 =[[NSKeyedUnarchiver alloc] initForReadingWithData:readData];
    NSMutableArray *readArray = [unarchiver2 decodeObjectForKey:@"OBData"];
    
    NSMutableArray *sendArray = [[NSMutableArray alloc]init];
    
    for (id data in readArray)
    {
        NSLog(@"dd %@",data);
        OBDData *obdData = [[OBDData alloc]initWithTitle:@"空" time:[NSDate dateWithTimeIntervalSince1970:1421067605.677299] content:@"空" image:nil];
        [obdData reflectDataFromOtherObject:data];
        [sendArray addObject:obdData];
    }
    return sendArray;
}



- (NSArray *)readTheArrayForeDate:(NSDate*)date FromNetworkDataArray:(NSArray *)networkArray
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:dateString];
    NSData *readData = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver2 =[[NSKeyedUnarchiver alloc] initForReadingWithData:readData];
    NSMutableArray *readArray = [unarchiver2 decodeObjectForKey:@"OBData"];
    NSMutableArray *sendArray = [[NSMutableArray alloc]init];
    
    for(NSDictionary *data in networkArray)
    {
        NSString *address = [data objectForKey:@"address"];
        NSNumber *trace_time = [data objectForKey:@"trace_time"];
        float time = 1.0 * [trace_time longLongValue];
        OBDData *obdData = [[OBDData alloc]initWithTitle:address time:[NSDate dateWithTimeIntervalSince1970:time] content:@"" image:nil];

        for(NSDictionary *readData in readArray)
        {
            NSDate *read_date = [readData objectForKey:@"date"];
            NSLog(@"dfd %f",[read_date timeIntervalSince1970]);
            if(ABS([obdData.date timeIntervalSince1970] - [read_date timeIntervalSince1970])<60)
            {
                [obdData reflectDataFromOtherObject:readData];
                obdData.title = address;
                [readArray removeObject:readData];
                break;
            }
        }
        [sendArray addObject:obdData];
    }
    return sendArray;
}


@end
