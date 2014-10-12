//
//  RMDAppDelegate.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-14.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDAppDelegate.h"
#import "RMDTestViewController.h"
#import "RMDVaccinalSchedule.h"
#import "appConfigs.h"
#import "RMDBirthdayViewController.h"
#import "RMDSettingViewController.h"
#import "RMDRootViewController.h"
#import "RMDScheduleViewController.h"
#import "RMDTranspBarNavigationController.h"
#import "RMDReminderCenter.h"

@implementation RMDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //配置默认设置
    [self defaultSetting];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:BIRTHDAY]) {
        
        RMDScheduleViewController *scheduleVC = [[RMDScheduleViewController alloc]init];
        
        RMDSettingViewController *setting = [[RMDSettingViewController alloc]init];
        
        RMDRootViewController *rootVC = [[RMDRootViewController alloc]initWithMainViewController:scheduleVC BackViewController:setting];
        
        self.window.rootViewController = rootVC;
        
        //当有新的通知时
        if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        
            application.applicationIconBadgeNumber =  application.applicationIconBadgeNumber - 1;
            
            UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        
            [self resignActiveByLocalNotification:notification];
        }else
        {
            application.applicationIconBadgeNumber = 0;
        }
        
    }else{
        
        RMDBirthdayViewController *birthdayVC = [[RMDBirthdayViewController alloc]init];
        self.window.rootViewController = birthdayVC;
    
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:BIRTHDAY]) {
        
        [self saveAll];
    }
    
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

    NSLog(@"receive local notification");
    
    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1 ;
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"active");
        //通知程序表，有新的提醒
        [[NSNotificationCenter defaultCenter]postNotificationName:@"new_local_notif" object:self userInfo:notification.userInfo];
    }else{
        
        [self resignActiveByLocalNotification:notification];
    }
    
}

-(void)resignActiveByLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"resign");
    //通知程序表，有新的提醒
    [[NSNotificationCenter defaultCenter]postNotificationName:@"new_local_notif" object:self userInfo:notification.userInfo];
}
-(void)defaultSetting
{
    [[NSUserDefaults standardUserDefaults]setInteger:RMDReminderSettingDayAndWeek forKey:REMINDER_SETTING];
    
}

-(void)saveAll
{
    BOOL success = [[RMDVaccineStore sharedStore]saveMe] && [[RMDVaccinalSchedule sharedSchedule]saveMe];
    if (success) {
        NSLog(@"saved all successfuly");
    }else{
        NSLog(@"saved all failed");
    
    }

}

@end
