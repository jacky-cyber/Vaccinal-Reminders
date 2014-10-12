//
//  RMDVaccinalSchedule.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-16.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDVaccinalSchedule.h"
#import "RMDVaccineStore.h"
#import "RMDGetInoculationsFromXml.h"
#import "RMDVaccine.h"
#import "RMDInoculation.h"
#import "RMDReminderCenter.h"


@interface RMDVaccinalSchedule ()

@property(nonatomic)RMDVaccineStore *vaccineStore;  //存放要打的疫苗 增删
@property(nonatomic)NSDictionary *allInoculations;   //获取所有接种信息，提供查询,仅在需要时初始化 code : array


@property(nonatomic)NSMutableArray *privateSchedule;    //排序后的接种列表

@end


@implementation RMDVaccinalSchedule


+(instancetype)sharedSchedule{
    
    static RMDVaccinalSchedule *Schedule = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Schedule = [[RMDVaccinalSchedule alloc]initPrivate];
        
    });
    
    
    return Schedule;
}

+(void)setBirthday:(NSDate *)birthday
{
    [[NSUserDefaults standardUserDefaults]setObject:birthday forKey:BIRTHDAY];
}

-(instancetype)initPrivate{
    
    self = [super init];
    if (self) {
        
        /*
         
         birthday 的维护机制： 
         RMDVaccinalSchedule 生成之前须设置好，若未设置，则所有接种时间的判断不能进行。
         
         */
        if (!self.birthday) {
            NSLog(@"RMDVaccialSchedule: birthday未设置，所以有关时间的信息以及提醒均未创建");
        }
        
        //初始化疫苗信息
        _vaccineStore = [RMDVaccineStore sharedStore];
        
        
        //初始化接种列表
        [self initSchedule];
    }
    
    return self;
}

-(instancetype)init{
    
    @throw [[NSException alloc]initWithName:@"singlon" reason:@"please use sharedSchedule" userInfo:nil];
    
    return nil;
}


//获取相关接种 并关联接种和疫苗,并排序
-(void)initSchedule
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"savedSchedule"]) {
        
        NSString *path = [self achiverPath];
        _privateSchedule = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (_privateSchedule) {
            
            NSLog(@"successed to read schedule from .archiver file ");
        }
        
    }else{
        
        _privateSchedule = [[NSMutableArray alloc]init];
        
        for (RMDVaccine *vaccine in [_vaccineStore.myVaccines allValues]) {
            
            [self createInoculationsWithVaccine:vaccine];
        }
        
        [self sortSchedule];
        
    }
    
    
}

-(NSDate *)birthday
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:BIRTHDAY];
    
}

-(NSArray *)createInoculationsWithVaccine:(RMDVaccine *)vaccine
{
    NSArray *inoculations = [self getInoculationsWithVaccine:vaccine];
    
    //配置 inoculation
    for (RMDInoculation *inoculation in inoculations) {
        
        inoculation.date = [self dateOfinculation:inoculation];

    }
    
    [_privateSchedule addObjectsFromArray:inoculations];
    
    return inoculations;

}

//排序方法
-(void)sortSchedule
{
    NSArray *unsortedSchedule = [NSArray arrayWithArray:_privateSchedule];
    unsortedSchedule = [unsortedSchedule sortedArrayUsingComparator:^NSComparisonResult(RMDInoculation *first,RMDInoculation *second) {
        
        NSComparisonResult result = first.startAge > second.startAge;
        return result;
    }];
    
    _privateSchedule = [NSMutableArray arrayWithArray:unsortedSchedule];
    
}

//获取某疫苗的免疫程序
-(NSArray *)getInoculationsWithVaccine:(RMDVaccine *)vaccine
{
    NSString *inoculationCode;
    NSArray *inoculations;
    
    if (!vaccine.varieties) {
        inoculationCode = vaccine.code;
    }else{
        inoculationCode = [NSString stringWithFormat:@"%@%@",vaccine.code,vaccine.variety];
    }
    
    inoculations = self.allInoculations[inoculationCode];
    
    return inoculations;
}


//获取具体注射日期
-(NSDate *)dateOfinculation:(RMDInoculation *)inoculation         //获取具体注射日期
{
    if(!self.birthday) {
        return nil;
    }
    
    NSDate *dateOfinculation;
    
    NSCalendar *GregorianCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
     NSTimeZone *gmt = [[NSCalendar currentCalendar]timeZone];
    [GregorianCalendar setTimeZone:gmt];
    
    NSDateComponents *birthdayCompnt = [[NSDateComponents alloc] init];
    
    [birthdayCompnt setMonth:inoculation.startAge];
    
    dateOfinculation = [GregorianCalendar dateByAddingComponents:birthdayCompnt toDate:self.birthday options:0];
    
    return dateOfinculation;
    
}


-(RMDInoculation *)inoculationForKey:(NSString *)key
{
    for (RMDInoculation *inoc in _privateSchedule) {
        if ([inoc.key isEqualToString:key]) {
            return inoc;
        }
    }
    return nil;

}

-(NSDictionary *)allInoculations
{
    if(!_allInoculations) {
        //设置接种全表
        RMDGetInoculationsFromXml *getInoculationsFromXml = [[RMDGetInoculationsFromXml alloc]initWithXmlName:@"inoculations"];
        
        _allInoculations = getInoculationsFromXml.allInoculations;
        
        
        if (_allInoculations) {
            
            NSLog(@"successed to get all inoculations from inoculations.xml ! ");
            
        }else{
            NSLog(@"failed to get all inoculations from inoculations.xml ! ");
            
        }
    }
    return _allInoculations;
}

-(NSArray *)vaccines
{
    return [_vaccineStore.myVaccines allValues];
}

-(NSArray *)schedule
{
    return _privateSchedule;
}


-(void)updateBirthday:(NSDate *)birthday completion:(void (^)(void))completion
{
    //更新生日
    [RMDVaccinalSchedule setBirthday:birthday];
    
    //重新更新时间
    
    for (RMDInoculation *inoculation in _privateSchedule) {
        
        inoculation.date = [self dateOfinculation:inoculation];
        
    }
    
    //重新设置提醒
    [[RMDReminderCenter sharedCenter]updateCenterWithCompletion:nil];
    
    //执行完回调
    if (completion != nil) {
        completion();
    }
    
}


-(BOOL)saveMe
{
    NSString *path = [self achiverPath];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:_privateSchedule toFile:path];
    
    if (success) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"savedSchedule"];
    }
    
    return success;
}


-(NSString *)achiverPath
{
    NSArray *directions = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentPath = [directions firstObject];
    
    NSString *Path = [documentPath stringByAppendingPathComponent:@"inoculations.archive"];
    
    return Path;
    
}
@end
