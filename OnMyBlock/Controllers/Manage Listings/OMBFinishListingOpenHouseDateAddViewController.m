//
//  OMBFinishListingOpenHouseDateAddViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingOpenHouseDateAddViewController.h"

#import "OMBActivityView.h"
#import "OMBDatePickerCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBOpenHouse.h"
#import "OMBOpenHouseCreateConnection.h"
#import "OMBResidence.h"
#import "OMBViewControllerContainer.h"
#import "TextFieldPadding.h"

@implementation OMBFinishListingOpenHouseDateAddViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  openHouse = [[OMBOpenHouse alloc] init];
  openHouse.duration  = 1;
  openHouse.startDate = [[NSDate date] timeIntervalSince1970];
  residence = object;

  self.screenName = self.title = @"Add Open House";

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillShow:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillHide:)
      name: UIKeyboardWillHideNotification object: nil];

  return self;
}

- (void) loadView
{
  [super loadView];

  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];

  cancelBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel" 
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(cancel)];
  self.navigationItem.leftBarButtonItem = cancelBarButtonItem;

  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done" 
    style: UIBarButtonItemStylePlain target: self 
      action: @selector(done)];
  [doneBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];

  saveBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Save" 
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(save)];
  [saveBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  [self setupForTable];

  self.table.tableHeaderView = [[UIView alloc] initWithFrame: 
    CGRectMake(0.0f, 0.0f, self.table.frame.size.width, 44.0f)];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Fields
  // Bottom spacing
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  OMBLabelTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[OMBLabelTextFieldCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textField.placeholderColor = [UIColor grayLight];
  cell.textField.placeholder = @"";
  cell.textField.text        = @"";
  cell.textFieldLabel.text   = @"";
  
  if (indexPath.section == 0) {
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
    // Start Date
    if (indexPath.row == 0) {
      NSDateFormatter *dateTimeFormatter = [NSDateFormatter new];
      dateTimeFormatter.dateFormat = @"MMMM d, yyyy   h:mm a";
      cell.textField.text = [dateTimeFormatter stringFromDate: [NSDate date]];
      cell.textField.userInteractionEnabled = NO;
      cell.textFieldLabel.text = @"Starts";

      [cell.contentView addSubview: topBorder];
    }
    // Date picker
    else if (indexPath.row == 1) {
      // Date picker cell
      static NSString *DatePickerCellIdentifier = 
        @"DatePickerCellIdentifier";
      OMBDatePickerCell *datePickerCell = 
        [tableView dequeueReusableCellWithIdentifier:
          DatePickerCellIdentifier];
      if (!datePickerCell)
        datePickerCell = [[OMBDatePickerCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: 
            DatePickerCellIdentifier];
      [datePickerCell.datePicker addTarget: self 
        action: @selector(datePickerChanged:)
          forControlEvents: UIControlEventValueChanged];
      datePickerCell.datePicker.datePickerMode = UIDatePickerModeDateAndTime;

      return datePickerCell;
    }
    // Duration
    else if (indexPath.row == 2) {
      cell.textField.delegate = self;
      cell.textField.indexPath = indexPath;
      cell.textField.keyboardType = UIKeyboardTypeNumberPad;
      cell.textField.placeholder = @"in hours";
      cell.textField.text = @"";
      cell.textField.userInteractionEnabled = YES;
      [cell.textField addTarget: self action: @selector(textFieldDidChange:)
        forControlEvents: UIControlEventEditingChanged];
      cell.textFieldLabel.text = @"Duration";

      [cell.contentView addSubview: bottomBorder];
    }
    cell.textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
      size: 15];
    cell.textField.textAlignment  = NSTextAlignmentRight;
    cell.textField.textColor      = [UIColor blueDark];
    cell.textFieldLabel.textColor = [UIColor textColor];
    [cell setFramesUsingString: @"Duration"];
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Start date
  // Date picker
  // Duration
  if (section == 0)
    return 3;
  // Bottom spacing
  else if (section == 1)
    return 1;
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.section == 0) {
    // Date picker
    if (indexPath.row == 1) {
      return 216.0f;
    }
    return 44.0f;
  }
  else if (indexPath.section == 1) {
    if (isEditing)
      return 216.0f;
  }
  return 0.0f;
}

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];

  TextFieldPadding *t = (TextFieldPadding *) textField;
  [self.table scrollToRowAtIndexPath: t.indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancel
{
  [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) datePickerChanged: (UIDatePicker *) datePicker
{
  NSDateFormatter *dateTimeFormatter = [NSDateFormatter new];
    dateTimeFormatter.dateFormat = @"MMMM d, yyyy   h:mm a";

  OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *) 
    [self.table cellForRowAtIndexPath:
      [NSIndexPath indexPathForRow: 0 inSection: 0]];
  cell.textField.text = [dateTimeFormatter stringFromDate: datePicker.date];

  openHouse.startDate = [datePicker.date timeIntervalSince1970];
}

- (void) done
{
  [self.view endEditing: YES];
}

- (void) keyboardWillHide: (NSNotification *) notification
{
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
}

- (void) keyboardWillShow: (NSNotification *) notification
{
  
}

- (void) save
{
  [[self appDelegate].container startSpinning];
  // OMBActivityView *activityView = [[OMBActivityView alloc] init];
  // [self.view addSubview: activityView];
  // [activityView startSpinning];

  OMBOpenHouseCreateConnection *conn = 
    [[OMBOpenHouseCreateConnection alloc] initWithResidence: residence
      openHouse: openHouse];
  conn.completionBlock = ^(NSError *error) {
    if (error) {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error" 
        message: error.localizedDescription delegate: nil 
          cancelButtonTitle: @"Try again"
            otherButtonTitles: nil];
      [alertView show];
    }
    else {
      [residence addOpenHouse: openHouse];
      [self cancel];
    }
    [[self appDelegate].container stopSpinning];
    // [activityView stopSpinning];
  };
  [conn start];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  openHouse.duration = [textField.text intValue];
}

@end
