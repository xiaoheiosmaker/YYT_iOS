//
//  YYTUIButton.h
//  YYTHD
//
//  Created by ssj on 13-10-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTUIButton : UIButton
{
    UIImage *_normalImage;
    UILabel *_countdownLabel;

}
//加入图片的button
- (YYTUIButton*) configureForBackButtonWithTitle:(NSString*)title target:(id)target action:(SEL)action
                                       normalImg:(UIImage*)normalImg clickedImg:(UIImage*)clickedImg;
@end
