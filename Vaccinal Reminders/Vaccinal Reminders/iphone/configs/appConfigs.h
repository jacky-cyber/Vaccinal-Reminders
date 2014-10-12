//
//  appConfigs.h
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-18.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#ifndef Vaccinal_Reminders_appConfigs_h
#define Vaccinal_Reminders_appConfigs_h


#define BIRTHDAY @"birthday"


typedef enum {
    
    RMDInoculationStateNone = 0,
    RMDInoculationStatePastUn,
    RMDInoculationStatePastOk,
    RMDInoculationStateTodayUn,
    RMDInoculationStateTodayOk,
    RMDInoculationStateFutureUn
    
} RMDInoculationState;

typedef enum {
    RMDTimeDescPast = -1,
   // RMDTimeDescYesterday .
    RMDTimeDescToday,
 //   RMDTimeDescTmr = 1,
    RMDTimeDescFuture,
} RMDTimeDesc;


typedef enum {
    RMDReminderSettingDay = 0,
    RMDReminderSettingDayAndWeek,
    RMDReminderSettingDayAndWeekAndHalfMonth,
    RMDReminderSettingNone
} RMDReminderSetting;

#define REMINDER_SETTING @"ReminderSetting"

#define notificationSetting 0
#define resetBirthday 1
#define aboutUs 2


#define notificationHour 12
#define notificationMins 06



#define THEME_GREEN_COLOR  [UIColor colorWithRed:0.087 green:0.676 blue:0.542 alpha:1.000]
#define THEME_RED_COLOR [UIColor colorWithRed:0.987 green:0.252 blue:0.302 alpha:1.000]

#define THEME_YELLOW_COLOR [UIColor colorWithRed:0.993 green:0.650 blue:0.035 alpha:1.000]

#define THEME_GREY_COLOR  [UIColor colorWithWhite:0.873 alpha:1.000]


#define SCREEN_BOUNDS [[UIScreen mainScreen]bounds]


#import "RMDTranspBarNavigationController.h"

#endif


