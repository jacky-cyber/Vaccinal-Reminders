//
//  RMDBirthdayViewController.h
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-18.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMDBirthdayViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dateInput;
- (IBAction)keyboardDown:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *getStartedBtn;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInspecter;

@end
