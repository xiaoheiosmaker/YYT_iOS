//
//  AlertWithComment.m
//  YYTHD
//
//  Created by ssj on 13-11-8.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "AlertWithComment.h"

@interface AlertWithComment ()


@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@end

@implementation AlertWithComment
- (void)awakeFromNib{
    self.backgroundView.alpha = 0;
    self.commentTextView.placeholder = @"说点什么。。。。。。";
    self.commentView.centerY -=146;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCommentText:(NSString *)commentText{
    self = [[[NSBundle mainBundle] loadNibNamed:@"AlertWithComment" owner:self options:nil] lastObject];
    if (self) {
        // Initialization code
        self.commentTextView.text = commentText;
        self.commentTextView.placeholder = @"说点什么。。。。。。。";
        self.commentTextView.textColor = [UIColor yytDarkGrayColor];
    }
    return self;
}

- (id)initWithShareText:(NSString *)shareText{
    self = [[[NSBundle mainBundle] loadNibNamed:@"AlertWithComment" owner:self options:nil] lastObject];
    if (self) {
        // Initialization code
        self.commentTextView.text = shareText;
        self.commentTextView.placeholder = @"说点什么。。。。。。。";
        self.commentTextView.textColor = [UIColor yytDarkGrayColor];
        [self.publishBtn setImage:[UIImage imageNamed:@"Share"] forState:UIControlStateNormal];
        [self.publishBtn setImage:[UIImage imageNamed:@"Share_Sel"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setShareText:(NSString *)shareText
{
    self.commentTextView.text = shareText;
}

- (void)alertShow{
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller.view addSubview:self];
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

- (void)showPlaceholder:(NSString *)commentPlaceholder{
    self.commentTextView.placeholder = commentPlaceholder;
    [self.commentTextView setPlaceholder:commentPlaceholder];
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
    
    self.publishBtn.enabled = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(publishButtonClicked:comment:)]) {
//        [self removeFromSuperview];
        [self.delegate publishButtonClicked:self comment:self.commentTextView.text];
        self.publishBtn.enabled = YES;
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
