//
//  RMDReminder.h
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-14.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//





#import <Foundation/Foundation.h>
#import "RMDInoculation.h"
#import "appConfigs.h"

#import <EventKit/EKReminder.h>

@interface RMDReminder : NSObject<NSCoding>


@property(nonatomic,copy,readonly)NSString *inocKey;
@property(nonatomic,weak)RMDInoculation *inoculation;
//@property(nonatomic)NSDate *reminderDate;

//@property(nonatomic)NSNotification *localNotification;
//@property(nonatomic)EKReminder *reminder;  初版不做

//@property (nonatomic,readonly)RMDReminderState state;  //初版不用

-(instancetype)initWithInocKey:(NSString *)inocKey;

@end
