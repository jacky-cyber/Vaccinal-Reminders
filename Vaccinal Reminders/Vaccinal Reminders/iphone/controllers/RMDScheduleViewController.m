//
//  RMDScheduleViewController
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-22.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDScheduleViewController.h"
#import "RMDTestViewController.h"
#import "RMDVaccine.h"
#import "RMDInoculation.h"
#import "RMDVaccinalSchedule.h"
#import "RMDRootViewController.h"
#import "RMDInoculationCell.h"
#import "RMDReminderCenter.h"
#import "RMDDetailedViewController.h"


@interface RMDScheduleViewController ()

@property(nonatomic)RMDVaccinalSchedule *schedule;

@property(nonatomic)CGPoint touchPoint;      //详细页面从哪里弹出
@end

@implementation RMDScheduleViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    
        self.schedule = [RMDVaccinalSchedule sharedSchedule];
        
        CGRect screen = [[UIScreen mainScreen]bounds];
        
        self.touchPoint = CGPointMake(screen.size.width/2,screen.size.height/2);
        }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"list"] style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    
    self.navigationItem.leftBarButtonItem = setting;
    
    
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 64)];
    
    titleView.textColor = [UIColor colorWithRed:0.087 green:0.676 blue:0.542 alpha:1.000];
    
    titleView.text = @"免疫程序表";
    titleView.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleView;

    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RMDInoculationCell" bundle:nil] forCellReuseIdentifier:@"inoculationCell"];
    
    //监听inoculation是否被更改
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"inoc_change" object:nil];
    
    //监听是否有通知过来
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveLocalNotification:) name:@"new_local_notif" object:nil];
    
    
    //加点击手势，获取点击点
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    
    singleTapGR.cancelsTouchesInView = NO;
    
    singleTapGR.numberOfTapsRequired = 1;
    singleTapGR.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:singleTapGR];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated
{
    //用户是否同意使用推送，同意则初始化 推送信息
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[RMDReminderCenter sharedCenter]printAllLocalNotification];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)handleSingleTap:(UITapGestureRecognizer *)tapGR
{
    self.touchPoint = [tapGR locationInView:self.view];
    
    NSLog(@"one tap");
}

-(void)setting
{
    [self.rootVC showBackView];
}

-(void)refresh
{
    [self.tableView reloadData];
}

-(void)receiveLocalNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSString *inocKey = userInfo[@"key"];
    
    RMDInoculation *inoc = [self.schedule inoculationForKey:inocKey];
    
    [self showDetailForInoc:inoc];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    
    return [self.schedule.schedule count];
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"inoculationCell";
    RMDInoculationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    RMDInoculation *inoculation = self.schedule.schedule[indexPath.row];
    
    
    //不重复显示时间
    if (indexPath.row > 0 ) {
        RMDInoculation *lastInoc = self.schedule.schedule[indexPath.row - 1];
        if (lastInoc.startAge != inoculation.startAge) {
            cell.dateLabel.text = [inoculation stringOfDateDesc];
        }else{
            cell.dateLabel.text = @"";
        }
    }else{
        cell.dateLabel.text = [inoculation stringOfDateDesc];
    }
    
    
    cell.state = inoculation.state;
    
    
    //设置选中时效果
    cell.vaccineLabel.highlightedTextColor = THEME_GREEN_COLOR;
    cell.detailedLabel.highlightedTextColor = THEME_GREEN_COLOR;
    UIView *backgroundView = [[UIView alloc]initWithFrame:cell.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = backgroundView;
    
    
    
    NSMutableString *showStr = [[NSMutableString alloc]init];
    
    [showStr appendString: inoculation.vaccine.nameForShort];
    
    if (inoculation.vaccine.varieties) {
        [showStr appendString: [NSString stringWithFormat:@"(%@)",inoculation.vaccine.varieties[inoculation.vaccine.variety]]];
    }
    
    cell.vaccineLabel.text = showStr;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // RMDInoculationCell *cell = (RMDInoculationCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //判断点击的位置 进行相应处理
    if (self.touchPoint.x > 60) {
        
        RMDInoculation *inoc = self.schedule.schedule[indexPath.row];
        
        [self showDetailForInoc:inoc];
        
    }else{
        
        
    
    }
    
}

-(void)showDetailForInoc:(RMDInoculation *)inoc
{
    
    
    //阻止一瞬间的多次选定，动画完成时再重新可enable
    self.view.userInteractionEnabled = NO;
    
    
    RMDDetailedViewController *detailViewController = [[RMDDetailedViewController alloc] initWithInoc:inoc];
    
    [self.rootVC addChildViewController:detailViewController];
    
    [self.rootVC.view addSubview:detailViewController.view];
    

    //detailViewController.view.center = self.touchPoint;
    
    CGRect screen = [[UIScreen mainScreen]bounds];
    
    detailViewController.view.layer.anchorPoint = CGPointMake(100/screen.size.width,self.touchPoint.y/screen.size.height);
    
    detailViewController.view.center = CGPointMake(100, self.touchPoint.y);
    
    
    detailViewController.view.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^(){
        
        
        detailViewController.view.transform = CGAffineTransformMakeScale(1, 1);
        
        //detailViewController.view.center = self.view.window.center;
        
        //detailViewController.view.layer.anchorPoint = self.touchPoint;
        
        
    } completion:^(BOOL finished){
        
        
        //将其变为可用
        
        self.view.userInteractionEnabled = YES;
    }];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
