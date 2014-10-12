//
//  RMDinoculatioin.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-14.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDInoculation.h"

@interface RMDInoculation ()



@end


@implementation RMDInoculation
-(instancetype)initWithCode:(NSString *)code
{
    self = [super init];
    if (self) {
        
        _code = code;
        self.isInjected = false;
        NSUUID *uuid = [[NSUUID alloc]init];
        _key = [uuid UUIDString];
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        
        _code = [aDecoder decodeObjectForKey:@"code"];
        _date = [aDecoder decodeObjectForKey:@"date"];
        _note = [aDecoder decodeObjectForKey:@"note"];
        //_reminder = [aDecoder decodeObjectForKey:@"reminder"];
        _other = [aDecoder decodeObjectForKey:@"other"];
        
        _startAge = [aDecoder decodeIntegerForKey:@"startAge"];
        _count = [aDecoder decodeIntegerForKey:@"count"];
        _type = [aDecoder decodeIntegerForKey:@"type"];
        _isInjected = [aDecoder decodeBoolForKey:@"isInjected"];
        _key = [aDecoder decodeObjectForKey:@"key"];
        
        
        
    }
    
    return self;

}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.note forKey:@"note"];
    [aCoder encodeObject:self.other forKey:@"other"];
    //[aCoder encodeObject:self.reminder forKey:@"reminder"];
    [aCoder encodeInteger:self.startAge forKey:@"startAge"];
    [aCoder encodeInteger:self.count forKey:@"count"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeBool:self.isInjected forKey:@"isInjected"];
    

}

-(RMDVaccine *)vaccine
{
    if (!_vaccine) {
        
        RMDVaccineStore *store = [RMDVaccineStore sharedStore];
        NSString *vaccineCode = [_code substringWithRange:NSMakeRange(0, 2)];
        _vaccine =  store.myVaccines[vaccineCode];
    }
    return _vaccine;
}

/*
    接种时间与现在比较
    
    return 过去，今天，以后
 
 */
-(RMDTimeDesc)compareNowWithDate:(NSDate *)date
{
    NSDate *now = [NSDate date];
    
    NSComparisonResult result= [now compare:date];
    
    NSTimeInterval interval= [date timeIntervalSinceNow];
    
    if (result == NSOrderedAscending) {

            return RMDTimeDescFuture;
        
    }else if(result == NSOrderedSame){
        
        return RMDTimeDescToday;
        
    }else{
    
        if (fabs(interval) <= 24 * 60 * 60) {
            return RMDTimeDescToday;
        }else
            return RMDTimeDescPast;
    }
}
-(RMDTimeDesc)whenToInject
{
    
    return [self compareNowWithDate:self.date];

}

-(NSString *)stringOfDateDesc
{
    NSString *dateString ;
    
    if (self.date) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        dateString = [formatter stringFromDate:self.date];
        
    }else{
        dateString = [NSString stringWithFormat:@"%ld月龄",self.startAge];
    }
    
    return dateString;
}

-(NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"code:%@,startAge:%ld count:%ld,type:%ld,note:%@",self.code,(long)self.startAge,self.count,self.type,self.note];
    return  desc;
}

-(RMDInoculationState)state
{
    if (!self.date) {
        return RMDInoculationStateNone;
    }
    
    RMDTimeDesc timeDesc = self.whenToInject;
  
    if (timeDesc == RMDTimeDescPast) {
        
        if (self.isInjected) {
            return RMDInoculationStatePastOk;
        }else
            return RMDInoculationStatePastUn;
        
    }else if(timeDesc == RMDTimeDescToday){
        
        if (self.isInjected) {
            return RMDInoculationStateTodayOk;
        }else
            return RMDInoculationStateTodayUn;
        
    }else
        return RMDInoculationStateFutureUn;
}
@end
