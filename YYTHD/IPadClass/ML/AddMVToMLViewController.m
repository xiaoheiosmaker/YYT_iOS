//
//  AddMVToMLViewController.m
//  YYTHD
//
//  Created by 崔海成 on 10/30/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "AddMVToMLViewController.h"
#import "MLItem.h"
#import "MLDataController.h"
#import "UIColor+Generator.h"
#import "SystemSupport.h"

@interface AddMVToMLViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mlListTableView;
- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)addToNewML:(id)sender;

@end

@implementation AddMVToMLViewController
@synthesize mlList = _mlList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.mlList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mlListTableView.dataSource = self;
    self.mlListTableView.delegate = self;
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    self.mlListTableView.backgroundColor = [UIColor clearColor];
    self.mlListTableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.15];
    BOOL isIos7 = ![SystemSupport versionPriorTo7];
    if (isIos7)
        self.mlListTableView.separatorInset = UIEdgeInsetsZero;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSRange range = NSMakeRange(0, 500);
    void (^completionBlock)(NSArray *, NSError *) = ^(NSArray *list, NSError *error) {
        if (!error) {
            self.mlList = [list mutableCopy];
            [self.mlListTableView reloadData];
        } else {
            [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
        }
    };
    NSArray *list = [[MLDataController sharedObject] fetchOwnMLListForRange:range completion:completionBlock];
    if (list) {
        completionBlock(list, nil);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate addMVToMLViewController:self selectedML:nil];
    }];
}

- (IBAction)addToNewML:(id)sender {
    MLItem *newML = [[MLItem alloc] init];
    [self.delegate addMVToMLViewController:self selectedML:newML];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mlList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor yytGreenColor];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:11];
        cell.highlighted = NO;
        cell.selectedBackgroundView = backView;
    }
    cell.textLabel.text = @"";
    MLItem *ml = [self.mlList objectAtIndex:indexPath.row];
    cell.textLabel.text = ml.title;
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLItem *ml = [self.mlList objectAtIndex:indexPath.row];
    [self.delegate addMVToMLViewController:self selectedML:ml];
}

@end
