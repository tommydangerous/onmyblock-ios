//
//  OMBRenterApplicationViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationViewController.h"

#import "OMBAccountProfileViewController.h"
#import "OMBCenteredImageView.h"
#import "OMBCosignersListViewController.h"
#import "OMBEmploymentViewController.h"
#import "OMBGradientView.h"
#import "OMBLegalViewController.h"
#import "OMBPetsViewController.h"
#import "OMBPreviousRentalsListViewController.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBRenterApplicationViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
	if (!(self = [super init])) return nil;

  _user = object;

	self.screenName = self.title = @"Renter Application";

	return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
	[super loadView];

	CGRect screen = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;
  float screenHeight = screen.size.height;

  self.table.backgroundColor = [UIColor grayUltraLight];
  self.table.separatorColor = [UIColor grayLight];
  self.table.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.table.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, screenWidth, 44.0f)];
  self.table.tableFooterView.backgroundColor = [UIColor grayUltraLight];

  userProfileImageView = [[OMBCenteredImageView alloc] initWithFrame:
    CGRectMake(0, 0, screenWidth, screenHeight * 0.4f)];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  [userProfileImageView setImage: [OMBUser currentUser].image];
  [self reloadTable];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenWidth  = screen.size.width;
  float borderHeight = 0.5f;

  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:
    UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  // Row with the user's image
  if (indexPath.row == 0) {
    cell.contentView.backgroundColor = [UIColor blackColor];
    cell.selectedBackgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
    cell.textLabel.text = @"";
    [cell.contentView addSubview: userProfileImageView];
    OMBGradientView *gradient = [[OMBGradientView alloc] init];
    gradient.colors = @[
      [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.0],
        [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5]];
    gradient.frame = userProfileImageView.frame;
    [cell.contentView addSubview: gradient];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
      size: 27];
    nameLabel.frame = CGRectMake(20.0f, 
      userProfileImageView.frame.size.height - (36 + 20),
        userProfileImageView.frame.size.width - (20 * 2), 36.0f);
    nameLabel.text = [_user fullName];
    nameLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview: nameLabel];
  }
  else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
      [UIImage imageWithColor: [UIColor grayLight]]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
      size: 15];
    cell.textLabel.frame = CGRectMake(0, 0, 
      screenWidth, cell.textLabel.frame.size.height);
    cell.textLabel.textColor = [UIColor textColor];
    if (indexPath.section == 0) {
    	NSString *cellText;
      if (indexPath.row == 1) {
        cellText = @"Profile";
      }
      else if (indexPath.row == 2) {
        cellText = @"Co-signers";
      }      
      else if (indexPath.row == 3) {
        cellText = @"Pets";
      }
      else if (indexPath.row == 4) {
      	cellText = @"Previous Rentals";
      }
      else if (indexPath.row == 5) {
      	cellText = @"Employment";
      }
      else if (indexPath.row == 6) {
      	cellText = @"Legal";
      }
      cell.textLabel.text = cellText;
    }
  }
  if (indexPath.row == 1) {
    // Top border
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor grayLight].CGColor;
    border.frame = CGRectMake(0.0f, 0.0f,
      cell.contentView.frame.size.width, borderHeight);
    [cell.layer addSublayer: border];
  }
  if (indexPath.row == 
    [self tableView: self.table numberOfRowsInSection: 0] - 1) {
    // Bottom border
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor grayLight].CGColor;
    border.frame = CGRectMake(0.0f, 
      cell.contentView.frame.size.height - borderHeight,
        cell.contentView.frame.size.width, borderHeight);
    [cell.layer addSublayer: border];
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // The 1 is for the spacing
  if (section == 0) {
    return 1 + 6;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
	if (indexPath.section == 0) {
		// General Information
		if (indexPath.row == 1) {
			[self.navigationController pushViewController: 
				[[OMBAccountProfileViewController alloc] init] animated: YES];
		}
		// Co-signers
		else if (indexPath.row == 2) {
			[self.navigationController pushViewController:
				[[OMBCosignersListViewController alloc] initWithUser: _user] 
          animated: YES];
		}
		// Pets
		else if (indexPath.row == 3) {
			[self.navigationController pushViewController:
				[[OMBPetsViewController alloc] initWithUser: _user] animated: YES];
		}
		// Previous Rentals
		else if (indexPath.row == 4) {
			[self.navigationController pushViewController:
				[[OMBPreviousRentalsListViewController alloc] initWithUser: _user] 
          animated: YES];
		}
		// Employment
		else if (indexPath.row == 5) {
			[self.navigationController pushViewController:
				[[OMBEmploymentViewController alloc] init] animated: YES];
		}
		// Legal
		else if (indexPath.row == 6) {
			[self.navigationController pushViewController:
				[[OMBLegalViewController alloc] init] animated: YES];
		}
	}
  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenHeight = screen.size.height;
  if (indexPath.row == 0)
    return screenHeight * 0.4f;
  return 44.0f;
}

@end
