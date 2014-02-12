//
//  OMBFinishListingLeaseDetailsViewController.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 1/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingLeaseDetailsViewController.h"

#import "OMBActivityView.h"
#import "OMBDatePickerCell.h"
#import "OMBFinishListingOpenHouseDatesViewController.h"
#import "OMBHeaderTitleCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBPickerViewCell.h"
#import "OMBResidence.h"
#import "OMBResidenceDeleteConnection.h"
#import "OMBResidenceOpenHouseListConnection.h"
#import "OMBResidenceUpdateConnection.h"
#import "OMBStandardLeaseViewController.h"
#import "OMBViewControllerContainer.h"

float k2KeyboardHeight = 216.0;

// Tags
// int kBottomBorderTag = 9999;

@implementation OMBFinishListingLeaseDetailsViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;
  
  leaseTypeOptions = @[
                       @"OMB Standard Lease",
                       @"Choose My Own",
                       @"No Lease"
                       ];
  
  if (!residence.leaseType || [residence.leaseType length] == 0)
    residence.leaseType = [leaseTypeOptions firstObject];
  
  monthLeaseOptions = @[
                        @"Month to month",@"1 month lease",@"2 months lease",
                        @"3 months lease",@"4 months lease",@"5 months lease",
                        @"6 months lease",@"7 months lease",@"8 months lease",
                        @"9 months lease",@"10 months lease",@"11 months lease",
                        @"12 months lease"];
  
  CGRect rect = [@"Move-out Date" boundingRectWithSize:
    CGSizeMake(9999, OMBStandardHeight) font: [UIFont normalTextFont]];
  sizeForLabelTextFieldCell = rect.size;

  dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"MMMM d, yyyy";
  
  self.screenName = self.title = @"Lease Details";
  
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadView
{
  [super loadView];
  
  [self setupForTable];
  
  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
                                                       style: UIBarButtonItemStylePlain target: self action: @selector(done)];
  [doneBarButtonItem setTitleTextAttributes: @{
                                               NSFontAttributeName: boldFont
                                               } forState: UIControlStateNormal];
  saveBarButtonItem.enabled = YES;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;
  
  deleteActionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self
                                         cancelButtonTitle: @"Cancel" destructiveButtonTitle: @"Delete Listing"
                                         otherButtonTitles: nil];
  [self.view addSubview: deleteActionSheet];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  // List Connection
  OMBResidenceOpenHouseListConnection *conn =
  [[OMBResidenceOpenHouseListConnection alloc] initWithResidence:
   residence];
  conn.completionBlock = ^(NSError *error) {
    [self.table reloadRowsAtIndexPaths:
     @[[NSIndexPath indexPathForRow: 8 inSection: 0]]
                      withRowAnimation: UITableViewRowAnimationNone];
  };
  // [conn start];
  
  [self.table reloadData];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];
  
  if (residence) {
    OMBResidenceUpdateConnection *conn =
    [[OMBResidenceUpdateConnection alloc] initWithResidence: residence
        attributes: @[
                     // @"bathrooms",
                     // @"bedrooms",
                     @"leaseMonths",
                     @"leaseType",
                     @"moveInDate",
                     @"moveOutDate",
                     // @"propertyType",
                     // @"squareFeet"
                     ]
     ];
    [conn start];
  }
}

#pragma mark - Protocol

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 0) {
    [self deleteListing];
  }
}

#pragma mark - Protocol UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
  if (selectedIndexPath) {
    // Month Lease
    if (selectedIndexPath.section == 0 && selectedIndexPath.row == 6) {
      return 1;
    }
    // Lease Type
    if (selectedIndexPath.section == 0 && selectedIndexPath.row == 9) {
      return 1;
    }
  }
  return 0;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView
 numberOfRowsInComponent: (NSInteger) component
{
  if (selectedIndexPath) {
    // Month Lease
    if (selectedIndexPath.section == 0 && selectedIndexPath.row == 6) {
      return [monthLeaseOptions count];
    }
    // Lease Type
    if (selectedIndexPath.section == 0 && selectedIndexPath.row == 9) {
      return [leaseTypeOptions count];
    }
  }
  return 0;
}

