//
//  RMDDetailedViewController.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-24.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDDetailedViewController.h"
#import "RMDRootViewController.h"
#import "JWBlurView.h"
#import "RMDReminderCenter.h"

@interface RMDDetailedViewController ()

@property(nonatomic)RMDInoculation *inoculation;

@property(nonatomic)BOOL isUpdate;

@property(nonatomic)UIColor *themeColor;

@end

@implementation RMDDetailedViewController

-(instancetype)initWithInoc:(RMDInoculation *)inoculation
{
    self = [super init];
    if (self) {
        
        _inoculation = inoculation;
        
        self.isUpdate = false;
        
        [self initTheme];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    RMDVaccine *vaccine = self.inoculation.vaccine;
    
    self.titleLabel.text = vaccine.nameForShort;
    
    self.textView.editable = NO;
    
    NSMutableString *showString = [[NSMutableString alloc]init];
    
    [showString appendString:[NSString stringWithFormat:@"疫苗名称：%@\n\n\n", vaccine.nameForShort]];
    
    [showString appendString:[NSString stringWithFormat:@"预防疾病：%@\n\n\n", vaccine.function]];
    
    [showString appendString:[NSString stringWithFormat:@"接种对象：%@\n\n\n", vaccine.inoculatedObject]];
    
    [showString appendString:[NSString stringWithFormat:@"免疫程序：%@\n\n\n", vaccine.immunizationSchedule]];
    
    
    [showString appendString:[NSString stringWithFormat:@"禁忌：%@\n\n\n", vaccine.contraindications]];
    
    [showString appendString:[NSString stringWithFormat:@"注意事项：%@\n\n\n", vaccine.note]];
    
    [showString appendString:[NSString stringWithFormat:@"不良反应：%@\n\n\n", vaccine.untowardReaction]];
    
    self.textView.text = showString;
    
    RMDInoculationState state = self.inoculation.state;
    
    if (state == RMDInoculationStateNone || state == RMDInoculationStateFutureUn) {
        self.isInjected.hidden = YES;
        self.showIsInjected.text = [NSString stringWithFormat:@"%@ 开始接种",[self.inoculation stringOfDateDesc] ];
    }else if(state == RMDInoculationStatePastOk || state == RMDInoculationStateTodayOk){
        self.isInjected.on = YES;
        self.showIsInjected.text = @" 已接种";
    }else{
        self.showIsInjected.text = @" 未接种";
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender {
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.isUpdate) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存修改" message:@"是否保存修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        [alert show];
        
    }else{
        [self dismissDetailVC];
    }
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 0 = cancel 1 = submit
    if (buttonIndex == 1) {
        
        self.inoculation.isInjected = self.isInjected.isOn;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"inoc_change" object:self];
    }
    [self dismissDetailVC];

}

-(void)dismissDetailVC
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        
        self.view.transform = CGAffineTransformMakeScale(0.2, 0.2);
        
    } completion:^(BOOL finished){
        
        [self.view removeFromSuperview];
        
        [self removeFromParentViewController];
        
    }];
}

-(void)initTheme
{
    [((JWBlurView *)self.view) setBlurAlpha:0.1];
    
    switch (self.inoculation.state) {
        case RMDInoculationStateNone:
        case RMDInoculationStateFutureUn:
            
            self.themeColor = [UIColor colorWithWhite:0.873 alpha:1.000];
            break;
            
        case RMDInoculationStatePastOk:
        case RMDInoculationStateTodayOk:
            self.themeColor = [UIColor colorWithRed:0.087 green:0.676 blue:0.542 alpha:1.000];
            break;
            
        case RMDInoculationStatePastUn:
            self.themeColor = [UIColor colorWithRed:0.987 green:0.252 blue:0.302 alpha:1.000];
            break;
            
        case RMDInoculationStateTodayUn:
            self.themeColor = [UIColor colorWithRed:0.993 green:0.650 blue:0.035 alpha:1.000];
            break;
            
        default:
            self.themeColor = [UIColor colorWithWhite:0.873 alpha:1.000];

            break;
    }
    [((JWBlurView *)self.view) setBlurColor:[UIColor clearColor]];
    
    self.titleLabel.backgroundColor = self.themeColor;

}
- (IBAction)switchChange:(id)sender {
    
    self.isUpdate = !self.isUpdate;
    
    if (self.isInjected.on) {
        self.showIsInjected.text = @" 已接种";
    }else{
        self.showIsInjected.text = @" 未接种";
    }
}
@end
