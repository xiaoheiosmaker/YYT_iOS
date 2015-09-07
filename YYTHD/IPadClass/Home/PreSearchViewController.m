//
//  PreSearchViewController.m
//  YYTHD
//
//  Created by ssj on 13-11-2.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "PreSearchViewController.h"
#import "ArtistMVCell.h"
#import "SearchCell.h"

@interface PreSearchViewController ()

@end

@implementation PreSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.backImageView.image = [UIImage imageNamed:@"search_tableView_background"];
        [self.view addSubview:self.backImageView];
        
        self.searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.searchTableView.delegate = self;
        self.searchTableView.hidden = YES;
        self.searchTableView.dataSource = self;
        self.searchTableView.backgroundColor = [UIColor clearColor];
        self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataArray = [[NSArray alloc] init];
//        self.searchTableView.bounces = NO;
//        self.searchTableView.backgroundView = [[UIImageView alloc] initWithImage:IMAGE(@"Search_Cell_Background")];
       
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirst = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (self.isHistory) {
    //        return 10;
    //    }else{
    return self.dataArray.count;
    //    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"SearchCell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil] lastObject];
    }
    cell.contentLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.contentLabel.font = [UIFont systemFontOfSize:12];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
//    cell.backgroundView.image = IMAGE(@"Search_Cell_Background");
//    cell.backgroundImageView.alpha = 0.5;
    if (indexPath.row == (self.dataArray.count - 1)) {
        cell.lineBreadImage.hidden = YES;

    }else{
        cell.lineBreadImage.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = (SearchCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (_delegate && [_delegate respondsToSelector:@selector(searchText:)]) {
        [_delegate searchText:cell.contentLabel.text];
    }
}


@end
