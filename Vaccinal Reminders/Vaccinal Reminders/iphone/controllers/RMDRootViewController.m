//
//  RMDRootViewController
//  Reminder
//
//  Created by 张鹏 on 14-7-24.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDRootViewController.h"
#import <objc/runtime.h>
#import "RMDTranspBarNavigationController.h"
#import "appConfigs.h"

#define backPointX -110
#define backPointY 110

const char *RMDRootViewControllerKey = "RMDRootViewControllerKey";


@implementation UIViewController (RMDRootViewControllerCatagory)

- (RMDRootViewController *)rootVC {
    RMDRootViewController *rootViewController = objc_getAssociatedObject(self, &RMDRootViewControllerKey);
    if (!rootViewController) {
        rootViewController = self.parentViewController.rootVC;
    }
    
    return rootViewController;
}


- (void)setRootVC:(RMDRootViewController *)rootViewController {
    objc_setAssociatedObject(self, &RMDRootViewControllerKey, rootViewController, OBJC_ASSOCIATION_ASSIGN);
}


@end

@interface RMDRootViewController ()

@property(nonatomic)BOOL isBackShown;
@property(nonatomic)UIViewController *backVC;
@property(nonatomic)UIViewController *mainVC;
@property(nonatomic)RMDTranspBarNavigationController *NavigationVC;
@property(nonatomic)UIView *topView;


@end

@implementation RMDRootViewController

-(instancetype)initWithMainViewController:(UIViewController *)mainVC BackViewController:(UIViewController *)backVC
{
    self =  [super init];
    if (self) {
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        self.backVC = backVC;
        self.mainVC = mainVC;
        
        self.backVC.rootVC = self;
        self.mainVC.rootVC = self;
        
        //解决不同尺寸屏幕下的显示问题
        CGRect rect = self.view.bounds;
        self.mainVC.view.frame = rect;
        self.backVC.view.frame = rect;
        
        
        
        rect.origin.x = backPointX;
        rect.origin.y = backPointY;
        self.backVC.view.frame = rect;
        self.backVC.view.alpha = 0;
        [self.view addSubview:self.backVC.view];
        
        
        self.NavigationVC = [[RMDTranspBarNavigationController alloc]initWithRootViewController:mainVC];
        [self.view addSubview:self.NavigationVC.view];
        
        
        //遮盖层
        self.topView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        
        //支持点击隐藏backView
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchView)];
        //支持轻扫隐藏backView
        UISwipeGestureRecognizer *swipeGr = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(switchView)];
        swipeGr.direction = UISwipeGestureRecognizerDirectionLeft;
        
        self.topView.backgroundColor = [UIColor whiteColor];
        self.topView.alpha = 0.1;
        
        [self.topView addGestureRecognizer:singleTap];
        [self.topView addGestureRecognizer:swipeGr];
        
        self.isBackShown = NO;
        
        
        
        //添加滑动显示backView支持
        UISwipeGestureRecognizer *showBackViewGr = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(switchView)];
        
        showBackViewGr.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self.mainVC.view addGestureRecognizer:showBackViewGr];
        
        
    }
    return self;

}



-(void)setBackground:(UIImage *)image
{
    UIImageView *backGround = [[UIImageView alloc]initWithImage:image];
    
    [self.view insertSubview:backGround atIndex:0];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"birthday"]];
    //self.view.backgroundColor = bgColor;
    
    [self setBackground:[UIImage imageNamed:@"mainBackground"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchView
{
    
    if (self.isBackShown) {
        
        
        //防止多次点击
        self.backVC.view.userInteractionEnabled = NO;
        
        
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             CGRect rect = self.backVC.view.frame;
                             rect.origin.x = backPointX;
                             rect.origin.y = backPointY;
                             self.backVC.view.frame = rect;
                             self.backVC.view.alpha = 0;
                             
                             self.NavigationVC.view.transform = CGAffineTransformMakeScale(1, 1);
                             self.NavigationVC.view.frame = CGRectMake(0, self.NavigationVC.view.frame.origin.y, self.NavigationVC.view.frame.size.width, self.NavigationVC.view.frame.size.height);
                             
                             self.topView.alpha = 0;
                         } completion:^(BOOL finished) {
                             self.isBackShown = NO;
                             [self enableAll];
                         }];
        
        
    }else{
        
        
        //防止多次点击
        self.backVC.view.userInteractionEnabled = YES;
        
        [self disableAll];
        
    [UIView animateWithDuration:.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         
                         
                         CGRect rect = self.backVC.view.frame;
                         rect.origin.x = 0;
                         rect.origin.y = 0;
                         self.backVC.view.frame = rect;
                         self.backVC.view.alpha = 1;
                         self.backVC.view.transform = CGAffineTransformMakeScale(1, 1);
                         
                         
                         self.NavigationVC.view.transform = CGAffineTransformMakeScale(0.6, 0.6);
                         
                         self.NavigationVC.view.frame = CGRectMake(240, self.NavigationVC.view.frame.origin.y, self.NavigationVC.view.frame.size.width, self.NavigationVC.view.frame.size.height);
                         
                         
                         
                         self.topView.alpha = 0.1;
                         
                     } completion:^(BOOL finished) {
                         self.isBackShown = YES;
                     }];
    }
}

-(void)showBackView
{
    [self switchView];
    
}
-(void)changeRightVC:(id)viewController
{
    
    //防止多次点击
    self.backVC.view.userInteractionEnabled = NO;
    
    
    //先消失 再弹出
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        
        CGRect rect =  self.NavigationVC.view.frame ;
        
        rect.origin.x = SCREEN_BOUNDS.size.width;
        
        self.NavigationVC.view.frame = rect;
        
    } completion:^(BOOL finished){
        
        [self.NavigationVC pushViewController:viewController animated:NO];
        [self switchView];
    
    }];
    
    
}

-(void)disableAll
{
    [self.NavigationVC.view addSubview:self.topView];
    
}
-(void)enableAll
{
    [self.topView removeFromSuperview];
}
@end
