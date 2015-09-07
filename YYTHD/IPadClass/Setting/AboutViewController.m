//
//  AboutViewController.m
//  YYTHD
//
//  Created by shuilin on 11/6/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
{
    
}
- (IBAction)clickTest:(id)sender;
@end

@implementation AboutViewController

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
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"YYTHD-Info" ofType:@"plist"];
//    NSArray *dict = [NSArray arrayWithContentsOfFile:path];
    self.view.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"contentBackground"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = image;
    [self.view insertSubview:backgroundImageView atIndex:0];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.versionLabel.text = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickTest:(id)sender
{
   
}

@end
