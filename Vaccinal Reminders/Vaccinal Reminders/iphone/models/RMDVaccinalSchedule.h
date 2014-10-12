//
//  RMDVaccinalSchedule.h
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-16.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMDVaccine.h"
#import "RMDInoculation.h"


@interface RMDVaccinalSchedule : NSObject

@property(nonatomic,readonly)NSArray *schedule;     //排序后的接种表
@property(nonatomic,readonly)NSArray *vaccines;     //接种的疫苗
@property(nonatomic,readonly)NSDate *birthday;      //维护 birthday


+(instancetype)sharedSchedule;

//管理生日的初始设定
+(void)setBirthday:(NSDate *)birthday;

//更新时间设定
-(void)updateBirthday:(NSDate *)birthday completion:(void (^)(void))completion;

-(NSDate *)dateOfinculation:(RMDInoculation *)inoculation;

-(RMDInoculation *)inoculationForKey:(NSString *)key;

-(BOOL)saveMe;



@end
