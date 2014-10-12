//
//  RMDBirthdayViewController.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-18.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDBirthdayViewController.h"
#import "RMDTestViewController.h"
#import <QuartzCore/CAAnimation.h>
#import "appConfigs.h"
#import "RMDRootViewController.h"
#import "RMDSettingViewController.h"
#import "RMDScheduleViewController.h"
#import "RMDTranspBarNavigationController.h"
#import "RMDVaccinalSchedule.h"


@interface RMDBirthdayViewController ()

@property(nonatomic)NSDate *birthday;
@property(nonatomic)UIDatePicker *datePicker;


@end

@implementation RMDBirthdayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        self.birthday = [NSDate date];
        
        self.datePicker = [[UIDatePicker alloc]init];
        //时区设置为当前时区
        self.datePicker.timeZone = [[NSCalendar currentCalendar]timeZone];
        self.datePicker.calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.datePicker.date = self.birthday;
    
    self.datePicker.backgroundColor = [UIColor clearColor];
    
    self.dateInput.inputView = self.datePicker;
    
    
    self.dateInput.text = [self getDateString:self.birthday];
    
    self.getStartedBtn.hidden = YES;
    
}


-(NSString *)getDateString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar]];
    
    [formatter setTimeZone:[[NSCalendar currentCalendar]timeZone]];
    
    [formatter setDateFormat:@"YYYY年 MM月 dd日"];
    
    NSString *dateString = [formatter stringFromDate:self.birthday];

    return  dateString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)keyboardDown:(id)sender {
    
    if ([self.dateInput isFirstResponder]) {
        
        self.birthday = self.datePicker.date;
        
        self.dateInput.text = [self getDateString:self.birthday];
        
        self.stateLabel.text = @"! ";
        
        [self.view endEditing:YES];

        self.getStartedBtn.hidden = NO;
        
    }
}

- (IBAction)getStarted:(id)sender {
    
    
    //公历的当前时区时间
    NSTimeZone *gmt = [[NSCalendar currentCalendar]timeZone];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    [gregorian setTimeZone:gmt];
    
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: self.birthday];
    [components setHour: 0];
    [components setMinute:0];
    [components setSecond: 0];
    NSDate *zeroThatDay = [gregorian dateFromComponents: components];

    [RMDVaccinalSchedule setBirthday:zeroThatDay];
    
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            
        self.shadowView.alpha = 0.6;
        self.shadowView.hidden = NO;
        [self.activityInspecter startAnimating];
        
        
        } completion:^(BOOL success){
        
        [self start];
        
    }];
    
}

-(void)start
{
    
    RMDScheduleViewController *scheduleVC = [[RMDScheduleViewController alloc]init];
    
    RMDSettingViewController *setting = [[RMDSettingViewController alloc]init];
    
    RMDRootViewController *rootVC = [[RMDRootViewController alloc]initWithMainViewController:scheduleVC BackViewController:setting];
    
    [self presentViewController:rootVC animated:YES completion:^(){
        self.view.window.rootViewController = rootVC;
    }];
}
@end
