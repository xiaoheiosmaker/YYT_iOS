//
//  YYTUILabel.h
//  YYTHD
//
//  Created by ssj on 13-10-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTUILabel : UILabel
{
    BOOL _selected;
    UIColor *_oldColor;
}
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) UIColor *textSelectedColor;
@end
