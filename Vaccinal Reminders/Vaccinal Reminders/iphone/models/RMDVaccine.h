//
//  RMDVaccine.h
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-14.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMDVaccineStore.h"

@interface RMDVaccine : NSObject<NSCoding>

@property (nonatomic,copy,readonly)NSString *code;
@property (nonatomic)NSDictionary *varieties;               //区分不同免疫类型的子类集 key = code value = nameString
@property (nonatomic,copy)NSString *variety;                //当前子类code


//文字性信息
@property (nonatomic,copy)NSString *fullName;               //全称
@property (nonatomic,copy)NSString *nameForShort;           //简称
@property (nonatomic,copy)NSString *function;               //功能，预防疾病
@property (nonatomic,copy)NSString *inoculatedObject;       //接种对象
@property (nonatomic,copy)NSString *type;                   //种类描述
@property (nonatomic,copy)NSString *immunizationSchedule;   //免疫程序
@property (nonatomic,copy)NSString *note;                   //注意事项
@property (nonatomic,copy)NSString *contraindications;      //禁忌
@property (nonatomic,copy)NSString *untowardReaction;      //不良反应



//-(instancetype)initWithStore:(RMDVaccineStore *)store;
-(instancetype)initWithCode:(NSString *)code;
-(NSString *)description;

@end
