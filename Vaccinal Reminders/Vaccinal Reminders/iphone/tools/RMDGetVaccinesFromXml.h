//
//  RMDGetVaccinationsFromXml.h
//  Reminder
//
//  Created by 张鹏 on 14-7-24.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMDGetVaccinesFromXml : NSObject <NSXMLParserDelegate>

@property (nonatomic)NSMutableDictionary *allVaccines;     //key = vaccine.code  value = vaccine

-(instancetype)initWithXmlName:(NSString *)name;
    
@end
