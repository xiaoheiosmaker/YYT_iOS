//
//  MLParticularViewController.m
//  YYTHD
//
//  Created by 崔海成 on 12/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MLParticularViewController.h"
#import "MVHeaderView.h"
#import "MVCell.h"
#import "MVItem.h"
#import "SystemSupport.h"
#import "MLOutlineView.h"
#import "MLDataController.h"
#import "UserDataController.h"
#import "YYTMoviePlayerViewController.h"
#import "NSError+YYTError.h"
#import "OPSelectView.h"
#import "PopoverView.h"
#import "ShareAssistantController.h"
#import "UITableView+Selection.h"
#import "UIView+FindViewThatIsFirstResponder.h"

@interface MLParticularViewController () <UITableViewDataSource, UITableViewDelegate, PopoverViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
{
    __weak UIView *editPanelView;
    __weak UITableView *mvTableView;    // mv列表
    __weak MVHeaderView *mvHeaderView;  // 右侧头部
    __weak MLOutlineView *outlineView;  // 左侧悦单内容区域
    
    __weak PopoverView *selectPopoverView;
    __weak UIButton *shareBtn;
    __weak UIButton *selectAllButton;
    
    BOOL isLoaded;
    
    UIPopoverController *pickerPopover;
}
@end

@implementation MLParticularViewController

- (id)initWithMLItem:(MLItem *)item
{
    
    self = [super init];
    
    if (self)
    {
        
        self.item = item;
        
    }
    
    return self;
        
}

- (id)init
{
    
    return [self initWithMLItem:nil];
    
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    outlineView.editing = editing;
    mvTableView.editing = editing;
    editPanelView.hidden = !editing;
    [self switchSelectAllButton:NO];
}

