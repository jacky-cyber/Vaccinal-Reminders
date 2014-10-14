//
//  RMDSettingViewController.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-22.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDSettingViewController.h"
#import "RMDSetReminderViewController.h"
#import "appConfigs.h"
#import "RMDSetBirthdayViewController.h"
#import "RMDAboutUsViewController.h"

@interface RMDSettingViewController ()

@property(nonatomic)NSArray *list;
@property(nonatomic)NSIndexPath *selectedIndexPath;
@property(nonatomic)UIColor *selectedColor;
@property(nonatomic)UIColor *defaultColor;


@end

@implementation RMDSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.list = @[@"   提醒设置",@"   重置生日",@"   关于我们"];
        self.tableView.rowHeight = 60 ;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.selectedColor = [UIColor colorWithRed:0.087 green:0.676 blue:0.542 alpha:1.0];
        self.defaultColor = [UIColor whiteColor];
    }
return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---
#pragma mark tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setting_cell"];
    }
    
    UIFont *myFont = [UIFont systemFontOfSize:20];
    cell.textLabel.font = myFont;
    
    cell.textLabel.text = self.list[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textColor = self.defaultColor ;
    cell.textLabel.highlightedTextColor = THEME_GREEN_COLOR;
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:cell.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = backgroundView;
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {

        case notificationSetting:
        {
            RMDSetReminderViewController *setReminder = [[RMDSetReminderViewController alloc]init];
            [self.rootVC changeRightVC:setReminder];
            
        }
            break;
        case resetBirthday:
        {
            
            RMDSetBirthdayViewController *setBirthday = [[RMDSetBirthdayViewController alloc]init];
            [self.rootVC changeRightVC:setBirthday];
            
            
        }
            break;
        case aboutUs:
        {
            RMDAboutUsViewController *aboutUsVC = [[RMDAboutUsViewController alloc]init];
            
            [self.rootVC changeRightVC:aboutUsVC];

        }
            break;
        default:
            break;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
