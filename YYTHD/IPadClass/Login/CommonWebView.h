//
//  RegisterView.h
//  YYTHD
//
//  Created by 崔海成 on 11/12/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonWebView : UIView <UIWebViewDelegate>
- (id)initWithURLString:(NSString *)URLString frame:(CGRect)frame;
@end
