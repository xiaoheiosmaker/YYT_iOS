//
//  ComSearchView.h
//  YYTHD
//
//  Created by ssj on 13-11-1.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ComSearchViewDelegate;
@interface ComSearchView : UIView
@property (weak, nonatomic) IBOutlet UIButton *areaAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *artistAllBtn;
@property (weak, nonatomic) id <ComSearchViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UIView *artistView;
+ (instancetype)defaultSizeView;
+ (CGSize)defaultSize;
@property (strong, nonatomic)NSMutableDictionary *params;
@end


@protocol ComSearchViewDelegate <NSObject>

- (void)comSerachClicked:(NSMutableDictionary *)params;

@end