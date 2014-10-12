//
//  RMDTranspBarNavigationController.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-22.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDTranspBarNavigationController.h"
#import "appConfigs.h"

@interface RMDTranspBarNavigationController ()

@end

@implementation RMDTranspBarNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //navigation bar 设置为透明
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //self.navigationBar.shadowImage = [UIImage new];
        self.navigationBar.translucent = YES;
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.alpha = 0.1;
        
        self.navigationBar.tintColor = THEME_GREEN_COLOR;
        
        
    }
    return self;
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
