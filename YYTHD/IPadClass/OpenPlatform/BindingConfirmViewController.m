//
//  BindingViewController.m
//  YYTHD
//
//  Created by 崔海成 on 11/7/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "BindingConfirmViewController.h"

@interface BindingConfirmViewController ()
{
    void (^confirmBlock)();
}

- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)okBtnClicked:(id)sender;

@end

@implementation BindingConfirmViewController

- (id)initWithConfirmBlock:(void (^)())confirm
{
    self = [self init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        confirmBlock = confirm;
    }
    return self;
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtnClicked:(id)sender {
    confirmBlock = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)okBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:confirmBlock];
}
@end
