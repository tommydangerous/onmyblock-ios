//
//  OMBRenterApplicationViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/30/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationViewController.h"

#import "OMBCoApplicantsViewController.h"
#import "OMBCoSignersViewController.h"
#import "OMBEmploymentViewController.h"
#import "OMBGeneralInformationViewController.h"
#import "OMBLegalViewController.h"
#import "OMBPetsViewController.h"
#import "OMBPreviousRentalsViewController.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@implementation OMBRenterApplicationViewController

#pragma mark - Initializer

- (id) init
{
	if (!(self = [super init])) return nil;

	self.screenName = [NSString stringWithFormat: @"Renter Application - User ID: %i",
		[OMBUser currentUser].uid];
	self.title = @"Renter Application";

	return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
	[super loadView];

	CGRect screen = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;

  self.table.backgroundColor = [UIColor grayUltraLight];
  self.table.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, screenWidth, 44.0f)];
  self.table.tableFooterView.backgroundColor = [UIColor clearColor];
  // Bottom border
  CALayer *borderTop = [CALayer layer];
  borderTop.backgroundColor = [UIColor grayLight].CGColor;
  borderTop.frame = CGRectMake(0.0f, 0.0f, screenWidth, 0.5f);
  [self.table.tableFooterView.layer addSublayer: borderTop];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;
  float borderHeight = 0.5;

  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  }
  if (indexPath.row == 0) {
    // Bottom border
    CALayer *borderBottom = [CALayer layer];
    borderBottom.backgroundColor = [UIColor grayLight].CGColor;
    borderBottom.frame = CGRectMake(0.0f, 
      ([self tableView: self.table 
      heightForRowAtIndexPath: indexPath] - borderHeight), 
        screenWidth, borderHeight);
    [cell.contentView.layer addSublayer: borderBottom];
    if (indexPath.section != 0) {
      // Top border
      CALayer *borderTop = [CALayer layer];
      borderTop.backgroundColor = borderBottom.backgroundColor;
      borderTop.frame = CGRectMake(0.0f, 0.0f, 
        borderBottom.frame.size.width, borderBottom.frame.size.height);
      [cell.contentView.layer addSublayer: borderTop];
    }
    cell.contentView.backgroundColor = self.table.backgroundColor;
    cell.selectedBackgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
  }
  else {
    // If not the last row
    if (indexPath.row != [self tableView: self.table 
      numberOfRowsInSection: indexPath.section] - 1) {
      // Bottom border
      CALayer *borderBottom = [CALayer layer];
      borderBottom.backgroundColor = [UIColor grayLight].CGColor;
      borderBottom.frame = CGRectMake(15.0f, 
        ([self tableView: self.table 
        heightForRowAtIndexPath: indexPath] - borderHeight), 
          (screenWidth - 15.0f), borderHeight);
      [cell.contentView.layer addSublayer: borderBottom];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:
      [UIImage imageWithColor: [UIColor grayLight]]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" 
      size: 15];
    cell.textLabel.textColor = [UIColor textColor];
    if (indexPath.section == 0) {
    	NSString *cellText;
      if (indexPath.row == 1) {
        cellText = @"General Information";
      }
      else if (indexPath.row == 2) {
        cellText = @"Co-signers";
      }
      else if (indexPath.row == 3) {
        cellText = @"Co-applicants";
      }
      else if (indexPath.row == 4) {
        cellText = @"Pets";
      }
      else if (indexPath.row == 5) {
      	cellText = @"Previous Rentals";
      }
      else if (indexPath.row == 6) {
      	cellText = @"Employment";
      }
      else if (indexPath.row == 7) {
      	cellText = @"Legal";
      }
      cell.textLabel.text = cellText;
    }
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // The 1 is for the spacing
  if (section == 0) {
    return 1 + 7;
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
				[[OMBGeneralInformationViewController alloc] init] animated: YES];
		}
		// Co-signers
		else if (indexPath.row == 2) {
			[self.navigationController pushViewController:
				[[OMBCoSignersViewController alloc] init] animated: YES];
		}
		// Co-applicants
		else if (indexPath.row == 3) {
			[self.navigationController pushViewController:
				[[OMBCoApplicantsViewController alloc] init] animated: YES];
		}
		// Pets
		else if (indexPath.row == 4) {
			[self.navigationController pushViewController:
				[[OMBPetsViewController alloc] init] animated: YES];
		}
		// Previous Rentals
		else if (indexPath.row == 5) {
			[self.navigationController pushViewController:
				[[OMBPreviousRentalsViewController alloc] init] animated: YES];
		}
		// Employment
		else if (indexPath.row == 6) {
			[self.navigationController pushViewController:
				[[OMBEmploymentViewController alloc] init] animated: YES];
		}
		// Legal
		else if (indexPath.row == 7) {
			[self.navigationController pushViewController:
				[[OMBLegalViewController alloc] init] animated: YES];
		}
	}
  [self.table deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 44.0f;
}

@end