#pragma mark - Protocol UIPickerViewDelegate

- (void) pickerView: (UIPickerView *) pickerView didSelectRow: (NSInteger) row
        inComponent: (NSInteger) component
{
  if (selectedIndexPath) {
    NSString *string = @"";
    // Month Lease
    if (selectedIndexPath.section == 0 && selectedIndexPath.row == 6) {
      string = [monthLeaseOptions objectAtIndex: row];
      residence.leaseMonths = (int)row;
      if(residence.moveInDate){
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMonth:row];
        // add months to move in and set to move out
        NSDate *auxDate = [[NSCalendar currentCalendar]
                           dateByAddingComponents:dateComponents
                           toDate:[NSDate dateWithTimeIntervalSince1970: residence.moveInDate] options:0];
        if([[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:auxDate] year] >= 2016){
          NSDateFormatter *df = [[NSDateFormatter alloc] init];
          [df setDateFormat:@"dd-MM-yyyy"];
          auxDate = [df dateFromString:@"31-12-2015"] ;
        }
        residence.moveOutDate = [auxDate timeIntervalSince1970];
        OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
          [self.table cellForRowAtIndexPath:
            [NSIndexPath indexPathForItem:4 inSection:0]];
        cell.textField.text = [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:residence.moveOutDate]];
      }
    }
    // Lease Type
    else if (selectedIndexPath.section == 0 && selectedIndexPath.row == 9) {
      string = [leaseTypeOptions objectAtIndex: row];
      residence.leaseType = string;
    }
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
    [self.table cellForRowAtIndexPath: selectedIndexPath];
    cell.textField.text = string;
  }
}

- (CGFloat) pickerView: (UIPickerView *) pickerView
 rowHeightForComponent: (NSInteger) component
{
  return 44.0f;
}

