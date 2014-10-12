//
//  RMDVaccineStore.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-14.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDVaccineStore.h"
#import "RMDGetVaccinesFromXml.h"

@interface RMDVaccineStore ()

@property(nonatomic)NSDictionary *allVaccines;          //所有疫苗资料
@property(nonatomic)NSMutableDictionary *privateVaccines;
    
@end

@implementation RMDVaccineStore

+(instancetype)sharedStore{
    
    static RMDVaccineStore *store = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        store = [[RMDVaccineStore alloc]initPrivate];
        
    });
    
    
    return store;

}
    
-(instancetype)initPrivate{
    
    self = [super init];
    if (self) {
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"savedVaccines"]) {
            
            // deEncode
            NSString *path = [self archivePath];
            _privateVaccines = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            
            if (_privateVaccines) {
                NSLog(@"successed to read vaccinations from .archiver file ");
            }
            
        }else{
            
            _privateVaccines = [NSMutableDictionary dictionaryWithDictionary:self.allVaccines];
            
        }
    }
    
    return self;
}
    
-(instancetype)init{

    @throw [[NSException alloc]initWithName:@"singlon" reason:@"please use sharedVaccineStore" userInfo:nil];

    return nil;
}

-(NSDictionary *)allVaccines
{
    if (!_allVaccines) {
        
        RMDGetVaccinesFromXml *getVaccinesFromXml = [[RMDGetVaccinesFromXml alloc]initWithXmlName:@"vaccines"];
        
        _allVaccines = getVaccinesFromXml.allVaccines;
        
        if (_allVaccines) {
            NSLog(@"successed to get vaccines from xml");
        }else{
            NSLog(@"failed to get vaccines from xml");
        }
    }
    
    return  _allVaccines;


}
-(NSDictionary *)myVaccines
{
    return _privateVaccines;
}

-(BOOL)saveMe
{
    NSString *path = [self archivePath];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:_privateVaccines toFile:path];
    
    if (success) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"savedVaccines"];
    }
    
    return success;
}

-(NSString *)archivePath
{
    
    NSArray *directions = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentPath = [directions firstObject];
    
    NSString *Path = [documentPath stringByAppendingPathComponent:@"vaccines.archive"];
    
    return Path;
    
}
@end
