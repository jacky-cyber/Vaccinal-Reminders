//
//  RMDScheduleViewController
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-22.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDRootViewController.h"


@interface RMDScheduleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
