//
//  TopView.h
//  YYTHD
//
//  Created by shuilin on 10/23/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopView;
@protocol TopViewDelegate <NSObject>
@optional
- (void)topView:(TopView*)topView clickedSideMenu:(id)sender;
- (void)topView:(TopView*)topView clickedRecent:(id)sender;
- (void)topView:(TopView *)topView clickedNoticeBtn:(id)sender;
- (void)searchFinished:(id)sender;
- (void)searchTextChange:(id)sender;
- (void)textBeginEdit;
@end

@interface TopView : UIView<UITextFieldDelegate,TopViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *searchIcon;
@property (weak, nonatomic) IBOutlet UIImageView *searchBackground;
@property (weak, nonatomic) IBOutlet UIImageView *unreadNoticeImage;
@property (strong, nonatomic) IBOutlet UILabel *unReadCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *unReadImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *navImageView;
@property(assign,nonatomic) id <TopViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property(retain,nonatomic) IBOutlet UIImageView* titleImageView;
@property(retain,nonatomic) IBOutlet UIButton* sideButton;

- (void)isShowSideButton:(BOOL)isShow;
- (void)isShowTimeButton:(BOOL)isShow;
- (void)isShowTextField:(BOOL)isShow;
- (void)setTitleImage:(UIImage *)image;
- (void)setSearchBackgroundImage:(NSString *)image;

@end