- (UIView *) pickerView: (UIPickerView *) pickerView viewForRow: (NSInteger) row
           forComponent: (NSInteger) component reusingView: (UIView *) view
{
  NSString *string = @"";
  // Month Lease
  if (selectedIndexPath.section == 0 && selectedIndexPath.row == 6) {
    string = [monthLeaseOptions objectAtIndex: row];
  }
  // Lease Type
  else if (selectedIndexPath.section == 0 && selectedIndexPath.row == 9) {
    string = [leaseTypeOptions objectAtIndex: row];
  }
  if (view && [view isKindOfClass: [UILabel class]]) {
    UILabel *label = (UILabel *) view;
    label.text = string;
    return label;
  }
  else {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize: 22];
    label.frame = CGRectMake(0.0f, 0.0f, pickerView.frame.size.width, 44.0f);
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor textColor];
    return label;
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  // Lease Details
  // Delete Listing
  // Spacing for when typing
  return 3;
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
  
  // Lease Details
  if (indexPath.section == 0) {
    // Spacing
    if (indexPath.row == 0) {
      cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
                                             0.0f, 0.0f);
    }
    // Header title
    else if (indexPath.row == 1) {
      headerTitleCell.titleLabel.text = @"Lease Details";
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
      cell1.textField.placeholder = @"";
      cell1.textField.userInteractionEnabled = YES;
      NSString *string = @"";
      // Move-in Date
      if (indexPath.row == 2) {
        string = @"Move-in Date";
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell1.textField.placeholder = @"required";
        cell1.textField.userInteractionEnabled = NO;
        
        if (residence.moveInDate) {
          cell1.textField.text = [dateFormatter stringFromDate:
                                  [NSDate dateWithTimeIntervalSince1970: residence.moveInDate]];
        }
      }
      // Move-in Date picker
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
          datePickerCell.datePicker.datePickerMode = UIDatePickerModeDate;
          
          // specify max date
          NSDateFormatter *df = [[NSDateFormatter alloc] init];
          [df setDateFormat:@"dd-MM-yyyy"];
          NSDate *dateFromString = [[NSDate alloc] init];
          dateFromString = [df dateFromString:@"31-12-2015"];
          datePickerCell.datePicker.maximumDate = dateFromString;
          
          if (residence.moveInDate) {
            [datePickerCell.datePicker setDate:
             [NSDate dateWithTimeIntervalSince1970: residence.moveInDate]
                                      animated: NO];
          }
          return datePickerCell;
        }
      }
      // Move-out Date
      else if (indexPath.row == 4) {
        string = @"Move-out Date";
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell1.textField.userInteractionEnabled = NO;
        cell1.textField.placeholder = @"optional";
        if (residence.moveOutDate) {
          cell1.textField.text = [dateFormatter stringFromDate:
            [NSDate dateWithTimeIntervalSince1970: residence.moveOutDate]];
        }
      }
      // Move-out Date Picker
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
          datePickerCell.datePicker.datePickerMode = UIDatePickerModeDate;
          
          // specify max date
          NSDateFormatter *df = [[NSDateFormatter alloc] init];
          [df setDateFormat:@"dd-MM-yyyy"];
          NSDate *dateFromString = [[NSDate alloc] init];
          dateFromString = [df dateFromString:@"31-12-2015"];
          datePickerCell.datePicker.maximumDate = dateFromString;
          
          if (residence.moveOutDate) {
            [datePickerCell.datePicker setDate:
             [NSDate dateWithTimeIntervalSince1970: residence.moveOutDate]
                                      animated: NO];
          }
          return datePickerCell;
        }
      }
      // Month Lease
      else if (indexPath.row == 6) {
        string = @"Month Lease";
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        cell1.textField.text = monthLeaseOptions[residence.leaseMonths];
        cell1.textField.userInteractionEnabled = NO;
        
        // Bottom border
        // Use layer because after clicking the row, the view goes away
        // CALayer *bottomBorderLayer = [CALayer layer];
        // bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
        // bottomBorderLayer.frame = CGRectMake(0.0f, 44.0f - 0.5f,
        //                                      tableView.frame.size.width, 0.5f);
        // [cell1.contentView.layer addSublayer: bottomBorderLayer];
        
      }
      // Month Lease Picker View
      else if (indexPath.row == 7) {
        if (selectedIndexPath &&
            selectedIndexPath.section == indexPath.section &&
            selectedIndexPath.row == indexPath.row - 1) {
          
          static NSString *PickerCellIdentifier = @"PickerCellIdentifier";
          OMBPickerViewCell *pickerCell =
          [tableView dequeueReusableCellWithIdentifier: PickerCellIdentifier];
          if (!pickerCell)
            pickerCell = [[OMBPickerViewCell alloc] initWithStyle:
                          UITableViewCellStyleDefault reuseIdentifier:
                          PickerCellIdentifier];
          pickerCell.pickerView.dataSource = self;
          pickerCell.pickerView.delegate   = self;
          
          NSInteger selectedRow = residence.leaseMonths;
          [pickerCell.pickerView selectRow: selectedRow inComponent: 0
                                  animated: NO];
          
          // Bottom border
          // Use layer because after clicking the row, the view goes away
          // CALayer *bottomBorderLayer = [CALayer layer];
          // bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
          // bottomBorderLayer.frame = CGRectMake(0.0f, k2KeyboardHeight - 0.5f,
          //                                      tableView.frame.size.width, 0.5f);
          // [pickerCell.contentView.layer addSublayer: bottomBorderLayer];
          
          return pickerCell;
        }
      }
      // Open House Dates
      else if (indexPath.row == 8) {
        static NSString *OpenHouseCellIdentifier = @"OpenHouseCellIdentifier";
        UITableViewCell *openHouseCell =
        [tableView dequeueReusableCellWithIdentifier:
         OpenHouseCellIdentifier];
        if (!openHouseCell)
          openHouseCell = [[UITableViewCell alloc] initWithStyle:
                           UITableViewCellStyleValue1 reuseIdentifier:
                           OpenHouseCellIdentifier];
        openHouseCell.accessoryType =
        UITableViewCellAccessoryDisclosureIndicator;
        openHouseCell.backgroundColor = [UIColor whiteColor];
        openHouseCell.detailTextLabel.font = [UIFont fontWithName:
                                              @"HelveticaNeue-Medium" size: 15];
        openHouseCell.detailTextLabel.text = [NSString stringWithFormat: @"%i",
                                              [residence.openHouseDates count]];
        
        openHouseCell.detailTextLabel.textColor = [UIColor blueDark];
        openHouseCell.textLabel.text = @"Open House Dates";
        openHouseCell.textLabel.font = [UIFont fontWithName:
                                        @"HelveticaNeue-Light" size: 15];
        openHouseCell.textLabel.textColor = [UIColor textColor];
        
        return openHouseCell;
      }
      // Lease Type
      else if (indexPath.row == 9) {
        string = @"Lease Type";
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        if (residence.leaseType)
          cell1.textField.text = residence.leaseType;
        else
          cell1.textField.text = [leaseTypeOptions firstObject];
        cell1.textField.userInteractionEnabled = NO;
        
        // Bottom border
        // Use layer because after clicking the row, the view goes away
        // CALayer *bottomBorderLayer = [CALayer layer];
        // bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
        // bottomBorderLayer.frame = CGRectMake(0.0f, 44.0f - 0.5f,
        //                                      tableView.frame.size.width, 0.5f);
        // [cell1.contentView.layer addSublayer: bottomBorderLayer];
      }
      // Lease Type Picker View
      else if (indexPath.row == 10) {
        if (selectedIndexPath &&
            selectedIndexPath.section == indexPath.section &&
            selectedIndexPath.row == indexPath.row - 1) {
          
          static NSString *PickerCellIdentifier = @"PickerCellIdentifier";
          OMBPickerViewCell *pickerCell =
          [tableView dequeueReusableCellWithIdentifier: PickerCellIdentifier];
          if (!pickerCell)
            pickerCell = [[OMBPickerViewCell alloc] initWithStyle:
                          UITableViewCellStyleDefault reuseIdentifier:
                          PickerCellIdentifier];
          pickerCell.pickerView.dataSource = self;
          pickerCell.pickerView.delegate   = self;
          
          NSInteger selectedRow = 0;
          if (residence.leaseType) {
            selectedRow = [leaseTypeOptions indexOfObjectPassingTest:
                           ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
                             return [[obj lowercaseString] isEqualToString:
                                     [residence.leaseType lowercaseString]];
                           }
                           ];
            if (selectedRow == NSNotFound)
              selectedRow = 0;
          }
          [pickerCell.pickerView selectRow: selectedRow inComponent: 0
                                  animated: NO];
          
          // Bottom border
          // Use layer because after clicking the row, the view goes away
          // CALayer *bottomBorderLayer = [CALayer layer];
          // bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
          // bottomBorderLayer.frame = CGRectMake(0.0f, k2KeyboardHeight - 0.5f,
          //                                      tableView.frame.size.width, 0.5f);
          // [pickerCell.contentView.layer addSublayer: bottomBorderLayer];
          
          return pickerCell;
        }
      }
      // View OMB Standard Lease
      else if (indexPath.row == 11) {
        static NSString *LinkCellIdentifier = @"LinkCellIdentifier";
        UITableViewCell *linkCell =
        [tableView dequeueReusableCellWithIdentifier: LinkCellIdentifier];
        if (!linkCell) {
          linkCell = [[UITableViewCell alloc] initWithStyle:
                      UITableViewCellStyleValue1 reuseIdentifier: LinkCellIdentifier];
          // Top border
          // UIView *bor = [UIView new];
          // bor.backgroundColor = [UIColor grayLight];
          // bor.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 0.5f);
          // [linkCell.contentView addSubview: bor];
          // View OMB Standard Lease label
          UILabel *label = [UILabel new];
          label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
          label.frame = CGRectMake(0.0f, 0.0f,
                                   tableView.frame.size.width - (20.0f * 2), 44.0f);
          label.text = @"View OMB Standard Lease";
          label.textAlignment = NSTextAlignmentRight;
          label.textColor = [UIColor blue];
          [linkCell.contentView addSubview: label];
        }
          
        linkCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        linkCell.backgroundColor = tableView.backgroundColor;
        linkCell.selectionStyle = UITableViewCellSelectionStyleNone;
        linkCell.separatorInset = UIEdgeInsetsMake(0.0f,
                                                   tableView.frame.size.width, 0.0f, 0.0f);
        
        return linkCell;
      }
      
      cell1.textField.delegate = self;
      cell1.textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
                                             size: 15];
      cell1.textField.indexPath = indexPath;
      cell1.textField.tag = indexPath.row;
      cell1.textField.textAlignment = NSTextAlignmentRight;
      cell1.textField.textColor = [UIColor blueDark];
      cell1.textFieldLabel.text = string;
      [cell1.textField addTarget: self action: @selector(textFieldDidChange:)
                forControlEvents: UIControlEventEditingChanged];
      return cell1;
    }
  }
  // Delete Listing
  else if (indexPath.section == 2) {
    // Spacing
    if (indexPath.row == 0) {
      headerTitleCell.titleLabel.text = @"";
      return headerTitleCell;
    }
    // Delete Listing
    else if (indexPath.row == 1) {
      // Delete Cell
      static NSString *DeleteCellIdentifier = @"DeleteCellIdentifier";
      UITableViewCell *deleteCell =
      [tableView dequeueReusableCellWithIdentifier: DeleteCellIdentifier];
      if (!deleteCell)
        deleteCell = [[UITableViewCell alloc] initWithStyle:
                      UITableViewCellStyleDefault reuseIdentifier: DeleteCellIdentifier];
      deleteCell.backgroundColor = [UIColor whiteColor];
      // Delete Listing label
      UILabel *label = (UILabel *) [deleteCell.contentView viewWithTag: 7777];
      if (!label) {
        label = [UILabel new];
        label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
        label.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 44.0f);
        label.tag = 7777;
        label.text = @"Delete Listing";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor red];
      }
      [deleteCell.contentView addSubview: label];
      
      // Bottom border
      // Use layer because after clicking the row, the view goes away
      // CALayer *bottomBorderLayer = [CALayer layer];
      // bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
      // bottomBorderLayer.frame = CGRectMake(0.0f, 44.0f - 0.5f,
      //                                      tableView.frame.size.width, 0.5f);
      // [deleteCell.contentView.layer addSublayer: bottomBorderLayer];
      
      return deleteCell;
    }
  }
  
  // Spacing for when typing
  else if (indexPath.section == 3) {
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
                                           0.0f, 0.0f);
  }
  
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  // Lease Details
  if (section == 0) {
    // Spacing
    // Header title
    // Move-in Date
    // - Date picker
    // Move-out Date
    // - Date Picker
    // Month Lease
    // - Date Picker
    // Open House Dates
    // Lease Type
    // - Picker view
    // View OMB Standard Lease
    return 12;
  }
  // Delete Listing
  else if (section == 2) {
    // Spacing
    // Delete Listing
    // return 2;
  }
  // Spacing for when typing
  else if (section == 3) {
    // Spacing
    // 216.0f spacing
    return 2;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Lease Details
  if (indexPath.section == 0) {
    // Move-in  Date
    // Move-out Date
    // Month Lease
    // Lease Type
    if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 9) {
      [self reloadForDatePickerAndPickerViewRowsAtIndexPath: indexPath];
    }
    // Open House Dates
    else if (indexPath.row == 8) {
      [self.navigationController pushViewController:
       [[OMBFinishListingOpenHouseDatesViewController alloc]
        initWithResidence: residence] animated: YES];
    }
    // OMB Standard Lease
    else if (indexPath.row == 11) {
      [self.navigationController pushViewController:
       [[OMBStandardLeaseViewController alloc] init] animated: YES];
    }
  }
  // Delete Listing
  else if (indexPath.section == 2) {
    // [deleteActionSheet showInView: self.view];
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // If the last section
  if (indexPath.section == [tableView numberOfSections] - 1) {
    if (indexPath.row == 0) {
      return 44.0f;
    }
    else {
      if (isEditing)
        return 216.0f;
    }
  }
  // If all the other sections
  else {
    // Lease Details
    if (indexPath.section == 0) {
      // Move-in  Date date picker
      // Move-out Date date picker
      // Month Lease date picker
      // Lease Type picker view
      if (indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 10) {
        if (selectedIndexPath &&
            selectedIndexPath.section == indexPath.section &&
            selectedIndexPath.row == indexPath.row - 1) {
          
          return k2KeyboardHeight;
        }
        else {
          return 0.0f;
        }
      }
      // Move-out Date
      // Hide the move-out date, we are not using it
      // else if (indexPath.row == 4) {
      //   return 0.0f;
      // }

      // Open House Dates
      else if (indexPath.row == 8) {
        return 0.0f;
      }
    }
    return 44.0f;
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  isEditing = YES;
  
  if (selectedIndexPath) {
    NSIndexPath *previousIndexPath = selectedIndexPath;
    selectedIndexPath = nil;
    [self.table reloadRowsAtIndexPaths: @[previousIndexPath]
                      withRowAnimation: UITableViewRowAnimationFade];
  }
  else {
    [self.table beginUpdates];
    [self.table endUpdates];
  }
  
  if ([textField isKindOfClass: [TextFieldPadding class]]) {
    TextFieldPadding *tf = (TextFieldPadding *) textField;
    if (tf.indexPath) {
      [self scrollToRowAtIndexPath: tf.indexPath];
    }
  }
  
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  isEditing = NO;
  [textField resignFirstResponder];
  [self.table beginUpdates];
  [self.table endUpdates];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) datePickerChanged: (UIDatePicker *) datePicker
{
  OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
  [self.table cellForRowAtIndexPath: selectedIndexPath];
  cell.textField.text = [dateFormatter stringFromDate: datePicker.date];
  // Lease Details
  if (selectedIndexPath.section == 0) {
    // Move-in Date
    if (selectedIndexPath.row == 2) {
      residence.moveInDate = [datePicker.date timeIntervalSince1970];
      // compare if move out is earlier than move in
      if([[NSDate dateWithTimeIntervalSince1970:residence.moveOutDate]
          compare:datePicker.date] == NSOrderedAscending){
        //change move out
        residence.moveOutDate = [datePicker.date timeIntervalSince1970];
        OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
          [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForItem:4 inSection:0]];
        cell.textField.text = [dateFormatter stringFromDate: datePicker.date];
      }
      residence.leaseMonths = [self numberOfMonthsBetweenMovingDates];
    }
    else if (selectedIndexPath.row == 4) {
      residence.moveOutDate = [datePicker.date timeIntervalSince1970];
      // compare if move in is later than move out
      if([[NSDate dateWithTimeIntervalSince1970:residence.moveInDate]
          compare:datePicker.date] == NSOrderedDescending){
        //change move in
        residence.moveInDate = [datePicker.date timeIntervalSince1970];
        OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
          [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForItem:2 inSection:0]];
        cell.textField.text = [dateFormatter stringFromDate: datePicker.date];
      }
      residence.leaseMonths = [self numberOfMonthsBetweenMovingDates];
    }
    
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
    [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForItem:6 inSection:0]];
    cell.textField.text = monthLeaseOptions[residence.leaseMonths];
    
  }
}

