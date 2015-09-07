//
//  EditableMLParticularViewController.m
//  YYTHD
//
//  Created by 崔海成 on 12/19/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "EditableMLParticularViewController.h"
#import "MLDataController.h"
#import "NSError+YYTError.h"
#import "MVItem.h"

@interface EditableMLParticularViewController ()
{
    UIButton *editButton;
    void (^finalWriteML)(void);
    void (^finalCreateML)(void);
}
@end

@implementation EditableMLParticularViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        __weak EditableMLParticularViewController *weakSelf = self;
        
        finalWriteML = ^{
            MLItem *item = weakSelf.item;
            NSString *newCover = item.coverImage ? item.coverPic.absoluteString : @"";
            [[MLDataController sharedObject] updateMLWithID:item.keyID title:item.title descrip:item.description headImage:newCover backgroundImage:@"" videoData:item.videos completion:^(BOOL success, NSError *error) {
                [weakSelf writeMLSuccess:success error:error];
            }];
        };
        
        finalCreateML = ^{
            MLItem *item = weakSelf.item;
            MVItem *mv = [item.videos lastObject];
            NSString *videoString = [NSString stringWithFormat:@"%@", mv.keyID];
            [[MLDataController sharedObject] createMLWithTitle:item.title category:@"" tags:@"" description:item.description headImgURLString:item.coverPic.absoluteString vids:videoString completionBlock:^(MLItem *mlitem, NSError *err) {
                weakSelf.item = mlitem;
                [weakSelf createMLSuccess:(mlitem != nil) error:err];
                [weakSelf updateData];
            }];
        };
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    editButton = [self editButton];
    self.editing = self.editing;
    float margin = 10;
    editButton.origin = CGPointMake(self.view.bounds.size.width - margin - editButton.width,
                                    (kTopBarHeight - editButton.height) / 2);
    [self.topView addSubview:editButton];
}

- (void)btnBackClicked
{
    [self hideKeyboard];
    if (modified) {
        YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"你确定要放弃修改么？" confirmBlock:^{
            
            BOOL isCreateML = self.item.keyID == nil;
            
            if (isCreateML)
            {
                
                [AddMVToMLAssistantController sharedInstance].mvToAdd = nil;
                
            }
            
            [super btnBackClicked];
        }];
        [alert showInView:self.view];
    }
    else {
        [super btnBackClicked];
    }
}

- (UIButton *)editButton
{
    UIImage *image = [UIImage imageNamed:@"ml_edit"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"ml_edit_h"];
    [button setImage:image forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    return  button;
}

- (void)edit:(id)sender
{
    [self hideKeyboard];
    BOOL enterEditing = !self.editing;
    if (enterEditing) {
        self.editing = YES;
        [MobClick event:@"Edit" label:@"编辑我创建的悦单——悦单详情"];
    }
    else if (!modified) {
        self.editing = NO;
    }
    else {
        if (![self validateModify]) return;
        self.editing = NO;
        editButton.enabled = NO;
        YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"你确定要保存修改么？" confirmBlock:^{
            [self submit];
        }];
        [alert showInView:self.view];
    }
}

- (void)setEditing:(BOOL)editing
{
    UIImage *image;
    [super setEditing:editing];
    if (editing) {
        image = [UIImage imageNamed:@"ml_confirm"];
        [editButton setImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"ml_confirm_h"];
        [editButton setImage:image forState:UIControlStateHighlighted];
    }
    else {
        image = [UIImage imageNamed:@"ml_edit"];
        [editButton setImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"ml_edit_h"];
        [editButton setImage:image forState:UIControlStateHighlighted];
    }
}

- (BOOL)validateModify
{
    
    if (self.item.title == nil || [self.item.title isEqualToString:@""]) {
        [self alertMessage:@"悦单标题不能为空"];
        return NO;
    }
    if (self.item.title.length > 30) {
        [self alertMessage:@"悦单标题不能超过30个字符"];
        return NO;
    }
    if (self.item.description.length > 2000) {
        [self alertMessage:@"悦单描述不能超过2000个字符"];
        return NO;
    }
    return YES;
    
}

- (void)submit
{
    [self editCompletion];
    if (self.item.keyID) {
        [self writeML];
    }
    else
    {
        [self createML];
    }
}

- (void)writeML
{
    if (self.item.coverImage) {
        [self uploadCover:finalWriteML];
    }
    else {
        finalWriteML();
    }
}

- (void)uploadCover:(void (^)(void))completion
{
    __weak EditableMLParticularViewController *weakSelf = self;
    [[MLDataController sharedObject] uploadCoverImage:self.item.coverImage completionBlock:^(NSString *imageURL, NSError *error) {
        if (error) {
            [weakSelf alertMessage:[error yytErrorMessage]];
            return;
        }
        weakSelf.item.coverPic = [NSURL URLWithString:imageURL];
        if (completion) completion();
    }];
}

- (void)writeMLSuccess:(BOOL)success error:(NSError *)error
{
    if (success) {
        modified = NO;
        [AlertWithTip flashSuccessMessage:@"修改悦单成功"];
    }
    else {
        [self alertMessage:[error yytErrorMessage]];
        self.editing = YES;
    }
    editButton.enabled = YES;
}

- (void)createML
{
    
    if (self.item.coverImage)
    {
    
        [self uploadCover:^{
            
            [self uploadCover:finalCreateML];
            
        }];
        
    }
    else
    {
        
        finalCreateML();
        
    }
    
}

- (void)createMLSuccess:(BOOL)success error:(NSError *)err
{
    
    if (success)
    {
        
        modified = NO;
        
        [AlertWithTip flashSuccessMessage:@"创建悦单成功"];
        
    }
    else
    {
        
        [self alertMessage:[err yytErrorMessage]];
        
        self.editing = YES;
        
    }
    [AddMVToMLAssistantController sharedInstance].mvToAdd = nil;
    
    editButton.enabled = YES;
    
}

- (void)editCompletion
{
    
}

- (void)alertMessage:(NSString *)message
{
    YYTAlert *alert = [[YYTAlert alloc] initSureWithMessage:message delegate:nil];
    [alert showInView:self.view];
}

@end
