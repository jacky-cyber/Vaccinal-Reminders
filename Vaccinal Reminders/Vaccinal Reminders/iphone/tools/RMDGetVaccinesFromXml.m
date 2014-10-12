//
//  RMDGetVaccinationsFromXml.m
//  Reminder
//
//  Created by 张鹏 on 14-7-24.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//  

#import "RMDGetVaccinesFromXml.h"
#import "RMDVaccine.h"

@interface RMDGetVaccinesFromXml ()

@property(nonatomic)NSMutableDictionary *vaccines;
@property(nonatomic)RMDVaccine *currentVaccine;
@property(nonatomic)NSMutableDictionary *varieties;
@property(nonatomic)NSMutableString *varietyCode;
@property(nonatomic)NSMutableString *currentValue;

@end

@implementation RMDGetVaccinesFromXml
    
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
    
    if ([elementName isEqualToString:@"vaccines"]) {
        
        _vaccines = [[NSMutableDictionary alloc]initWithCapacity:0];
        
    }else if([elementName isEqualToString:@"varieties"]){
        
        _varieties = [[NSMutableDictionary alloc]initWithCapacity:0];
        _currentVaccine.variety = attributeDict[@"default"];
        
    }else if([elementName isEqualToString:@"variety"]){
        
        _varietyCode = attributeDict[@"code"];
        _currentValue = [[NSMutableString alloc]init];
        
        
    }else{
        
        _currentValue = [[NSMutableString alloc]init];
        
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
    if ([elementName isEqualToString:@"vaccines"]) {
        
        self.allVaccines = _vaccines;
        
    }else if([elementName isEqualToString:@"vaccine"]){
        
        _vaccines[_currentVaccine.code] = _currentVaccine;
    
    }else if ([elementName isEqualToString:@"code"]){
        
        _currentVaccine = [[RMDVaccine alloc]initWithCode:_currentValue];
        
    }else if ([elementName isEqualToString:@"nameForShort"]){
        
        _currentVaccine.nameForShort = _currentValue;
        
    }else if ([elementName isEqualToString:@"fullName"]){
        
        _currentVaccine.fullName = _currentValue;
        
    }else if ([elementName isEqualToString:@"varieties"]){
        
        _currentVaccine.varieties = _varieties;
        
    }else if ([elementName isEqualToString:@"variety"]){
        
        _varieties[_varietyCode] = _currentValue;
        
    }else if ([elementName isEqualToString:@"type"]){
        
        _currentVaccine.type = _currentValue;
        
    }else if ([elementName isEqualToString:@"function"]){
        
        _currentVaccine.function = _currentValue;
        
    }else if ([elementName isEqualToString:@"inoculatedObject"]){
        
        _currentVaccine.inoculatedObject = _currentValue;
        
    }else if ([elementName isEqualToString:@"immunizationSchedule"]){
        
        _currentVaccine.immunizationSchedule = _currentValue;
        
    }else if ([elementName isEqualToString:@"note"]){
        
        _currentVaccine.note = _currentValue;
        
    }else if ([elementName isEqualToString:@"contraindications"]){
        
        _currentVaccine.contraindications = _currentValue;
        
    }else if ([elementName isEqualToString:@"untowardReaction"]){
        
        _currentVaccine.untowardReaction = _currentValue;
        
    }else{
        
        NSLog(@"something was ignored when parsed vaccines.xml");
        
    }
    
    _currentValue = nil;
}
    
@end
