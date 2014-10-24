//
//  OMBFinishListingOpenHouseDatesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingOpenHouseDatesViewController.h"

#import "OMBFinishListingOpenHouseDateAddViewController.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBNavigationController.h"
#import "OMBOpenHouse.h"
#import "OMBOpenHouseDeleteConnection.h"
#import "OMBResidence.h"

@implementation OMBFinishListingOpenHouseDatesViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  CGRect rect = [@"Duration" boundingRectWithSize:
    CGSizeMake(9999, OMBStandardHeight) font: [UIFont normalTextFont]];
  sizeForLabelTextFieldCell = rect.size;
  self.screenName = self.title = @"Open House Dates";

  return self;
}

- (void) loadView
{
  [super loadView];

  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  UIBarButtonItem *addBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Add" 
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(addOpenHouseDate)];
  [addBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = addBarButtonItem;

  [self setupForTable];

  sheet = [[UIActionSheet alloc] initWithTitle: nil 
    delegate: self cancelButtonTitle: @"Cancel" 
      destructiveButtonTitle: @"Remove Date" otherButtonTitles: nil];
  [self.view addSubview: sheet];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self.table reloadData];
}

#pragma mark - Protocol

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  // Remove
  if (buttonIndex == 0) {
    [self.table beginUpdates];

    OMBOpenHouse *object = [[residence sortedOpenHouseDates] objectAtIndex:
      selectedIndexPath.section];
    // Delete Connection
    OMBOpenHouseDeleteConnection *conn = 
      [[OMBOpenHouseDeleteConnection alloc] initWithOpenHouse: object];
    [conn start];

    [residence.openHouseDates removeObject: object];
    [self.table deleteSections: 
      [NSIndexSet indexSetWithIndex: selectedIndexPath.section] 
        withRowAnimation: UITableViewRowAnimationFade];
    [self.table endUpdates];
    selectedIndexPath = nil;
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return [residence.openHouseDates count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Normal cell
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBLabelTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell) {
    cell = [[OMBLabelTextFieldCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    [cell setFrameUsingSize: sizeForLabelTextFieldCell];
  }
  cell.backgroundColor = [UIColor whiteColor];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textField.placeholderColor = [UIColor grayLight];
  cell.textField.placeholder = @"";
  cell.textField.text        = @"";
  cell.textField.userInteractionEnabled = NO;
  cell.textFieldLabel.text   = @"";

  UIView *topBorder = [cell.contentView viewWithTag: 9999];
  if (!topBorder) {
    topBorder = [UIView new];
    topBorder.backgroundColor = [UIColor grayLight];
    topBorder.frame = CGRectMake(0.0f, 0.0f, 
      tableView.frame.size.width, 0.5f);
    topBorder.tag = 9999;
  }
  [topBorder removeFromSuperview];

  UIView *bottomBorder = [cell.contentView viewWithTag: 9998];
  if (!bottomBorder) {
    bottomBorder = [UIView new];
    bottomBorder.backgroundColor = [UIColor grayLight];
    bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
      tableView.frame.size.width, 0.5f);
    bottomBorder.tag = 9998;
  }
  [bottomBorder removeFromSuperview];

  OMBOpenHouse *openHouse = [[residence sortedOpenHouseDates] objectAtIndex:
    indexPath.section];
  // Spacing
  if (indexPath.row == 0) {
    cell.backgroundColor = [UIColor clearColor];
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
  }
  // Starts
  else if (indexPath.row == 1) {
    NSDateFormatter *dateTimeFormatter = [NSDateFormatter new];
    dateTimeFormatter.dateFormat = @"MMMM d, yyyy   h:mm a";
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:
      openHouse.startDate];
    cell.textField.text = [dateTimeFormatter stringFromDate: startDate];
    cell.textFieldLabel.text = @"Starts";
    [cell.contentView addSubview: topBorder];
  }
  // Duration
  else if (indexPath.row == 2) {
    NSString *hoursString = @"hours";
    if (openHouse.duration == 1) {
      hoursString = @"hour";
    }
    cell.textField.text = [NSString stringWithFormat: @"%i %@", 
      openHouse.duration, hoursString];
    cell.textFieldLabel.text = @"Duration";
    [cell.contentView addSubview: bottomBorder];
  }
  cell.textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
    size: 15];
  cell.textField.textAlignment  = NSTextAlignmentRight;
  cell.textField.textColor      = [UIColor blueDark];
  cell.textFieldLabel.textColor = [UIColor textColor];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Spacing
  // Start date
  // Duration
  return 3;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  selectedIndexPath = indexPath;
  [sheet showInView: self.view];
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 44.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addOpenHouseDate
{
  [self presentViewController: 
    [[OMBNavigationController alloc] initWithRootViewController: 
      [[OMBFinishListingOpenHouseDateAddViewController alloc] initWithResidence:
        residence]] animated: YES completion: nil];
}

@end
