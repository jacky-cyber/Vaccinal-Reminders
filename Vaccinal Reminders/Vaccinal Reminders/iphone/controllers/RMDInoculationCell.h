//
//  RMDInoculationCell.h
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-22.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appConfigs.h"

@interface RMDInoculationCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel *dateLabel;
@property(nonatomic,weak)IBOutlet UIImageView *stateImage;
@property(nonatomic)RMDInoculationState state;

@property(nonatomic,weak)IBOutlet UILabel *vaccineLabel;
@property(nonatomic,weak)IBOutlet UILabel *detailedLabel;

@end
