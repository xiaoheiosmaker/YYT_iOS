//
//  SettingsPaneView.h
//  YYTHD
//
//  Created by shuilin on 10/24/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoQualityCell.h"
#import "NormalSwitchCell.h"
#import "LoginAccountCell.h"

@interface SettingsPaneView : UIView
{
    
}
@property(retain,nonatomic) VideoQualityCell* videoQualityCell;
@property(retain,nonatomic) NormalSwitchCell* lockSwitchCell;
@property(retain,nonatomic) NormalSwitchCell* clearPlayHistory;
@property(retain,nonatomic) NormalSwitchCell* clearSearchHistory;
@property(retain,nonatomic) NormalSwitchCell* userGuide;
@property(retain,nonatomic) LoginAccountCell* sinaCell;
@property(retain,nonatomic) LoginAccountCell* qqCell;
@property(retain,nonatomic) LoginAccountCell* tencentCell;
@property(retain,nonatomic) LoginAccountCell* renrenCell;
@property(retain,nonatomic) NormalSwitchCell* messageTipCell;
@property(retain,nonatomic) NormalSwitchCell* mvTipCell;
@property(retain,nonatomic) NormalSwitchCell* saveTipCell;
@property(retain,nonatomic) NormalSwitchCell* netTipCell;
@end
