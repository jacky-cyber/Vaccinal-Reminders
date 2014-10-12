//
//  RMDReminderCenter.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-18.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDReminderCenter.h"
#import "RMDInoculation.h"
#import "RMDVaccinalSchedule.h"

@interface RMDReminderCenter()

@property(nonatomic)RMDVaccinalSchedule *vaccinalSchedule;

@end


@implementation RMDReminderCenter

+(instancetype)sharedCenter
{
    static RMDReminderCenter *center = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        center = [[self alloc]initPrivate];
    });
    return center;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
        //根据schedule 设置本地推送提醒
        RMDVaccinalSchedule *schedule = [RMDVaccinalSchedule sharedSchedule];
        
        
        if (!schedule.birthday) {
            NSLog(@"birthday is not setting ,init reminderCenter failed");
            return nil;
        }
        
        [[UIApplication sharedApplication]cancelAllLocalNotifications];
        
        for (RMDInoculation *inoculation in schedule.schedule) {
            
            [self createReminderWithInoc:inoculation];
            
        }
        
    }
    return  self;
}


-(instancetype)init{
    
    @throw [[NSException alloc]initWithName:@"singlon" reason:@"please use sharedCenter" userInfo:nil];
    
    return nil;
}

-(void)createReminderWithInoc:(RMDInoculation *)inoculation
{
    RMDReminderSetting setting = (int)[[NSUserDefaults standardUserDefaults]integerForKey:REMINDER_SETTING];
    
    
    if (inoculation.whenToInject != RMDTimeDescPast) {
        switch (setting) {
            case RMDReminderSettingDayAndWeekAndHalfMonth:
            {
                
                NSTimeInterval halffMonthAgoSecond = -15*24*60*60;
                
                NSDate *halfMonthAgo = [inoculation.date dateByAddingTimeInterval:halffMonthAgoSecond];
                
                
               if( [self compareNowWithDate:halfMonthAgo]!= RMDTimeDescPast)
               {
               
                   NSString *message = [NSString stringWithFormat:@"半个月后%@可以接种了",inoculation.vaccine.nameForShort];
                   NSDictionary *userInfo = @{@"key":inoculation.key};
                   
                   [self scheduleLoaclNotificationWithTime:halfMonthAgo ForMessage:message userInfo:userInfo];
               
               }
                
            }
            case RMDReminderSettingDayAndWeek:
            {
                NSTimeInterval weekAgoSecond = -7*24*60*60;
                
                NSDate *weekAgo = [inoculation.date dateByAddingTimeInterval:weekAgoSecond];
                
                if( [self compareNowWithDate:weekAgo]!= RMDTimeDescPast)
                {
                    NSString *message = [NSString stringWithFormat:@"一周后%@可以接种了",inoculation.vaccine.nameForShort];
                    NSDictionary *userInfo = @{@"key":inoculation.key};
                    
                    [self scheduleLoaclNotificationWithTime:weekAgo ForMessage:message userInfo:userInfo];
                }
                
            }
            case RMDReminderSettingDay:
            {
                NSString *message = [NSString stringWithFormat:@"%@可以接种了",inoculation.vaccine.nameForShort];
                NSDictionary *userInfo = @{@"key":inoculation.key};
                
                [self scheduleLoaclNotificationWithTime:inoculation.date ForMessage:message userInfo:userInfo];
            }
                break;
            case RMDReminderSettingNone:
            default:
                break;
        }
    }

}


-(void)updateCenterWithCompletion:(void (^)(void))completion
{
    //删掉所有
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    //根据schedule 设置本地推送提醒
    RMDVaccinalSchedule *schedule = [RMDVaccinalSchedule sharedSchedule];
    
    for (RMDInoculation *inoculation in schedule.schedule) {
        
        [self createReminderWithInoc:inoculation];
        
    }
    
    if (completion != nil) {
        completion();
    }
    
}

-(void)endRemindWithInoc:(RMDInoculation *)inoculation
{
    //遍历整个localNotifacation
    
    
    NSArray *notices = [[UIApplication sharedApplication]scheduledLocalNotifications];
    
    NSMutableArray *cancelArray = [[NSMutableArray alloc]initWithCapacity:0];;
    
    for (UILocalNotification *notice in notices) {
        
        NSString *key = ((UILocalNotification *)notice).userInfo[@"key"];
        
        if ([key isEqualToString:inoculation.key]) {
            
            [cancelArray addObject:notice];
        }
    }
    
    for (UILocalNotification *notice in cancelArray) {
        [[UIApplication sharedApplication]cancelLocalNotification:notice];
    }
    
    
}

-(void)scheduleLoaclNotificationWithTime:(NSDate *)date ForMessage:(NSString *)message userInfo:(NSDictionary *)userInfo
{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    
    //设置提醒时间
    NSCalendar *GregorianCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *gmt = [[NSCalendar currentCalendar]timeZone];
    [GregorianCalendar setTimeZone:gmt];
    
    NSDateComponents *components = [GregorianCalendar components: NSUIntegerMax fromDate: date];
    [components setHour: notificationHour];
    [components setMinute:notificationMins];
    
    NSDate *dateOfNotification = [GregorianCalendar dateFromComponents: components];
    
    
    notification.fireDate = dateOfNotification;
    
    
    notification.timeZone = [[NSCalendar currentCalendar] timeZone];
    
    notification.alertBody = NSLocalizedString(message, nil);
    
    notification.hasAction = YES;
    notification.alertAction = NSLocalizedString(@"查看详情", nil);
    
    
    notification.applicationIconBadgeNumber = 1 ;
    
    for (UILocalNotification *notice in [UIApplication sharedApplication].scheduledLocalNotifications) {
        if ([notice.fireDate compare:dateOfNotification]==NSOrderedSame) {
            notification.applicationIconBadgeNumber = notification.applicationIconBadgeNumber + 1;
        }
    }
    
    notification.userInfo = userInfo;
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
}


/*
 接种时间与现在比较
 
 return 过去，今天，以后
 
 */
-(RMDTimeDesc)compareNowWithDate:(NSDate *)date
{
    NSDate *now = [NSDate date];
    
    NSComparisonResult result= [now compare:date];
    
    NSTimeInterval interval= [date timeIntervalSinceNow];
    
    if (result == NSOrderedAscending) {
        
        return RMDTimeDescFuture;
        
    }else if(result == NSOrderedSame){
        
        return RMDTimeDescToday;
        
    }else{
        
        if (fabs(interval) <= 24 * 30 * 30) {
            return RMDTimeDescToday;
        }else
            return RMDTimeDescPast;
    }
}


-(void)printAllLocalNotification
{
    NSArray *array = [[UIApplication sharedApplication]scheduledLocalNotifications];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar]];
    
    [formatter setTimeZone:[[NSCalendar currentCalendar]timeZone]];
    
    [formatter setDateFormat:@"YYYY年 MM月 dd日 HH "];
    
    NSLog(@"birthday:%@",[formatter stringFromDate:[[RMDVaccinalSchedule sharedSchedule]birthday] ]);
    
    for (UILocalNotification *notice in array) {
        
        RMDInoculation *inoc = [[RMDVaccinalSchedule sharedSchedule]inoculationForKey:notice.userInfo[@"key"]];
        
        
        NSLog(@"%@ %@",[formatter stringFromDate:notice.fireDate],inoc.vaccine.nameForShort);
    }
    
    
}
@end
