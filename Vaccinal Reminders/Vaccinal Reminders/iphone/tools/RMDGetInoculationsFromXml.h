//
//  RMDGetInjectionsFromXml.h
//  Reminder
//
//  Created by 张鹏 on 14-7-24.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMDGetInoculationsFromXml : NSObject<NSXMLParserDelegate>

    
@property(nonatomic)NSMutableDictionary *allInoculations;   //key == inoculation_code value == [inoculation,...]

-(instancetype)initWithXmlName:(NSString *)name;

@end
