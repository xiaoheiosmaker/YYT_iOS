//
//  AlertWithShare.m
//  YYTHD
//
//  Created by ssj on 13-11-8.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "AlertWithShare.h"

@interface AlertWithShare ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@end

@implementation AlertWithShare
- (void)awakeFromNib{
    self.backgroundView.alpha = 0.5;
    self.commentTextView.placeholder = @"说点什么。。。。。。。";
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithShareText:(NSString *)shareText{
    self = [[[NSBundle mainBundle] loadNibNamed:@"AlertWithShare" owner:self options:nil] lastObject];
    if (self) {
        // Initialization code
        self.commentTextView.textColor = [UIColor yytDarkGrayColor];
        self.commentTextView.text = shareText;
        [self.commentTextView becomeFirstResponder];
    }
    return self;
}

- (void)setShareText:(NSString *)shareText
{
    self.commentTextView.text = shareText;
}

- (void)alertShow{
    UIViewController *vc = (UIViewController *)self.delegate;
    [vc.view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.commentView.centerY += 206;
        self.backgroundView.alpha = 0.5;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.commentView.centerY -= 70;
                [self.commentTextView becomeFirstResponder];
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }];
}

- (void)alertDisMis{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
        
    }];
}

- (IBAction)cancelClicked:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
        
    }];
}
- (IBAction)sureClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertWithShare:shareText:)]) {
//        [self removeFromSuperview];
        [self.delegate alertWithShare:self shareText:self.commentTextView.text];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
