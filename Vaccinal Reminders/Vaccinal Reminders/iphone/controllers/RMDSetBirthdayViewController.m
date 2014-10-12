//
//  RMDSetBirthdayViewController.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-25.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDSetBirthdayViewController.h"
#import "appConfigs.h"
#import "RMDVaccinalSchedule.h"

@interface RMDSetBirthdayViewController ()
@property(nonatomic)UIDatePicker *datePicker;
@property(nonatomic)NSDate *birthday;
@end

@implementation RMDSetBirthdayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:BIRTHDAY]) {
            self.birthday = [[NSUserDefaults standardUserDefaults]objectForKey:BIRTHDAY];
        }else{
            self.birthday = [NSDate date];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 64)];
    
    titleView.textColor = [UIColor colorWithRed:0.087 green:0.676 blue:0.542 alpha:1.000];
    
    titleView.text = @"生日设置";
    titleView.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleView;
    
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editTime)];
    
    self.navigationItem.rightBarButtonItem = edit;
    
    
    self.showTextField.text = [self getBirthdayString];
    
    self.showTextField.enabled = NO;
    
     self.showTextField.textColor = [UIColor darkGrayColor];
    
    self.showTextField.inputView = self.datePicker;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIDatePicker *)datePicker
{
    if (!_datePicker) {
     
        _datePicker = [[UIDatePicker alloc]init];
        self.datePicker.timeZone = [[NSCalendar currentCalendar]timeZone];
        self.datePicker.calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
        _datePicker.date = self.birthday;
    }
    return  _datePicker;

}

-(void)editTime
{
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChange)];
    
    [self.navigationItem setLeftBarButtonItem:cancel animated:YES];
    
    UIBarButtonItem *submit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submitChange)];
    
    [self.navigationItem setRightBarButtonItem:submit animated:YES];
    
    ((UILabel *)self.navigationItem.titleView).text = @"修改";

    self.showTextField.textColor = THEME_GREEN_COLOR;
    
    self.showTextField.enabled = YES;
    
    self.showTextField.inputView = self.datePicker;
    
    [self.showTextField becomeFirstResponder];

}

-(void)cancelChange
{
    
    [self.view endEditing:NO];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editTime)];
    
    [self.navigationItem setRightBarButtonItem:edit animated:YES];
    
    ((UILabel *)self.navigationItem.titleView).text = @"生日设置";
    
    
    self.showTextField.textColor =[UIColor darkGrayColor];
;
    
    self.showTextField.text = [self getBirthdayString];
    self.showTextField.enabled = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popSettingView) userInfo:nil repeats:NO];
    
}
-(void)popSettingView
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)submitChange
{
    if (![self isSameDay:self.birthday another:self.datePicker.date]) {
        
        
        self.birthday = self.datePicker.date;
        
        [[RMDVaccinalSchedule sharedSchedule]updateBirthday:self.birthday completion:Nil];
    }
    
    [self cancelChange];
}

-(NSString *)getBirthdayString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY年 MM月 dd日"];
    
    NSString *dateString = [formatter stringFromDate:self.birthday];
    
    return [NSString stringWithFormat:@"当前生日时间:  %@",dateString];
}

-(BOOL)isSameDay:(NSDate *)date1 another:(NSDate*)date2


{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    
    
    return [comp1 day] == [comp2 day] &&
    
    [comp1 month] == [comp2 month] &&
    
    [comp1 year]  == [comp2 year];
    
}
@end
