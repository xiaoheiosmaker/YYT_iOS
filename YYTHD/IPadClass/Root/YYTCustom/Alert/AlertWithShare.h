//
//  AlertWithShare.h
//  YYTHD
//
//  Created by ssj on 13-11-8.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTextViewPlaceholder.h"
#import "GCPlaceholderTextView.h"
#import "TQTextView.h"
@protocol AlertWithShareDelegate;
@interface AlertWithShare : UIView
@property (weak, nonatomic) IBOutlet TQTextView *commentTextView;
@property(nonatomic, weak)id<AlertWithShareDelegate> delegate;
@property(nonatomic, weak)NSString *shareText;
@property (weak, nonatomic) IBOutlet UIView *commentView;
- (id)initWithShareText:(NSString *)shareText;
- (void)alertShow;
- (void)alertDisMis;
@end

@protocol AlertWithShareDelegate <NSObject>

@required
- (void)alertWithShare:(AlertWithShare *)alert shareText:(NSString*)shareText;



@end