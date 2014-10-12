//
//  RMDVaccineStore.h
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-14.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RMDVaccineStore : NSObject

//key == vaccine.code  value == vaccine
@property(nonatomic,strong)NSDictionary *myVaccines;
    
    +(instancetype)sharedStore;

    -(BOOL)saveMe;

@end
