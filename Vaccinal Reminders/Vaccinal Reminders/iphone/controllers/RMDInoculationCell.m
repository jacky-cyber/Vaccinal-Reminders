//
//  RMDInoculationCell.m
//  Vaccinal Reminders
//
//  Created by 张鹏 on 14-9-22.
//  Copyright (c) 2014年 北京携康云享科技有限公司. All rights reserved.
//

#import "RMDInoculationCell.h"

@interface RMDInoculationCell ()
@end

@implementation RMDInoculationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.stateImage.image = [UIImage imageNamed:@"cellstateunread"];
    }
    return self;
}

-(void)setState:(RMDInoculationState)state
{
    
    switch (state) {
        case RMDInoculationStateNone:
        case RMDInoculationStateFutureUn:
            self.stateImage.image = [UIImage imageNamed:@"cellstateunread"];
            break;
         
        case RMDInoculationStatePastOk:
        case RMDInoculationStateTodayOk:
            self.stateImage.image = [UIImage imageNamed:@"cellstatecompleted"];
            break;
            
        case RMDInoculationStatePastUn:
            self.stateImage.image = [UIImage imageNamed:@"cellstateattention"];
            break;
            
        case RMDInoculationStateTodayUn:
            self.stateImage.image = [UIImage imageNamed:@"cellstatewillnotice"];
            break;
            
        default:
            break;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