- (void) deleteListing
{
  [[self appDelegate].container startSpinning];
  // OMBActivityView *activityView = [[OMBActivityView alloc] init];
  // [self.view addSubview: activityView];
  // [activityView startSpinning];
  
  OMBResidenceDeleteConnection *conn =
  [[OMBResidenceDeleteConnection alloc] initWithResidence: residence];
  conn.completionBlock = ^(NSError *error) {
    OMBResidence *res = [[OMBUser currentUser].residences objectForKey:
                         [NSNumber numberWithInt: residence.uid]];
    if (error || res) {
      NSString *message = @"";
      if (error) {
        message = error.localizedDescription;
      }
      else {
        message = @"Delete unsuccessful";
      }
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error"
                                                          message: message delegate: nil cancelButtonTitle: @"Try again"
                                                otherButtonTitles: nil];
      [alertView show];
    }
    else {
      residence = nil;
      [self.navigationController popToRootViewControllerAnimated: NO];
    }
    [[self appDelegate].container stopSpinning];
    // [activityView stopSpinning];
  };
  [conn start];
}

- (void) done
{
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
  [self.view endEditing: YES];
  isEditing = NO;
  [self.table reloadRowsAtIndexPaths: @[[self indexPathForSpacing]]
                    withRowAnimation: UITableViewRowAnimationFade];
}

