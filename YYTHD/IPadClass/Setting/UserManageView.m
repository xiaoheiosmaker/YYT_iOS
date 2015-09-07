//
//  UserManageView.m
//  YYTHD
//
//  Created by ssj on 13-12-26.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "UserManageView.h"
@interface UserManageView ()
- (IBAction)logout:(id)sender;
@end

@implementation UserManageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    UIImage *image = [UIImage imageNamed:@"contentBackground"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.backgroundImageView.image = image;
}

- (IBAction)modifyNickname:(id)sender {
    if ([self.controller respondsToSelector:_cmd]) {
        [self.controller modifyNickname:sender];
    }
}

- (IBAction)bindingAccount:(id)sender {
    if ([self.controller respondsToSelector:_cmd]) {
        [self.controller bindingAccount:sender];
    }
}

- (IBAction)validateEmail:(id)sender {
    if ([self.controller respondsToSelector:_cmd]) {
        [self.controller validateEmail:sender];
    }
}

- (IBAction)bindingPhone:(id)sender {
    if ([self.controller respondsToSelector:_cmd]) {
        [self.controller bindingPhone:sender];
    }
}

- (IBAction)bindingWeibo:(id)sender {
    if ([self.controller respondsToSelector:_cmd]) {
        [self.controller bindingWeibo:sender];
    }
}

- (IBAction)logout:(id)sender {
    if ([self.controller respondsToSelector:_cmd]) {
        [self.controller logout:sender];
    }
}
@end
