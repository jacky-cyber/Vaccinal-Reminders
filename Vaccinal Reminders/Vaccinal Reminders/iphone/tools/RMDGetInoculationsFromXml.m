//
//  RMDGetInjectionsFromXml.m
//  Reminder
//
//  Created by 张鹏 on 14-7-24.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDGetInoculationsFromXml.h"
#import "RMDInoculation.h"

@interface RMDGetInoculationsFromXml ()

    @property(nonatomic)NSMutableDictionary *inoculations;
    @property(nonatomic)RMDInoculation *currentInoculation;
    @property(nonatomic)NSMutableString *currentValue;

@end


@implementation RMDGetInoculationsFromXml

-(instancetype)initWithXmlName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:name withExtension:@"xml"];
        
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url ];
        
        parser.delegate = self;
        
        [parser parse];

    }

    return self;
}
    

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"inoculations"]) {
        
        _inoculations = [[NSMutableDictionary alloc]initWithCapacity:0];
        
    }else{
            _currentValue = [[NSMutableString alloc]initWithCapacity:0];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_currentValue) {
        [_currentValue appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"inoculations"]) {
        
        self.allInoculations = _inoculations;

    }else if ([elementName isEqualToString:@"inoculation"]){
        
        if (_inoculations[_currentInoculation.code]) {
            NSMutableArray *inoculations = _inoculations[_currentInoculation.code];
            [inoculations addObject:_currentInoculation];
        }else{
            NSMutableArray *inoculations = [[NSMutableArray alloc]initWithCapacity:0];
            _inoculations[_currentInoculation.code] = inoculations;
            [inoculations addObject:_currentInoculation];
        }
        
        
    }else if ([elementName isEqualToString:@"code"]){
        
        _currentInoculation = [[RMDInoculation alloc]initWithCode:_currentValue];
        
    }else if ([elementName isEqualToString:@"count"]){
        
        NSUInteger count = [_currentValue integerValue];
        _currentInoculation.count = count;
        
    }else if ([elementName isEqualToString:@"startAge"]){
        
        NSUInteger startAge = [_currentValue integerValue];
        _currentInoculation.startAge = startAge;
        
    }else if ([elementName isEqualToString:@"type"]){
        
        NSUInteger type = [_currentValue integerValue];
        _currentInoculation.type = type;
        
    }else if ([elementName isEqualToString:@"note"]){
        
        _currentInoculation.note = _currentValue;
        
    }else{
        
        NSLog(@"ignored something when parsed inoculations.xml");
        
    }
    
    _currentValue = nil;
    
}

@end
