//
//  RMDReminder.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-14.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDReminder.h"
#import "appConfigs.h"
#import "RMDVaccinalSchedule.h"
#import "RMDInoculation.h"

@implementation RMDReminder

-(instancetype)initWithInocKey:(NSString *)inocKey
{
    self = [super init];
    if (self) {
        
        _inocKey = inocKey;
        
        [self initReminder];
    
    }
    return self;
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        _inocKey = [aDecoder decodeObjectForKey:@"inocKey"];
        
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.inocKey forKey:@"inocKey"];

}



-(void)initReminder
{
    RMDReminderSetting setting = (int)[[NSUserDefaults standardUserDefaults]integerForKey:REMINDER_SETTING];
    /*
     
     设置通知的接种的条件：
     
     1 今天或者以后的
     
     */
    if (self.inoculation.whenToInject != RMDTimeDescPast) {
        switch (setting) {
            case RMDReminderSettingDayAndWeekAndHalfMonth:
            {
            
                
            }
            case RMDReminderSettingDayAndWeek:
            {
            
                
            }
            case RMDReminderSettingDay:
            {
                
                NSTimeZone *gmt = [[NSCalendar currentCalendar]timeZone];
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
                [gregorian setTimeZone:gmt];
                
                NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: self.inoculation.date];
                [components setHour: notificationHour];
                [components setMinute:notificationMins];
                [components setSecond: 0];
                NSDate *zeroThatDay = [gregorian dateFromComponents: components];
                
                
                NSString *message = [NSString stringWithFormat:@"%@可以接种了",self.inoculation.vaccine.nameForShort];
                [self scheduleLoaclNotificationWithTime:zeroThatDay ForMessage:message];
            }
                break;
            case RMDReminderSettingNone:
            default:
                break;
        }
    }
    
}
-(void)scheduleLoaclNotificationWithTime:(NSDate *)date ForMessage:(NSString *)message
{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    notification.fireDate = date;
    
    
    notification.timeZone = [[NSCalendar currentCalendar] timeZone];
    
    notification.alertBody = NSLocalizedString(message, nil);
    
    notification.hasAction = YES;
    notification.alertAction = NSLocalizedString(@"查看详情", nil);
    
    notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
    notification.userInfo = @{ @"key": self.inocKey };
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    
}

-(RMDInoculation *)inoculation
{
    if (!_inoculation) {
        _inoculation = [[RMDVaccinalSchedule sharedSchedule]inoculationForKey:self.inocKey];
    }
    return _inoculation;
}

-(void)dealloc
{
    
    

}
@end