- (void)loadView
{
    CGRect frame = CGRectMake(0, 0, 1024, 768);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
    
    outlineView = [self setupOutlineView];
    mvTableView = [self setupMVTableView];
    editPanelView = [self setupEditPanel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isLoaded = YES;
    [self resetTopView:NO];
    
    [self.topView isShowTextField:NO];
    [self.topView isShowTimeButton:NO];
    [self.topView isShowSideButton:NO];
    [self.topView setTitleImage:[UIImage imageNamed:@"ml_detail_title"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isLoaded) {
        isLoaded = NO;
        [self updateData];
        
        [self reloadData];
    }
}

- (void)updateData
{
    if (self.item.keyID)
    {
        
        [self showLoading];
        
        __weak MLParticularViewController *weakSelf = self;
        
        [[MLDataController sharedObject] fetchMLDetailForID:self.item.keyID completion:^(MLItem *item, NSError *error) {
            
            [self hideLoading];
            
            if (!error) [weakSelf fillItem:item];
            
        }];
        
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)hideKeyboard
{
    UIResponder *resp = [outlineView firstResponder];
    if (resp) {
        [resp resignFirstResponder];
    }
}

#pragma mark - private methods
- (MLOutlineView *)setupOutlineView
{
    CGFloat statusBarHeight = [SystemSupport versionPriorTo7] ? 0 : 20;
    MLOutlineView *view = [[MLOutlineView alloc] init];
    view.controller = self;
    view.frame = CGRectMake(7, 66 + statusBarHeight, 496, 617);
    [self.view addSubview:view];
    return view;
}

- (UITableView *)setupMVTableView
{
    CGFloat statusBarHeight = [SystemSupport versionPriorTo7] ? 0 : 20;
    CGRect frame = CGRectMake(521, statusBarHeight, 495, 768);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(70, 0, 84, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(tableView.contentInset.top, 0, tableView.contentInset.bottom, -7);
    tableView.clipsToBounds = NO;
    tableView.allowsMultipleSelection = NO;
    tableView.allowsMultipleSelectionDuringEditing = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = [[MVHeaderView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    mvHeaderView = (MVHeaderView *)tableView.tableHeaderView;
    return tableView;
}

- (UIView *)setupEditPanel
{
    UIView *panel = [[UIView alloc] init];
    UIImage *image = [UIImage imageNamed:@"2btn_background"];
    UIImageView *background = [[UIImageView alloc] initWithImage:image];
    panel.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [panel addSubview:background];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    image = [UIImage imageNamed:@"ml_detail_selected_all"];
    [button setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"ml_detail_selected_all_h"];
    [button setImage:image forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    float margin = 18;
    button.frame = CGRectMake(margin, (background.height - image.size.height) / 2, image.size.width, image.size.height);
    selectAllButton = button;
    [panel addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    image = [UIImage imageNamed:@"ml_detail_delete"];
    [button setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"ml_detail_delete_h"];
    [button setImage:image forState:UIControlStateHighlighted];
    button.frame = CGRectMake(background.width - image.size.width - margin, (background.height - image.size.height) / 2, image.size.width, image.size.height);
    [button addTarget:self action:@selector(removeSelected:) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:button];
    
    margin = 20;
    float statusBarHeight = [SystemSupport versionPriorTo7] ? 0 : 20;
    panel.origin = CGPointMake(1024 - margin - panel.width, statusBarHeight + kTopBarHeight);
    [self.view addSubview:panel];
    panel.hidden = YES;
    
    return panel;
}

- (void)playAtIndexPath:(NSIndexPath *)ip
{
    YYTMoviePlayerViewController *player = [YYTMoviePlayerViewController movieListPlayerViewControllerWithMLItem:self.item];
    [self presentViewController:player
                       animated:YES
                     completion:nil];
    [player playMVItemAtIndex:ip.row];
}

- (void)fillItem:(MLItem *)item
{
    self.item = item;
    [self reloadData];
}

- (void)reloadData
{
    [mvTableView reloadData];
    mvHeaderView.amountOfMV = [self.item.videos count];
    outlineView.item = self.item;
}

- (void)switchSelectAllButton:(BOOL)isDeselected
{
    UIImage *image;
    if (isDeselected) {
        image = [UIImage imageNamed:@"ml_detail_deselected_all"];
        [selectAllButton setImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"ml_detail_deselected_all_h"];
        [selectAllButton setImage:image forState:UIControlStateHighlighted];
    }
    else
    {
        image = [UIImage imageNamed:@"ml_detail_selected_all"];
        [selectAllButton setImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"ml_detail_selected_all_h"];
        [selectAllButton setImage:image forState:UIControlStateHighlighted];
    }
}

#pragma mark - observer
- (void)keyboardShown:(NSNotification *)notification
{
    if (!self.editing) return;
    UIView *textControl = [outlineView firstResponder];
    CGRect textRect = [self.view convertRect:textControl.frame fromView:textControl.superview];
    NSValue *keyboardRect = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect newKeyboardRect = [keyboardRect CGRectValue];
    float offset = textRect.origin.y + textRect.size.height - (self.view.bounds.size.height - newKeyboardRect.size.width);
    if (offset > 0) {
        [UIView beginAnimations:@"moveForKeyboard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.5];
        self.view.origin = CGPointMake(0, -offset - 5);
        [UIView commitAnimations];
    }
}

- (void)keyboardHidden:(NSNotification *)notification
{
    if (!self.editing) return;
    if (self.view.origin.y != 0) {
        [UIView beginAnimations:@"moveForKeyboard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.5];
        self.view.origin = CGPointMake(0, 0);
        [UIView commitAnimations];
    }
}

#pragma mark - targetAction methods

- (void)joinToML:(id)sender atIndexPath:(NSIndexPath *)ip
{
    if (self.presentingViewController) {
        __weak MLParticularViewController *weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            [weakSelf joinToML:sender atIndexPath:ip];
        }];
        return;
    }
    MVItem *item = [self.item.videos objectAtIndex:ip.row];
    [AddMVToMLAssistantController sharedInstance].mvToAdd = item;
}

- (void)changeCover:(id)sender useSourceType:(NSNumber *)soureType
{
    [self hideKeyboard];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = [soureType intValue];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self presentModalViewController:picker animated:YES];
    }
    else {
        pickerPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
        UIButton *button = sender;
        CGRect rect = [self.view convertRect:button.frame fromView:button.superview];
        [pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)play:(id)sender
{
    if ([self.item.videos count] == 0) {
        [AlertWithTip flashFailedMessage:@"无法播放空悦单"];
        return;
    }
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    [self playAtIndexPath:ip];
}

- (void)share:(id)sender to:(NSNumber *)opType
{
    [selectPopoverView dismiss:YES];
    [[ShareAssistantController sharedInstance] shareMLItem:self.item toOpenPlatform:[opType intValue] inViewController:self completion:nil];
}

- (void)addToFavorite:(id)sender
{
    if (![UserDataController sharedInstance].isLogin) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        CGSize origSize = loginViewController.view.frame.size;
        [self presentViewController:loginViewController animated:NO completion:^{
            UIView *view = loginViewController.view;
            UIView *superView = view.superview;
            superView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            NSArray *subViews = superView.subviews;
            for (UIView *subView in subViews) {
                if (subView != view) {
                    subView.hidden = YES;
                }
            }
            CGPoint curCenter = superView.center;
            superView.frame = CGRectMake(0, 0, origSize.height, origSize.width);
            superView.center = curCenter;
        }];
        return;
    }
    
    [(UIButton *)sender setEnabled:NO];
    [[MLDataController sharedObject] addFavoriteWithID:self.item.keyID
                                            completion:
         ^(BOOL success, NSError *error) {
            [(UIButton *)sender setEnabled:YES];
            if (success)
                [AlertWithTip flashSuccessMessage:@"收藏悦单成功"];
            else
                [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
        }];
}

- (void)share:(id)sender
{
    CGRect frame = CGRectMake(0, 0, 329, 330);
    OPSelectView *select = [[OPSelectView alloc] initWithFrame:frame];
    select.controller = self;
    shareBtn = sender;
    shareBtn.enabled = NO;
    CGPoint center = [self.view convertPoint:shareBtn.center fromView:shareBtn.superview];
    PopoverView *popoverView = [PopoverView showPopoverAtPoint:center
                                                        inView:self.view
                                                 withViewArray:[NSArray arrayWithObject:select]
                                                      delegate:self];
    selectPopoverView = popoverView;
}

- (void)beModified:(id)sender property:(NSDictionary *)property
{
    NSEnumerator *enumerator = [property keyEnumerator];
    NSString *key;
    while (key = [enumerator nextObject])
    {
        
        BOOL isStringValue = [[property objectForKey:key] isMemberOfClass:[NSString class]];
        
        if (isStringValue && ([[self.item valueForKey:key] isEqualToString:[property objectForKey:key]])) {
            continue;
        }
        
        if ([self.item valueForKey:key] == [property objectForKey:key]) {
            continue;
        }
        
        [self.item setValue:[property objectForKey:key] forKey:key];
        [self reloadData];
        
        modified = YES;
    }
}

- (void)selectAll:(id)sender
{
    [self hideKeyboard];
    if ([mvTableView isAllSelected]) {
        [mvTableView deselectAll];
        [self switchSelectAllButton:NO];
    }
    else
    {
        [mvTableView selectAll];
        [self switchSelectAllButton:YES];
    }
}

- (void)removeSelected:(id)sender
{
    [self hideKeyboard];
    NSArray *removes = [mvTableView indexPathsForSelectedRows];
    BOOL removed;
    for (int i = [removes count] - 1; i >= 0; i--) {
        NSIndexPath *ip = [removes objectAtIndex:i];
        NSMutableArray *videos = [self.item.videos mutableCopy];
        [videos removeObjectAtIndex:ip.row];
        self.item.videos = videos;
        [self reloadData];
        removed = YES;
    }
    if (removed) {
        modified = YES;
        [mvTableView reloadData];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.item.videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MVCell"];
    if (!cell) {
        cell = [[MVCell alloc] init];
        cell.controller = self;
        cell.tableView = tableView;
    }
    MVItem *item = [self.item.videos objectAtIndex:indexPath.row];
    cell.item = item;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MVCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (mvTableView.editing) {
        if ([tableView isAllSelected]) {
            [self switchSelectAllButton:YES];
        }
    }
    else
    {
        [self playAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        [self switchSelectAllButton:NO];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - PopoverViewDelegate
- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    shareBtn.enabled = YES;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newCover = [info objectForKey:UIImagePickerControllerEditedImage];
    self.item.coverImage = newCover;
    outlineView.item = self.item;
    modified = YES;
    if (pickerPopover) {
        [pickerPopover dismissPopoverAnimated:YES];
        pickerPopover = nil;
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (pickerPopover) {
        [pickerPopover dismissPopoverAnimated:YES];
        pickerPopover = nil;
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == pickerPopover) {
        pickerPopover = nil;
    }
}

@end
