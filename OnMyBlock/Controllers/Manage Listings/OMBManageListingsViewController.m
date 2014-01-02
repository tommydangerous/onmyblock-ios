//
//  OMBManageListingsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBManageListingsViewController.h"

#import "AMBlurView.h"
#import "OMBFinishListingViewController.h"
#import "OMBManageListingsCell.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBManageListingsViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Manage Listings";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  [self setMenuBarButtonItem];

  [self setupForTable];

  self.table.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);

  // Publish Now view
  createListingView = [[AMBlurView alloc] init];
  createListingView.backgroundColor = [UIColor colorWithWhite: 1.0f 
    alpha: 0.95f];
  CGFloat createListingViewHeight = 44.0f;
  CGFloat createListingViewWidth = screen.size.width * 0.5f;
  createListingView.frame = CGRectMake(
    (screen.size.width - createListingViewWidth) * 0.5f, 
      screen.size.height - (createListingViewHeight + padding), 
        createListingViewWidth, createListingViewHeight);
  createListingView.layer.borderColor = [UIColor blue].CGColor;
  createListingView.layer.borderWidth = 1.0f;
  createListingView.layer.cornerRadius = 
    createListingView.frame.size.height * 0.5f;
  [self.view addSubview: createListingView];

  // Publish Now button
  createListingButton = [UIButton new];
  createListingButton.frame = CGRectMake(0.0f, 0.0f, 
    createListingView.frame.size.width, createListingView.frame.size.height);
  createListingButton.titleLabel.font = 
    [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  [createListingButton addTarget: self action: @selector(createListing)
    forControlEvents: UIControlEventTouchUpInside];
  [createListingButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blue]] 
      forState: UIControlStateHighlighted];
  [createListingButton setTitle: @"Create Listing" 
    forState: UIControlStateNormal];
  [createListingButton setTitleColor: [UIColor blue] 
    forState: UIControlStateNormal];
  [createListingButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateHighlighted];
  [createListingView addSubview: createListingButton];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBManageListingsCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[OMBManageListingsCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  [cell loadResidenceData: nil];
  if (indexPath.row == 0) {
    [cell setStatusLabelText: @"7d 12h"];
    cell.statusLabel.textColor = [UIColor green];
  }
  else if (indexPath.row == 1) {
    [cell setStatusLabelText: @"Unlisted"];
    cell.statusLabel.textColor = [UIColor red];
  }
  else if (indexPath.row == 2) {
    [cell setStatusLabelText: @"6 steps"]; 
    cell.statusLabel.textColor = [UIColor blueDark];
  }
  else if (indexPath.row == 3) {
    [cell setStatusLabelText: @"Inactive"];
    cell.statusLabel.textColor = [UIColor grayMedium];
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [[self listings] count];
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.navigationController pushViewController:
    [[OMBFinishListingViewController alloc] initWithResidence: nil]
      animated: YES];
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [OMBManageListingsCell heightForCell];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) createListing
{
  [[self appDelegate].container showCreateListing];
}

- (NSArray *) listings
{
  return @[@"1", @"2", @"3", @"4"];
}

@end
