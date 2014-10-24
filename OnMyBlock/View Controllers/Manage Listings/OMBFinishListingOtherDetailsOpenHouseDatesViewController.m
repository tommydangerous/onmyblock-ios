//
//  OMBFinishListingOtherDetailsOpenHouseDatesViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingOtherDetailsOpenHouseDatesViewController.h"

#import "OMBDatePickerCell.h"
#import "OMBHeaderTitleCell.h"
#import "OMBLabelTextFieldCell.h"
#import "UIColor+Extensions.h"

@implementation OMBFinishListingOtherDetailsOpenHouseDatesViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  CGRect rect = [@"Starts" boundingRectWithSize:
    CGSizeMake(9999, OMBStandardHeight) font: [UIFont normalTextFont]];
  sizeForLabelTextFieldCell = rect.size;

  self.screenName = self.title = @"Open House Dates";

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadView
{
  [super loadView];

  saveBarButtonItem.enabled = YES;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  [self setupForTable];

  openHouseDates = 2;
  selectedDates  = [NSMutableDictionary dictionary];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Open House Date 1
  // Open House Date 2
  return openHouseDates;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Normal cell
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
      reuseIdentifier: CellIdentifier];
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.backgroundColor = tableView.backgroundColor;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  cell.textLabel.text = @"";
  cell.textLabel.textColor = [UIColor textColor];

  // Header title cell
  static NSString *HeaderTitleCellIdentifier = @"HeaderTitleCellIdentifier";
  OMBHeaderTitleCell *headerTitleCell = 
    [tableView dequeueReusableCellWithIdentifier: HeaderTitleCellIdentifier];
  if (!headerTitleCell)
    headerTitleCell = [[OMBHeaderTitleCell alloc] initWithStyle: 
      UITableViewCellStyleDefault reuseIdentifier: HeaderTitleCellIdentifier];

  // Spacing
  if (indexPath.row == 0) {
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
  }
  // Header title
  else if (indexPath.row == 1) {
    headerTitleCell.titleLabel.text = [NSString stringWithFormat: 
      @"Open House Date %i", indexPath.section + 1];
    return headerTitleCell;
  }
  else {
    // Text field cell
    static NSString *TextFieldCellIdentifier = @"TextFieldCellIdentifier";
    OMBLabelTextFieldCell *cell1 = 
      [tableView dequeueReusableCellWithIdentifier: TextFieldCellIdentifier];
    if (!cell1) {
      cell1 = [[OMBLabelTextFieldCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: TextFieldCellIdentifier];
      [cell1 setFrameUsingSize: sizeForLabelTextFieldCell];
    }
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.textField.userInteractionEnabled = YES;

    NSString *string = @"";
    // Starts
    if (indexPath.row == 2) {
      string = @"Starts";
      cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
      cell1.textField.userInteractionEnabled = NO;
    }
    // Date picker
    else if (indexPath.row == 3) {
      if (selectedIndexPath &&
        selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row - 1) {

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

        // Select dates

        return datePickerCell;
      }
        
    }
    // Ends
    else if (indexPath.row == 4) {
      string = @"Ends";
      cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
      cell1.textField.userInteractionEnabled = NO;
      // Bottom border
      // Use layer because after clicking the row, the view goes away
      CALayer *bottomBorderLayer = [CALayer layer];
      bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
      bottomBorderLayer.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
        tableView.frame.size.width, 0.5f);
      [cell1.contentView.layer addSublayer: bottomBorderLayer];
    }
    // Date picker
    else if (indexPath.row == 5) {
      if (selectedIndexPath &&
        selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row - 1) {

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

        // Select dates

        // Bottom border
        // Use layer because after clicking the row, the view goes away
        CALayer *bottomBorderLayer = [CALayer layer];
        bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
        bottomBorderLayer.frame = CGRectMake(0.0f, 216.0f - 0.5f, 
          tableView.frame.size.width, 0.5f);
        [datePickerCell.contentView.layer addSublayer: bottomBorderLayer];

        return datePickerCell;
      }
    }

    cell1.textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
      size: 15];
    cell1.textField.tag = indexPath.row;
    cell1.textField.textAlignment = NSTextAlignmentRight;
    cell1.textField.textColor = [UIColor blueDark];
    cell1.textFieldLabel.text = string;
    return cell1;
  }

  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Spacing
  // Header
  // Starts
  // Date picker
  // Ends
  // Date picker
  return 6;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (selectedIndexPath) {
    if (selectedIndexPath.section == indexPath.section &&
      selectedIndexPath.row == indexPath.row) {

      selectedIndexPath = nil;
    }
    else {
      selectedIndexPath = indexPath;
    }
  }
  else {
    selectedIndexPath = indexPath;
  }
  [self.table reloadRowsAtIndexPaths: @[
    [NSIndexPath indexPathForRow: 
      indexPath.row + 1 inSection: indexPath.section]
    ] withRowAnimation: UITableViewRowAnimationFade];
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.row == 3 || indexPath.row == 5) {
    if (selectedIndexPath) {
      if (selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row - 1) {

        return 216.0f;
      }
    }
  }
  else {
    return 44.0f;
  }
  return 0.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) datePickerChanged: (UIDatePicker *) datePicker
{
  if (selectedIndexPath) {
    NSNumber *key = [NSNumber numberWithInt: selectedIndexPath.section];
    NSMutableDictionary *dateDict = [selectedDates objectForKey: key];
    if (!dateDict) {
      dateDict = [NSMutableDictionary dictionary];
      [selectedDates setObject: dateDict forKey: key];
    }

    NSDateFormatter *dateTimeFormatter = [NSDateFormatter new];
    dateTimeFormatter.dateFormat = @"MMMM d, yyyy   h:mm a";
    NSString *string = [dateTimeFormatter stringFromDate: datePicker.date];
    // End date
    if (selectedIndexPath.row == 4) {
      unsigned unitFlags = (NSYearCalendarUnit | NSMonthCalendarUnit |  
        NSDayCalendarUnit);
      NSCalendar *calendar = [NSCalendar currentCalendar];

      NSDate *startDate = [dateDict objectForKey: @"start"];
      if (startDate) {
        NSDateComponents *componentsStart = [calendar components: unitFlags 
          fromDate: startDate];
        NSDateComponents *componentsEnd = [calendar components: unitFlags 
          fromDate: datePicker.date];
        if ([componentsStart month] == [componentsEnd month] &&
          [componentsStart day] == [componentsEnd day] &&
          [componentsStart year] == [componentsEnd year]) {

          NSDateFormatter *timeFormatter = [NSDateFormatter new];
          timeFormatter.dateFormat = @"h:mm a";
          string = [timeFormatter stringFromDate: datePicker.date];
        }
      }
    }
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *) 
      [self.table cellForRowAtIndexPath: selectedIndexPath];
    cell.textField.text = string;

    NSString *keyString = @"start";
    // Start
    if (selectedIndexPath.row == 2) {
      keyString = @"start";
    }
    // End
    else if (selectedIndexPath.row == 4) {
      keyString = @"end";
    }
    [dateDict setObject: datePicker.date forKey: keyString];
  }
}

@end
