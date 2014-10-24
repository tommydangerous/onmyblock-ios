//
//  OMBHomebaseRenterAddRemoveRoommatesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/7/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterAddRemoveRoommatesViewController.h"

#import "AMBlurView.h"
#import "OMBAlertView.h"
#import "OMBHomebaseRenterAddRemoveRoommatesOptionCell.h"
#import "OMBHomebaseRenterAddRemoveRoommatesRoommateCell.h"
#import "OMBHomebaseRenterAddRoommateFromEmailViewController.h"
#import "OMBHomebaseRenterAddRoommatesViewController.h"
#import "UIColor+Extensions.h"

@implementation OMBHomebaseRenterAddRemoveRoommatesViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = self.title = @"Add/Remove Roommates";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setupForTable];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
}

#pragma mark - Protocol

#pragma mark - UIAlertViewDelegate Protocol

- (void) alertView: (UIAlertView *) alertView 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  // Yes
  if (buttonIndex == 1) {
    NSLog(@"REMOVE %i", removeRoommateIndex);
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Roommates
  // Add Roommates
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  // Roommates
  if (indexPath.section == 0) {
    static NSString *RoommateCellIdentifier = @"RoommateCellIdentifier";
    OMBHomebaseRenterAddRemoveRoommatesRoommateCell *cell1 = 
      [tableView dequeueReusableCellWithIdentifier: RoommateCellIdentifier];
    if (!cell1)
      cell1 = [[OMBHomebaseRenterAddRemoveRoommatesRoommateCell alloc] 
        initWithStyle: UITableViewCellStyleDefault
          reuseIdentifier: RoommateCellIdentifier];
    cell1.removeButton.tag = indexPath.row;
    [cell1 loadData];
    [cell1.removeButton addTarget: self 
      action: @selector(removeButtonSelected:) 
        forControlEvents: UIControlEventTouchUpInside];
    return cell1;
  }
  // Add Roommates
  else if (indexPath.section == 1) {
    static NSString *OptionCellIdentifier = @"OptionCellIdentifier";
    OMBHomebaseRenterAddRemoveRoommatesOptionCell *cell1 = 
      [tableView dequeueReusableCellWithIdentifier: OptionCellIdentifier];
    if (!cell1)
      cell1 = [[OMBHomebaseRenterAddRemoveRoommatesOptionCell alloc] 
        initWithStyle: UITableViewCellStyleDefault
          reuseIdentifier: OptionCellIdentifier];
    // OnMyBlock
    if (indexPath.row == 0) {
      [cell1 setupForOnMyBlock];
    }
    // Facebook
    else if (indexPath.row == 1) {
      [cell1 setupForFacebook];
    }
    // Contacts
    else if (indexPath.row == 2) {
      [cell1 setupForContacts];
    }
    // Email
    else if (indexPath.row == 3) {
      [cell1 setupForEmail];
    }
    return cell1;
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Roommates
  if (section == 0) {
    return 3;
  }
  // Add Roommates
  else if (section == 1) {
    // From OnMyBlock
    // From Facebook
    // From Contacts
    // From Email
    return 4;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Add Roommates
  if (indexPath.section == 1) {
    OMBHomebaseRenterAddRoommatesViewController *vc =
      [[OMBHomebaseRenterAddRoommatesViewController alloc] init];
    if (indexPath.row < 3) {
      // OnMyBlock
      if (indexPath.row == 0) {
        [vc searchFromOnMyBlock]; 
      }
      // Facebook
      else if (indexPath.row == 1) {
        [vc searchFromFacebook]; 
      }
      // Contacts
      else if (indexPath.row == 2) {
        [vc searchFromContacts]; 
      }
      [self.navigationController pushViewController: vc animated: YES];
    }
    // Email
    else if (indexPath.row == 3) {
      [self.navigationController pushViewController: 
        [[OMBHomebaseRenterAddRoommateFromEmailViewController alloc] init]
          animated: YES]; 
    }
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForHeaderInSection: (NSInteger) section
{
  return 13.0f * 2;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Roommates
  if (indexPath.section == 0) {
    return [OMBHomebaseRenterAddRemoveRoommatesRoommateCell heightForCell];
  }
  // Add Roommates 
  else if (indexPath.section == 1) {
    return [OMBHomebaseRenterAddRemoveRoommatesOptionCell heightForCell];
  }
  return 0.0f;
}

- (UIView *) tableView: (UITableView *) tableView 
viewForHeaderInSection: (NSInteger) section
{
  CGFloat padding = 20.0f;
  AMBlurView *blurView = [[AMBlurView alloc] init];
  blurView.blurTintColor = [UIColor blueLight];
  blurView.frame = CGRectMake(0.0f, 0.0f, 
    tableView.frame.size.width, 13.0f * 2);
  UILabel *label = [UILabel new];
  label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 13];
  label.frame = CGRectMake(padding, 0.0f, 
    blurView.frame.size.width - (padding * 2), blurView.frame.size.height);
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor blueDark];
  [blurView addSubview: label];
  NSString *titleString = @"";
  // Roommates
  if (section == 0) {
    titleString = @"Roommates";
  }
  // Add Roommates
  else if (section == 1) {
    titleString = @"Add Roommates";
  }
  label.text = titleString;
  return blurView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) removeButtonSelected: (UIButton *) button
{
  removeRoommateIndex = button.tag;

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: 
    @"Remove Roommate" message: @"Are you sure?" delegate: self
      cancelButtonTitle: @"No" otherButtonTitles: @"Yes", nil];
  [alertView show]; 
}

@end
