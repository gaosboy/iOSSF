//
//  SFSlideNavViewController.m
//  SegmentFault
//
//  Created by jiajun on 11/26/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFLoginService.h"
#import "SFSlideNavViewController.h"
#import "UMNavigationController.h"
#import "UMViewController.h"
#import "SFAppDelegate.h"

@interface SFSlideNavViewController ()
<UITableViewDataSource, UITableViewDelegate>

- (void)login;
- (void)logout;

// 记录ViewController已经被载入过
@property (nonatomic, strong)   NSMutableSet  *loadedRootViewControllers;

@end

@implementation SFSlideNavViewController

#pragma mark - private

- (void)logout
{
    [SFLoginService logout];
    [self showItemAtIndex:[NSIndexPath indexPathForRow:0 inSection:0] withAnimation:YES];

    [self.items[0] removeObject:[SFTools applicationDelegate].userProfileNavigator];
    [self.items[0] removeObject:[SFTools applicationDelegate].followedQuestionsNavigator];
    [self.items[0] removeObject:[SFTools applicationDelegate].logoutNavigator];
    [self.items[0] removeObject:[SFTools applicationDelegate].loginNavigator];

    [self.items[0] addObject:[SFTools applicationDelegate].loginNavigator];

    [self.slideView reloadData];
}

- (void)login
{    
    [self performSelector:@selector(slideButtonClicked) withObject:nil afterDelay:0.3f];
    [self showItemAtIndex:[NSIndexPath indexPathForRow:0 inSection:0] withAnimation:NO];

    [self.items[0] removeObject:[SFTools applicationDelegate].userProfileNavigator];
    [self.items[0] removeObject:[SFTools applicationDelegate].followedQuestionsNavigator];
    [self.items[0] removeObject:[SFTools applicationDelegate].logoutNavigator];
    [self.items[0] removeObject:[SFTools applicationDelegate].loginNavigator];

    [self.items[0] addObject:[SFTools applicationDelegate].followedQuestionsNavigator];
    [self.items[0] addObject:[SFTools applicationDelegate].userProfileNavigator];
    [self.items[0] addObject:[SFTools applicationDelegate].logoutNavigator];

    [self.slideView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UMSlideNavigationControllerSlideViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_cell_bg.png"]];
        UIImageView *chevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_cell_arrow.png"]];;

        bg.frame = CGRectMake(0.0f, 0.0f, 320.0f, CELL_HEIGHT);
        chevron.frame = CGRectMake(235.0f, 14.0f, 15.0f, 15.0f);
        [bg addSubview:chevron];
        cell.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_cell_bg_active.png"]];
        selectedBg.frame = CGRectMake(0.0f, 0.0f, 320.0f, CELL_HEIGHT);
        UIImageView *selectedChevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_cell_arrow_active.png"]];
        selectedChevron.frame = CGRectMake(235.0f, 14.0f, 15.0f, 15.0f);
        [selectedBg addSubview:selectedChevron];
        cell.selectedBackgroundView = selectedBg;
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    }
    
    cell.textLabel.text = [(UIViewController *)self.items[indexPath.section][indexPath.row] title];

    [tableView selectRowAtIndexPath:self.currentIndex animated:NO scrollPosition:UITableViewRowAnimationTop];
    if ([indexPath isEqual:self.currentIndex]) {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else {
        cell.textLabel.textColor = RGBCOLOR(187, 187, 187);
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([SFLoginService isLogin]
        && [self.items[indexPath.section][indexPath.row] isEqual:[SFTools applicationDelegate].logoutNavigator]) {
        [self logout];
    }
    else {
        [self showItemAtIndex:indexPath withAnimation:YES];
        UMNavigationController *currentNav = (UMNavigationController *)self.items[indexPath.section][indexPath.row];
        UMViewController *currentVC = (UMViewController *)[[currentNav viewControllers] lastObject];
        if ([indexPath isEqual:self.currentIndex]) {
            [currentVC viewDidLoad];
        }
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = RGBCOLOR(187, 187, 187);
}

#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    self.slideView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.slideView.backgroundColor = RGBCOLOR(51, 51, 51);
    
    self.slideView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.slideView.width, 64.0f)];
    UILabel *segment = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 230.0f, 30.0f)];
    segment.backgroundColor = [UIColor clearColor];
    segment.font = [UIFont boldSystemFontOfSize:28.0f];
    segment.textColor = [UIColor whiteColor];
    segment.shadowOffset = CGSizeMake(0.0f, 1.0f);
    segment.shadowColor = [UIColor blackColor];
    segment.text = @"segment";
    [segment sizeToFit];
    [self.slideView.tableHeaderView addSubview:segment];
    UILabel *fault = [[UILabel alloc] initWithFrame:CGRectMake(segment.right, segment.top, 230.0f, 34.0f)];
    fault.backgroundColor = [UIColor clearColor];
    fault.font = [UIFont boldSystemFontOfSize:28.0f];
    fault.textColor = RGBCOLOR(0, 153, 101);
    fault.shadowOffset = CGSizeMake(0.0f, 1.0f);
    fault.shadowColor = [UIColor blackColor];
    fault.text = @"fault";
    [fault sizeToFit];
    [self.slideView.tableHeaderView addSubview:fault];

    self.slideView.tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_cell_bg.png"]];
    
    if (nil == self.loadedRootViewControllers) {
        self.loadedRootViewControllers = [[NSMutableSet alloc] initWithObjects:self.items[self.currentIndex.section][self.currentIndex.row], nil];
    }
}

@end
