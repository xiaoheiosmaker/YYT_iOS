//
//  EmptyViewController.m
//  YYTHD
//
//  Created by shuilin on 11/22/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "EmptyViewController.h"

@interface EmptyViewController ()
{
    
}
@property(retain,nonatomic) PlaceView* placeView;
@property(retain,nonatomic) ExtraUpView* extraUpView;
@end

@implementation EmptyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrv.delegate = self;
    
    self.extraUpView = [[[NSBundle mainBundle] loadNibNamed:@"ExtraUpView" owner:self options:nil] lastObject];
    self.extraUpView.delegate = self;
    [self.scrv addSubview:self.extraUpView];
    self.scrv.bounces = NO;
    CGRect rect = self.extraUpView.frame;
    rect.origin.y = 0 - rect.size.height;//隐藏到上面
    self.extraUpView.frame = rect;
    
    //状态复位
    [self.extraUpView reset];
    
    self.placeView = [[[NSBundle mainBundle] loadNibNamed:@"PlaceView" owner:self options:nil] lastObject];
    [self.scrv addSubview:self.placeView];
    
    CGPoint point = self.scrv.center;
    point.y -= 50;//适当往上移一点
    self.placeView.center = point;
//   添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClicked)];
    [self.scrv addGestureRecognizer:tap];
}

- (void)handleClicked{
    if([self.delegate respondsToSelector:@selector(triggerLoading:)])
    {
        [self.delegate triggerLoading:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    self.view.hidden = hidden;
}

- (void)setHolderImage:(UIImage *)holderImage
{
    _holderImage = holderImage;
    
    self.placeView.tipImage = holderImage;
}

- (void)setHolderText:(NSString *)holderText
{
    _holderText = holderText;
    
    self.placeView.tipText = holderText;
}

- (void)bringToFront
{
    [[self.view superview] bringSubviewToFront:self.view];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrv)
    {
        CGFloat y = scrollView.contentOffset.y;
        [self.extraUpView trackY:y];
    }
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == self.scrv)
    {
        CGFloat y = scrollView.contentOffset.y;
        [self.extraUpView endTrackY:y];
    }
}

-(void) comeBeginUpLoading
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.scrv.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    
    [UIView commitAnimations];
    
    if([self.delegate respondsToSelector:@selector(triggerLoading:)])
    {
        [self.delegate triggerLoading:self];
    }
    
}

-(void) doneLoading
{
    [self.extraUpView reset];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView animateWithDuration:0.0 animations:^{
        
        [self.scrv setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
    }completion:^(BOOL finished)
     {
         
     }];
    
    [UIView commitAnimations];
    
}

@end