- (NSIndexPath *) indexPathForSpacing
{
  return [NSIndexPath indexPathForRow:
          [self.table numberOfRowsInSection: [self.table numberOfSections] - 1] - 1
                            inSection: [self.table numberOfSections] - 1];
}

- (NSInteger) numberOfMonthsBetweenMovingDates
{
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSUInteger unitFlags = (NSDayCalendarUnit | NSMonthCalendarUnit |
                          NSWeekdayCalendarUnit | NSYearCalendarUnit);
  
  NSDateComponents *moveInComps = [calendar components: unitFlags
                                              fromDate: [NSDate dateWithTimeIntervalSince1970: residence.moveInDate]];
  [moveInComps setDay: 1];
  NSDateComponents *moveOutComps = [calendar components: unitFlags
                                               fromDate: [NSDate dateWithTimeIntervalSince1970: residence.moveOutDate]];
  [moveOutComps setDay: 1];
  
  NSInteger moveInMonth  = [moveInComps month];
  NSInteger moveOutMonth = [moveOutComps month];
  
  NSInteger yearDifference = [moveOutComps year] - [moveInComps year];
  moveOutMonth += (12 * yearDifference);
  
  NSInteger monthDifference = moveOutMonth - moveInMonth;
  NSLog(@"%d",monthDifference);
  if(monthDifference < 0)
    return 0;
  else if (monthDifference > 12)
    return 12;
  
  return monthDifference;
}

- (void) reloadForDatePickerAndPickerViewRowsAtIndexPath:
(NSIndexPath *) indexPath
{
  isEditing = NO;
  [self.view endEditing: YES];
  
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
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem];
}

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.table scrollToRowAtIndexPath: indexPath 
                    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  // Listing Details
  if (textField.indexPath.section == 1) {
    // Bedrooms
    if (textField.indexPath.row == 2) {
      residence.bedrooms = [textField.text floatValue];
    }
    // Bathrooms
    else if (textField.indexPath.row == 3) {
      residence.bathrooms = [textField.text floatValue];
    }
    // Square Feet
    else if (textField.indexPath.row == 6) {
      residence.squareFeet = [textField.text intValue];
    }
  }
}

@end
