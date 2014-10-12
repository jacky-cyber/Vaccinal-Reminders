//
//  RMDinoculatioin.h
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-14.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMDVaccine.h"
#import "appConfigs.h"
@class RMDReminder;


@interface RMDInoculation : NSObject<NSCoding>


@property(nonatomic,readonly,copy)NSString *key;            //唯一key
@property (nonatomic,copy,readonly)NSString *code;            //接种code = vaccine.code + variety
@property (nonatomic)NSInteger startAge;       //接种最小年龄，单位：月
@property (nonatomic)NSInteger count;          //剂次
@property (nonatomic)NSInteger type;          //免疫类型
@property (nonatomic,copy)NSString *note;            //注意事项
@property(nonatomic)BOOL isInjected;                //是否接种
@property (nonatomic,readonly)RMDInoculationState state;   //接种状态


@property (nonatomic,weak)RMDVaccine *vaccine; //疫苗信息
@property (nonatomic)NSDate *date;              //注射日期  RMDVaccinalSchedule 统一设置
@property(nonatomic,readonly)RMDTimeDesc whenToInject;

@property (nonatomic)RMDReminder *reminder;     //相关的提醒
@property (nonatomic,copy)NSString *other;        //待扩展

-(instancetype)initWithCode:(NSString *)code;

-(NSString *)stringOfDateDesc;

-(NSString *)description;

@end
