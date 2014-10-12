//
//  RMDReminderCenter.h
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-18.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMDInoculation.h"


//管理所有的localNotifacation 进行管理

@interface RMDReminderCenter : NSObject



+(instancetype)sharedCenter;
-(void)updateCenterWithCompletion:(void(^)(void))completion;    //根据提醒的设定，更新所有提醒

-(void)createReminderWithInoc:(RMDInoculation *)inoculation;
-(void)endRemindWithInoc:(RMDInoculation *)inoculation;

//test
-(void)printAllLocalNotification;
@end
