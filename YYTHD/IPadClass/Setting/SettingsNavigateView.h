//
//  SettingsNavigateView.h
//  YYTHD
//
//  Created by shuilin on 10/24/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleButtonGroup.h"

@class SettingsNavigateView;
@protocol SettingsNavigateViewDelegate <NSObject>
- (void) settingsNavigateView:(SettingsNavigateView*) navigateView clickedSetting:(id)sender;
- (void) settingsNavigateView:(SettingsNavigateView*) navigateView clickedComment:(id)sender;
- (void) settingsNavigateView:(SettingsNavigateView*) navigateView clickedAbout:(id)sender;
- (void) settingsNavigateView:(SettingsNavigateView*) navigateView clickedLogin:(id)sender;
- (void) settingsNavigateView:(SettingsNavigateView*) navigateView clickedHead:(id)sender;
- (void)settingsNavigateView:(SettingsNavigateView*) navigateView clickedFeedback:(id)sender;
@end

@interface SettingsNavigateView : UIView
{
    
}
@property(assign,nonatomic) id <SettingsNavigateViewDelegate> delegate;

@property(retain,nonatomic) SingleButtonGroup* singleButtonGroup;
@property(retain,nonatomic) IBOutlet UIButton* settingButton;
@property(retain,nonatomic) IBOutlet UIButton* commentButton;
@property(retain,nonatomic) IBOutlet UIButton* aboutButton;
@property(retain,nonatomic) IBOutlet UIButton* feedbackButton;
@property(retain,nonatomic) IBOutlet UIButton* loginButton;
@property(retain,nonatomic) IBOutlet UIButton* headButton;
@property(retain,nonatomic) IBOutlet UILabel* nickLabel;
@end
