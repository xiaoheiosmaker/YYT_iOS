//
//  RootViewController.h
//  YYTHD
//
//  Created by btxkenshin on 10/10/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleButtonGroup.h"
@interface RootViewController : UIViewController

@property (weak, nonatomic) UIViewController *selectedViewController;
@property (strong, nonatomic) SingleButtonGroup* singleButtonGroup;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *mvBtn;
@property (weak, nonatomic) IBOutlet UIButton *mlBtn;
@property (weak, nonatomic) IBOutlet UIButton* vButton;
@property (weak, nonatomic) IBOutlet UIButton* settingButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UIButton *newsButton;

- (void)showMyDownload;
- (void)showFavoriteML;
- (void)showOwnML;
- (void)showMyMVCollections;
- (void)showMyOrderArtist;
- (void)showNotice;

- (void)showViewController:(UIViewController *)viewController;

- (void)showBottomViewAnimated:(BOOL)animated;
- (void)hideBottomViewAnimated:(BOOL)animated;

@end
