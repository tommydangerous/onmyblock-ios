//
//  OMBManageListingDetailViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBManageListingDetailViewController.h"

#import "OMBCenteredImageView.h"

@interface OMBManageListingDetailViewController ()
{
  OMBCenteredImageView *backgroundImageView;
}

@end

@implementation OMBManageListingDetailViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"Listing";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  CGRect screen = [self screen];
  backgroundImageView = [[OMBCenteredImageView alloc] init];
  backgroundImageView.image = [UIImage imageNamed:
    @"neighborhood_university_towne_center.jpg"];
  backgroundImageView.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, screen.size.height * 0.4f);
  [self setupBackgroundWithView: backgroundImageView
    startingOffsetY: OMBPadding + OMBStandardHeight];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  return [[UITableViewCell alloc] initWithStyle:
    UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return 10;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 100.0f;
}

@end
