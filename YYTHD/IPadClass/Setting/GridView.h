//
//  GridView.h
//  YYTHD
//
//  Created by 崔海成 on 1/6/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridView : UIView
@property (nonatomic) NSInteger rowNumbers;
@property (nonatomic) NSInteger columnNumbers;
@property (nonatomic) CGFloat borderWeight;
@property (nonatomic, strong) UIColor *borderColor;
@end
