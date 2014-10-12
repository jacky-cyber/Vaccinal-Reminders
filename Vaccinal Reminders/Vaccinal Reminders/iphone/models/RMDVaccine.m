//
//  RMDVaccine.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-14.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDVaccine.h"

@implementation RMDVaccine
    
-(instancetype)initWithCode:(NSString *)code
{
        self = [super init];
        if (self) {
            
            _code = code;
            
        }
        return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _code = [aDecoder decodeObjectForKey:@"code"];
        _varieties = [aDecoder decodeObjectForKey:@"varieties"];
        _variety = [aDecoder decodeObjectForKey:@"variety"];
        _fullName = [aDecoder decodeObjectForKey:@"fullName"];
        _nameForShort = [aDecoder decodeObjectForKey:@"nameForShort"];
        _function = [aDecoder decodeObjectForKey:@"function"];
        _inoculatedObject = [aDecoder decodeObjectForKey:@"inoculatedObject"];
        _type = [aDecoder decodeObjectForKey:@"type"];
        _immunizationSchedule = [aDecoder decodeObjectForKey:@"immunizationSchedule"];
        _note = [aDecoder decodeObjectForKey:@"note"];
        _contraindications = [aDecoder decodeObjectForKey:@"contraindications"];
        _untowardReaction = [aDecoder decodeObjectForKey:@"untowardReaction"];
    }
    return  self;


}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.varieties forKey:@"varieties"];
    [aCoder encodeObject:self.variety forKey:@"variety"];
    [aCoder encodeObject:self.fullName forKey:@"fullName"];
    [aCoder encodeObject:self.nameForShort forKey:@"nameForShort"];
    [aCoder encodeObject:self.function forKey:@"function"];
    [aCoder encodeObject:self.inoculatedObject forKey:@"inoculatedObject"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.immunizationSchedule forKey:@"immunizationSchedule"];
    [aCoder encodeObject:self.note forKey:@"note"];
    [aCoder encodeObject:self.contraindications forKey:@"contraindications"];
    [aCoder encodeObject:self.untowardReaction forKey:@"untowardReaction"];

}





-(NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"fullname:%@,nameForShort:%@,default:%@,function:%@,inoculatedObject:%@,type:%@,immunizationSchedule:%@,note:%@,contraindications:%@,untowardRection:%@",self.fullName,self.nameForShort,self.variety,self.function,self.inoculatedObject,self.type,self.immunizationSchedule,self.note,self.contraindications,self.untowardReaction];
    return desc;
}
@end
