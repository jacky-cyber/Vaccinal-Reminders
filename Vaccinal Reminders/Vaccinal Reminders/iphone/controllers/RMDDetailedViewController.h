//
//  RMDDetailedViewController.h
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-24.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDInoculation.h"

@interface RMDDetailedViewController : UIViewController<UIAlertViewDelegate>

-(instancetype)initWithInoc:(RMDInoculation *)inoculation;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISwitch *isInjected;
@property (weak, nonatomic) IBOutlet UILabel *showIsInjected;
- (IBAction)switchChange:(id)sender;

@end
