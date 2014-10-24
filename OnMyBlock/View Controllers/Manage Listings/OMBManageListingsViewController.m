//
//  OMBManageListingsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBManageListingsViewController.h"

#import "AMBlurView.h"
#import "OMBActivityViewFullScreen.h"
#import "OMBCreateListingViewController.h"
#import "OMBFinishListingViewController.h"
#import "OMBManageListingDetailViewController.h"
#import "OMBManageListingsCell.h"
#import "OMBManageListingsConnection.h"
#import "OMBResidence.h"
#import "OMBTemporaryResidence.h"
#import "OMBUser.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"
#import "UIImage+Color.h"

@interface OMBManageListingsViewController ()
{
  UIButton *createListingButton;
  AMBlurView *createListingView;
  NSMutableArray *imagesArray;
}

@end

@implementation OMBManageListingsViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Listings";

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
  // createListingButton.layer.shadowColor = [UIColor textColor].CGColor;
  // createListingButton.layer.shadowOffset = CGSizeMake(10.0f, 15.0f);
  // createListingButton.layer.shadowOpacity = 0.8f;
  // createListingButton.layer.shadowRadius = 15.0f;
  [self.view addSubview: createListingView];

  // Publish Now button
  createListingButton = [UIButton new];
  createListingButton.frame = CGRectMake(0.0f, 0.0f,
    createListingView.frame.size.width, createListingView.frame.size.height);
  createListingButton.titleLabel.font = [UIFont normalTextFontBold];
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

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  BOOL isEmpty = [[self listings] count] == 0;

  OMBManageListingsConnection *conn =
    [[OMBManageListingsConnection alloc] init];
  conn.completionBlock = ^(NSError *error) {
    if (isEmpty) {
      [self containerStopSpinningFullScreen];
    }
    else {
      [self containerStopSpinning];
    }
    [self.table reloadData];
  };
  if (isEmpty) {
    [self containerStartSpinningFullScreen];
  }
  else {
    [self containerStartSpinning];
  }
  
  [conn start];

  imagesArray = [NSMutableArray array];

  [self.table reloadData];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger row     = indexPath.row;
  NSUInteger section = indexPath.section;
  if (section == OMBManageListingsSectionListings) {
    static NSString *CellIdentifier = @"CellIdentifier";
    OMBManageListingsCell *cell = [tableView dequeueReusableCellWithIdentifier:
      CellIdentifier];
    if (!cell)
      cell = [[OMBManageListingsCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    [cell loadResidenceData: [[self listings] objectAtIndex: row]];
    cell.clipsToBounds = YES;
    return cell;
  }
  else if (section == OMBManageListingsSectionSpacing) {
    static NSString *EmptyID = @"EmptyID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
      EmptyID];
    if (!cell)
      cell = [[UITableViewCell alloc] initWithStyle:
        UITableViewCellStyleDefault reuseIdentifier: EmptyID];
    cell.backgroundColor = [UIColor clearColor];
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
    return cell;
  }
  return [[UITableViewCell alloc] init];
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (section == OMBManageListingsSectionListings)
    return [[self listings] count];
  else if (section == OMBManageListingsSectionSpacing)
    return 1;
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didEndDisplayingCell: (UITableViewCell *) cell
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  // [(OMBManageListingsCell *) cell clearImage];
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger section = indexPath.section;
  if (section == OMBManageListingsSectionListings) {
    id residence = [[self listings] objectAtIndex: indexPath.row];
    // If temporary residence, show finish listing
    if ([residence isKindOfClass: [OMBTemporaryResidence class]]) {
      [self.navigationController pushViewController:
        [[OMBFinishListingViewController alloc] initWithResidence:
          residence] animated: YES];
    }
    // If residence, show manage listing detail
    else {
      [self.navigationController pushViewController:
        [[OMBManageListingDetailViewController alloc] initWithResidence:
          residence] animated: YES];
    }
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSUInteger section = indexPath.section;
  if (section == OMBManageListingsSectionListings)
    return [OMBManageListingsCell heightForCell];
  else if (section == OMBManageListingsSectionSpacing)
    return OMBPadding + createListingView.frame.size.height + OMBPadding;
  return 0.0f;
}

- (void) tableView: (UITableView *) tableView
willDisplayCell: (UITableViewCell *) cell
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  // if ([[self listings] count]) {
  //   [(OMBManageListingsCell *) cell loadResidenceData:
  //     [[self listings] objectAtIndex: indexPath.row]];
  // }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) createListing
{
  [self.navigationController pushViewController:
    [[OMBCreateListingViewController alloc] init] animated: YES];
  //[[self appDelegate].container showCreateListing];
}

- (NSArray *) listings
{
  // Use this for fake data
  // return @[[OMBResidence fakeResidence]];
  return [[OMBUser currentUser] residencesSortedWithKey: @"createdAt"
    ascending: NO];
}

@end
