//
//  RMDMainViewController.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-8-25.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDTestViewController.h"
#import "RMDVaccine.h"
#import "RMDInoculation.h"
#import "RMDVaccinalSchedule.h"
#import "RMDRootViewController.h"

@interface RMDTestViewController ()

@property(nonatomic)RMDVaccinalSchedule *vaccinalSchedule;

@end

@implementation RMDTestViewController


-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        _vaccinalSchedule = [RMDVaccinalSchedule sharedSchedule];
        
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        UIBarButtonItem *setting = [[UIBarButtonItem alloc]initWithTitle:@"setting" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
        
        self.navigationItem.leftBarButtonItem = setting;
    }
    return  self;
}

#pragma mark ----
#pragma table view data source  and delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_vaccinalSchedule.vaccines count];
    }
    return [_vaccinalSchedule.schedule count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"vaccine"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"vaccine"];
            
            
        }
        //vaccine
        RMDVaccine *vaccine = _vaccinalSchedule.vaccines[indexPath.row];
        
        NSMutableString *showStr = [[NSMutableString alloc]init];
        
        [showStr appendString:[NSString stringWithFormat:@"%@(%@)",vaccine.nameForShort,vaccine.code ]];
        
        ;

        if (vaccine.varieties) {
            [showStr appendString: [NSString stringWithFormat:@"(%@)",vaccine.varieties[vaccine.variety]]];
        }
        
        cell.textLabel.text = showStr;
        cell.detailTextLabel.text = vaccine.description;
        
        cell.detailTextLabel.numberOfLines = 10;
        
        return cell;
        
    }else{
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"inoculation"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"inoculation"];
            
        }
        
        RMDInoculation *inoculation = _vaccinalSchedule.schedule[indexPath.row];
        
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@,%@",inoculation.vaccine.nameForShort,inoculation.stringOfDateDesc];
        
        cell.detailTextLabel.text = [inoculation description];
        
        cell.detailTextLabel.numberOfLines = 5;
        
        return cell;
    
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(void)setting
{
    [((RMDRootViewController *)self.navigationController.parentViewController)showBackView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
