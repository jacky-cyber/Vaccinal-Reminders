//
//  RMDSetReminderViewController
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-25.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDSetReminderViewController.h"
#import "appConfigs.h"
#import "RMDReminderCenter.h"


@interface RMDSetReminderViewController ()
@property(nonatomic)NSArray *list;
@property(nonatomic)RMDReminderSetting currentSetting;
@property(nonatomic)NSIndexPath* selectedIndexPath;
@end

@implementation RMDSetReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.list = @[@"当天",@"当天,一周前",@"当天,一周前,半月前",@"None"];
        
        self.currentSetting = [[NSUserDefaults standardUserDefaults]integerForKey:REMINDER_SETTING];
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.tableView.tintColor = THEME_GREEN_COLOR;
    
    self.tableView.scrollEnabled = NO;
    
    self.tableView.userInteractionEnabled = NO;
    
    
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 64)];

    titleView.textColor = [UIColor colorWithRed:0.087 green:0.676 blue:0.542 alpha:1.000];
    
    titleView.text = @"推送设置";
    titleView.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleView;
    
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editReminderSetting)];
    
    [self.navigationItem setRightBarButtonItem:edit animated:YES];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ----
#pragma mark table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  @"时间设置";

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingcell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingcell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.list[indexPath.row];

    if (indexPath.row == self.currentSetting) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedIndexPath.row) {
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
    
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.selectedIndexPath = indexPath;
    
}

#pragma mark ---- 
#pragma  mark private function


//初始话相关参数
-(void)editReminderSetting
{
    self.tableView.userInteractionEnabled = YES;
    
    self.tableView.tintColor = THEME_RED_COLOR;
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:self.currentSetting inSection:0];
    
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSetting)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submitSetting)];
    
    ((UILabel *)self.navigationItem.titleView).text = @"修改";
    
    [self.navigationItem setLeftBarButtonItem:cancel animated:YES];
    [self.navigationItem setRightBarButtonItem:done  animated:YES];
    
}

//不做数据的修改，重新显示初始状态
-(void)cancelSetting
{
    self.navigationItem.leftBarButtonItem = nil;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editReminderSetting)];
    
    self.navigationItem.rightBarButtonItem = edit;
    
    ((UILabel *)self.navigationItem.titleView).text = @"推送设置";
    
    self.tableView.tintColor = THEME_GREEN_COLOR;
    
    self.tableView.userInteractionEnabled = NO;
    
    [self.tableView reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popSettingView) userInfo:nil repeats:NO];
}

-(void)popSettingView
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交修改
-(void)submitSetting
{
    if (self.currentSetting != self.selectedIndexPath.row) {
        
        self.currentSetting = self.selectedIndexPath.row;
        
        [[NSUserDefaults standardUserDefaults]setInteger:self.currentSetting forKey:REMINDER_SETTING];
        
        [[RMDReminderCenter sharedCenter]updateCenterWithCompletion:nil];
        
    }
    
    [self cancelSetting];
}

@end
