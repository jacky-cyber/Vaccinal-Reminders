//
//  RMDAboutUsViewController.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-25.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDAboutUsViewController.h"

@interface RMDAboutUsViewController ()

@end

@implementation RMDAboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 64)];
    
    titleView.textColor = [UIColor colorWithRed:0.087 green:0.676 blue:0.542 alpha:1.000];
    
    titleView.text = @"关于我们";
    titleView.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleView;
    
    
    self.showTextView.textColor = [UIColor darkGrayColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
