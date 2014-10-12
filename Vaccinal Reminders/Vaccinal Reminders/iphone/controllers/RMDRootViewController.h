//
//  RMDRootViewController
//  Reminder
//
//  Created by 张鹏 on 14-7-24.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMDRootViewController : UIViewController

-(instancetype)initWithMainViewController:(UIViewController *)mainVC BackViewController:(UIViewController *)backVC ;

-(void)setBackground:(UIImage *)image;

-(void)showBackView;

-(void)changeRightVC:(id)viewController ;


@end


@interface UIViewController (RMDRootViewControllerCatagory)
    
@property (nonatomic) RMDRootViewController *rootVC;

@end