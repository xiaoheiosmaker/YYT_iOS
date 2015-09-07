//
//  TopView.m
//  YYTHD
//
//  Created by shuilin on 10/23/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "TopView.h"
#import "MVChannelViewController.h"
#import "AppDelegate.h"
#import "UIImageView+LBBlurredImage.h"

@interface TopView ()
{
    
}
- (IBAction)clickNoticeBtn:(id)sender;
- (IBAction)clickSideMenu:(id)sender;
- (IBAction)clickRecent:(id)sender;
- (IBAction)textDoneEditing:(id)sender;
@end

@implementation TopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    //if([[self viewController] isMemberOfClass:[MVChannelViewController class]])
    {
        //self
        self.searchTextField.delegate = self;
        [self.searchTextField addTarget:self action:@selector(searchInputFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self.searchTextField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
        self.unReadCountLabel.hidden = YES;
        self.unReadImageView.hidden = YES;
        self.closeBtn.hidden = YES;
    }
}

- (void)setTitleImage:(UIImage *)image
{
    [self.titleImageView setImage:image];
    CGRect titleFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.titleImageView.frame = titleFrame;
    CGPoint center = CGPointMake(self.size.width / 2, self.size.height / 2);
    self.titleImageView.center = center;
}

- (void)searchInputFinished:(id)sender{
    self.searchBackground.image = IMAGE(@"Search_Back_White");
    
    NSString *value = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //    NSLog(@"value====%@",value);
    if ([value isEqualToString:@""]) {
        [AlertWithTip flashFailedMessage:@"搜索内容不能为空!"];
        return;
    }
//    NSString *TextStr = [self.searchTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.searchTextField.text = value;
    [self searchByText];
    
}


- (void)searchByText{
    if (_delegate && [_delegate respondsToSelector:@selector(searchFinished:)]) {
        [_delegate searchFinished:self.searchTextField];
    }
}

- (void)editingChanged:(id)sender{
    if (self.searchTextField.text.length > 0) {
        self.closeBtn.hidden = NO;
    }else{
        self.closeBtn.hidden = YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(searchTextChange:)]) {
        [_delegate searchTextChange:self.searchTextField];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self setSearchBackgroundImage:@"Search_Sel_Background"];

//    self.searchBackground.image = IMAGE(@"Search_Sel_Background");
    if (_delegate && [_delegate respondsToSelector:@selector(textBeginEdit)]) {
        [_delegate textBeginEdit];
    }
}

- (void)setSearchBackgroundImage:(NSString *)image{
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [transtion setType:kCATransitionFade];
    [transtion setSubtype:kCATransitionFromTop];
    [self.searchBackground setImage:[UIImage imageNamed:image]];
    [self.searchBackground.layer addAnimation:transtion forKey:@"animationKey"];
}

- (IBAction)clickNoticeBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(topView:clickedNoticeBtn:)]) {
        [_delegate topView:self clickedNoticeBtn:sender];
    }
}

- (IBAction)clickSideMenu:(id)sender
{
    [self.delegate topView:self clickedSideMenu:sender];
}

- (IBAction)textDoneEditing:(id)sender
{
    self.searchBackground.image = IMAGE(@"Search_Back_White");
    [sender resignFirstResponder];
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
- (IBAction)textFieldClean:(id)sender {
    self.searchTextField.text = @"";
    self.closeBtn.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TextFieldNULL" object:nil];
}

- (IBAction)clickRecent:(id)sender
{
    [self.delegate topView:self clickedRecent:sender];
}

- (void)isShowSideButton:(BOOL)isShow{
    self.unreadNoticeImage.hidden = !isShow;
    self.sideButton.hidden = !isShow;
    self.noticeBtn.hidden = !isShow;
    [self.unReadCountLabel removeFromSuperview];
    [self.unReadImageView removeFromSuperview];
    [self.unreadNoticeImage removeFromSuperview];
}

- (void)isShowTextField:(BOOL)isShow{
    self.searchBackground.hidden = !isShow;
    self.searchIcon.hidden = !isShow;
    self.searchTextField.hidden = !isShow;
}

- (void)isShowTimeButton:(BOOL)isShow{
    self.timeButton.hidden = !isShow;
}

@end
