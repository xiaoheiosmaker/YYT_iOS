//
//  UserGuideViewController.m
//  YYTHD
//
//  Created by IAN on 13-12-25.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "UserGuideViewController.h"
#import "AcceleratedItemView.h"
#import "AcceleratedContainterView.h"

@interface UserGuideViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation UserGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGPoint captionOrigin = CGPointMake(113, 102);
    //CGRect captionFrame = CGRectMake(113, 102, 592, 82);
    CGRect itemFrame_1 = CGRectMake(170, 206, 422, 313);
    CGRect itemFrame_2 = CGRectMake(475, 294, 354, 262);
    
    //Page 1
    AcceleratedContainterView *containterView = [[AcceleratedContainterView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    AcceleratedItemView *itemView = [[AcceleratedItemView alloc] initWithFrame:CGRectMake(captionOrigin.x, captionOrigin.y, 592, 82)];
    itemView.image = [UIImage imageNamed:@"guide_caption01"];
    itemView.factor = 0;
    [containterView addSubview:itemView];
    
    itemView = [[AcceleratedItemView alloc] initWithFrame:itemFrame_1];
    itemView.image = [UIImage imageNamed:@"guide1_01"];
    itemView.factor = 0.3;
    [containterView addSubview:itemView];
    
    itemView = [[AcceleratedItemView alloc] initWithFrame:itemFrame_2];
    itemView.image = [UIImage imageNamed:@"guide1_03"];
    itemView.factor = 1;
    [containterView addSubview:itemView];
    
    itemView = [[AcceleratedItemView alloc] initWithFrame:CGRectMake(370, 445, 164, 163)];
    itemView.image = [UIImage imageNamed:@"guide1_02"];
    itemView.factor = 0.9;
    [containterView addSubview:itemView];
    
    [self.scrollView addSubview:containterView];
    
    //Page 2
    containterView = [[AcceleratedContainterView alloc] initWithFrame:CGRectMake(1024, 0, 1024, 768)];
    itemView = [[AcceleratedItemView alloc] initWithFrame:CGRectMake(captionOrigin.x, captionOrigin.y, 561, 82)];
    itemView.image = [UIImage imageNamed:@"guide_caption02"];
    [containterView addSubview:itemView];
    
    itemView = [[AcceleratedItemView alloc] initWithFrame:itemFrame_1];
    itemView.image = [UIImage imageNamed:@"guide2_01"];
    [containterView addSubview:itemView];
    
    itemView = [[AcceleratedItemView alloc] initWithFrame:itemFrame_2];
    itemView.image = [UIImage imageNamed:@"guide2_02"];
    [containterView addSubview:itemView];
    
    [containterView prepareToShow];
    [self.scrollView addSubview:containterView];
    
    //Page3
    containterView = [[AcceleratedContainterView alloc] initWithFrame:CGRectMake(2048, 0, 1024, 768)];
    itemView = [[AcceleratedItemView alloc] initWithFrame:CGRectMake(captionOrigin.x, captionOrigin.y, 648, 82)];
    itemView.image = [UIImage imageNamed:@"guide_caption03"];
    [containterView addSubview:itemView];
    
    itemView = [[AcceleratedItemView alloc] initWithFrame:itemFrame_1];
    itemView.image = [UIImage imageNamed:@"guide3_01"];
    [containterView addSubview:itemView];
    
    itemView = [[AcceleratedItemView alloc] initWithFrame:itemFrame_2];
    itemView.image = [UIImage imageNamed:@"guide3_02"];
    [containterView addSubview:itemView];
    
    itemView = [[AcceleratedItemView alloc] initWithFrame:CGRectMake(805, 684, 165, 59)];
    itemView.userInteractionEnabled = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"guide_enter"];
    [btn setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"guide_enter_h"];
    [btn setImage:image forState:UIControlStateHighlighted];
    btn.frame = itemView.bounds;
    [btn addTarget:self action:@selector(enterEvent:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:btn];
    [containterView addSubview:itemView];
    
    [containterView prepareToShow];
    [self.scrollView addSubview:containterView];
    
    self.scrollView.contentSize = CGSizeMake(1024*3, CGRectGetHeight(self.scrollView.frame));
    UIImage *bgImage = [UIImage imageNamed:@"guide_bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.decelerationRate = 0.998;
    //self.scrollView.pagingEnabled = YES;
}

- (void)enterEvent:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *subviews = [self.scrollView subviews];
    CGFloat offset = self.scrollView.contentOffset.x;
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AcceleratedContainterView *view = obj;
        if ([view isKindOfClass:[AcceleratedContainterView class]]) {
            [view accelerateWithOffset:offset];
        }
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint point = scrollView.contentOffset;
    CGFloat width = CGRectGetWidth(scrollView.frame);
    float position = point.x / width;
    NSInteger nearestPage = position;
    if (position > nearestPage) {
        if (velocity.x > 0) {
            ++nearestPage;
        }
    }
    targetContentOffset->x = width * nearestPage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


@end
