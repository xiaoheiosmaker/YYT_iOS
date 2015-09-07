//
//  EditableViewController.m
//  YYTHD
//
//  Created by 崔海成 on 11/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "EditableViewController.h"
#import "TopView.h"
#define TOP_BAR_RIGHT_SPACE 10.0

@interface EditableViewController ()
@end

@implementation EditableViewController
@synthesize editable = _editable;
@synthesize editing = _editing;
@synthesize editBtn = _editBtn;
@synthesize doneBtn = _doneBtn;
@synthesize needCommit = _needCommit;
@synthesize commitIndicator = _commitIndicator;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditable:(BOOL)editable
{
    if (_editable != editable) {
        _editable = editable;
        if (_editable) {
            [self.topView isShowTextField:NO];
            [self.topView isShowTimeButton:NO];
            [self.topView addSubview:self.editBtn];
            [self.topView addSubview:self.doneBtn];
            self.editing = NO;
        }
        else {
            [self.topView isShowTextField:YES];
            [self.topView isShowTimeButton:YES];
            [self.editBtn removeFromSuperview];
            [self.doneBtn removeFromSuperview];
        }
        self.editing = NO;
    }
}

- (void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        if (_editing) {
            self.editBtn.hidden = YES;
            self.commitIndicator.hidden = YES;
            self.doneBtn.hidden = NO;
        }
        else {
            self.doneBtn.hidden = YES;
            if (self.needCommit) {
                [self.commitIndicator startAnimating];
                [self commit];
            } else {
                self.editBtn.hidden = NO;
            }
        }
    }
}

- (UIButton *)editBtn
{
    if (!_editBtn) {
        UIImage *normalImg = [UIImage imageNamed:@"ml_edit"];
        UIImage *highImg = [UIImage imageNamed:@"ml_edit_h"];
        CGSize size = normalImg.size;
        CGFloat x = 1024 - (size.width + TOP_BAR_RIGHT_SPACE);
        CGFloat y = (kTopBarHeight - size.height) / 2;
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(x, y, size.width, size.height);
        [_editBtn setImage:normalImg forState:UIControlStateNormal];
        [_editBtn setImage:highImg forState:UIControlStateHighlighted];
        [_editBtn addTarget:self
                     action:@selector(editBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)doneBtn
{
    if (!_doneBtn) {
        UIImage *normalImg = [UIImage imageNamed:@"ml_confirm"];
        UIImage *highImg = [UIImage imageNamed:@"ml_confirm_h"];
        CGSize size = normalImg.size;
        CGFloat x = 1024 - (size.width + TOP_BAR_RIGHT_SPACE);
        CGFloat y = (kTopBarHeight - size.height) / 2;
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.frame = CGRectMake(x, y, size.width, size.height);
        [_doneBtn setImage:normalImg forState:UIControlStateNormal];
        [_doneBtn setImage:highImg forState:UIControlStateHighlighted];
        [_doneBtn addTarget:self
                     action:@selector(doneBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (UIActivityIndicatorView *)commitIndicator
{
    if (!_commitIndicator) {
        _commitIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _commitIndicator.center = self.doneBtn.center;
        _commitIndicator.hidesWhenStopped = YES;
        [_commitIndicator stopAnimating];
    }
    return _commitIndicator;
}

- (void)editBtnClicked:(id)sender
{
    self.editing = YES;
}

- (void)doneBtnClicked:(id)sender
{
    self.editing = NO;
}

- (void)commit
{
    // override commit data change
}

@end
