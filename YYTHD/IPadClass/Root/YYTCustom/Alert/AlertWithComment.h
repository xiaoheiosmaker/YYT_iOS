//
//  AlertWithComment.h
//  YYTHD
//
//  Created by ssj on 13-11-8.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTextViewPlaceholder.h"
#import "GCPlaceholderTextView.h"
#import "TQTextView.h"
@protocol AlertWithCommentDelegate;
@interface AlertWithComment : UIView
@property (weak, nonatomic) IBOutlet TQTextView *commentTextView;
@property(nonatomic, weak)id<AlertWithCommentDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property(nonatomic, weak)NSString *shareText;
@property (weak, nonatomic) IBOutlet UIView *commentView;
- (id)initWithCommentText:(NSString *)commentText;
- (id)initWithShareText:(NSString *)shareText;
- (void)alertShow;
- (void)alertDisMis;
- (void)showPlaceholder:(NSString *)commentPlaceholder;
@end

@protocol AlertWithCommentDelegate <NSObject>

@required
- (void)publishButtonClicked:(AlertWithComment *)alert comment:(NSString*)comment;



@end