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

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  [self setupForTable];

  saveBarButtonItem.enabled = YES;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  deleteActionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self
                                         cancelButtonTitle: @"Cancel" destructiveButtonTitle: @"Delete Listing"
                                         otherButtonTitles: nil];
  [self.view addSubview: deleteActionSheet];

	isShowPicker = NO;

  fadedBackground = [[UIView alloc] init];
  fadedBackground.alpha = 0.0f;
  fadedBackground.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.8f];
  fadedBackground.frame = screen;
  [self.view addSubview: fadedBackground];
  UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget: self
      action: @selector(hidePickerView)];
  [fadedBackground addGestureRecognizer: tapGesture];

  // Picker view container
  pickerViewContainer = [UIView new];
  [self.view addSubview: pickerViewContainer];

  // Header for picker view with cancel and done button
  UIView *pickerViewHeader = [[UIView alloc] init];
  pickerViewHeader.backgroundColor = [UIColor grayUltraLight];
  pickerViewHeader.frame = CGRectMake(0.0f, 0.0f,
    screen.size.width, 44.0f);
  [pickerViewContainer addSubview: pickerViewHeader];

  pickerViewHeaderLabel = [[UILabel alloc] init];
  pickerViewHeaderLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
  pickerViewHeaderLabel.frame = pickerViewHeader.frame;
  pickerViewHeaderLabel.text = @"XD";
  pickerViewHeaderLabel.textAlignment = NSTextAlignmentCenter;
  pickerViewHeaderLabel.textColor = [UIColor textColor];
  [pickerViewHeader addSubview: pickerViewHeaderLabel];
  // Cancel button
  UIButton *cancelButton = [UIButton new];
  cancelButton.titleLabel.font = [UIFont fontWithName:
    @"HelveticaNeue-Medium" size: 15];
  CGRect neighborhoodCancelButtonRect = [@"Cancel" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width, pickerViewHeader.frame.size.height)
      font: cancelButton.titleLabel.font];
  cancelButton.frame = CGRectMake(padding, 0.0f,
    neighborhoodCancelButtonRect.size.width, pickerViewHeader.frame.size.height);
  [cancelButton addTarget: self
    action: @selector(cancelPicker)
      forControlEvents: UIControlEventTouchUpInside];
  [cancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [cancelButton setTitleColor: [UIColor blueDark]
     forState: UIControlStateNormal];
  [pickerViewHeader addSubview: cancelButton];
  // Done button
  UIButton *doneButton = [UIButton new];
  doneButton.titleLabel.font = cancelButton.titleLabel.font;
  CGRect doneButtonRect = [@"Done" boundingRectWithSize:
    CGSizeMake(pickerViewHeader.frame.size.width,
      pickerViewHeader.frame.size.height)
        font: doneButton.titleLabel.font];
  doneButton.frame = CGRectMake(pickerViewHeader.frame.size.width -
    (padding + doneButtonRect.size.width), 0.0f,
      doneButtonRect.size.width, pickerViewHeader.frame.size.height);
  [doneButton addTarget: self
                     action: @selector(donePicker)
           forControlEvents: UIControlEventTouchUpInside];
  [doneButton setTitle: @"Done" forState: UIControlStateNormal];
  [doneButton setTitleColor: [UIColor blueDark]
                       forState: UIControlStateNormal];
  [pickerViewHeader addSubview: doneButton];

  // Move-in picker
  moveInPicker = [UIDatePicker new];
	moveInPicker.backgroundColor = [UIColor whiteColor];
  moveInPicker.datePickerMode = UIDatePickerModeDate;
  moveInPicker.frame = CGRectMake(0.0f,
    pickerViewHeader.frame.origin.y +
       pickerViewHeader.frame.size.height,
         moveInPicker.frame.size.width, moveInPicker.frame.size.height);
  moveInPicker.minimumDate    = [NSDate date];
  // specify max date
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"dd-MM-yyyy"];
  NSDate *dateFromString1 = [[NSDate alloc] init];
  dateFromString1 = [df dateFromString:@"31-12-2015"];
  moveInPicker.maximumDate = dateFromString1;

  // Move-out picker
  moveOutPicker = [UIDatePicker new];
	moveOutPicker.backgroundColor = [UIColor whiteColor];
  moveOutPicker.datePickerMode = UIDatePickerModeDate;
  moveOutPicker.frame = moveInPicker.frame;
  moveOutPicker.minimumDate = [NSDate date];
  // specify max date
  NSDate *dateFromString2 = [[NSDate alloc] init];
  dateFromString2 = [df dateFromString:@"31-12-2015"];
  moveOutPicker.maximumDate = dateFromString2;

  // Lease type picker
  monthLeasePicker = [[UIPickerView alloc] init];
  monthLeasePicker.backgroundColor = [UIColor whiteColor];
  monthLeasePicker.dataSource = self;
  monthLeasePicker.delegate   = self;
  monthLeasePicker.frame = CGRectMake(0.0f,
                                     pickerViewHeader.frame.origin.y +
                                     pickerViewHeader.frame.size.height,
                                     monthLeasePicker.frame.size.width, monthLeasePicker.frame.size.height);

  // Lease type picker
  leaseTypePicker = [[UIPickerView alloc] init];
  leaseTypePicker.backgroundColor = [UIColor whiteColor];
  leaseTypePicker.dataSource = self;
  leaseTypePicker.delegate   = self;
  leaseTypePicker.frame = CGRectMake(0.0f,
    pickerViewHeader.frame.origin.y +
      pickerViewHeader.frame.size.height,
        leaseTypePicker.frame.size.width, leaseTypePicker.frame.size.height);

  pickerViewContainer.frame = CGRectMake(0.0f, self.view.frame.size.height,
    monthLeasePicker.frame.size.width,
      pickerViewHeader.frame.size.height +
        monthLeasePicker.frame.size.height);

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

  // Move-in Date picker
  if (residence.moveInDate)
    [moveInPicker setDate:
      [NSDate dateWithTimeIntervalSince1970: residence.moveInDate]
        animated: NO];

  // Move-out Date picker
  if (residence.moveOutDate)
    [moveOutPicker setDate:
      [NSDate dateWithTimeIntervalSince1970: residence.moveOutDate]
        animated: NO];

  // Month lease picker
  NSInteger selectedMonthRow = residence.leaseMonths;
  [monthLeasePicker selectRow: selectedMonthRow inComponent: 0
    animated: NO];

  // Lease type picker
  NSInteger selectedLeaseRow = 0;
  if (residence.leaseType) {
    selectedLeaseRow = [leaseTypeOptions indexOfObjectPassingTest:
      ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
      return [[obj lowercaseString] isEqualToString:
        [residence.leaseType lowercaseString]];
      }
    ];
    if (selectedLeaseRow == NSNotFound)
      selectedLeaseRow = 0;
  }
  [leaseTypePicker selectRow: selectedLeaseRow inComponent: 0
    animated: NO];
  [self updateLeaseTypeDescription: selectedLeaseRow];
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
  return 1;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView
 numberOfRowsInComponent: (NSInteger) component
{
  // Month Lease
  if (pickerView == monthLeasePicker)
    return [monthLeaseOptions count];

  // Lease Type
  if (pickerView == leaseTypePicker)
    return [leaseTypeOptions count];

  return 0;
}

#pragma mark - Protocol UIPickerViewDelegate

- (void) pickerView: (UIPickerView *) pickerView didSelectRow: (NSInteger) row
        inComponent: (NSInteger) component
{
  // Month Lease
  if (pickerView == monthLeasePicker && isShowPicker) {
    auxRow = (int)row;
  }

  if (pickerView == leaseTypePicker && isShowPicker) {
    auxRow = (int)row;
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
  if (pickerView == monthLeasePicker) {
    string = [monthLeaseOptions objectAtIndex: row];
  }
  // Lease Type
  else if (pickerView == leaseTypePicker) {
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

- (CGFloat) pickerView: (UIPickerView *) pickerView
     widthForComponent: (NSInteger) component
{
	return pickerView.bounds.size.width - 40.0f;
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
  CGFloat padding = 20.0f;
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
      headerTitleCell.clipsToBounds = YES;
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
        openHouseCell.clipsToBounds = YES;
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
        cell1.separatorInset = UIEdgeInsetsMake(0.0f,
          tableView.frame.size.width, 0.0f, 0.0f);

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

      }
      // Lease Type Description
      else if (indexPath.row == 11) {
        static NSString *CellIdentifier = @"LeaseTypeDescription";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 CellIdentifier];
        if (!cell) {
          cell = [[UITableViewCell alloc] initWithStyle:
                  UITableViewCellStyleValue1 reuseIdentifier: CellIdentifier];
        }
        for (UIView *subview in [cell.contentView subviews])
            [subview removeFromSuperview];

        UILabel *label = [UILabel new];
        label.font = [UIFont smallTextFont];
        label.frame = CGRectMake(padding, padding,
                                 tableView.frame.size.width - (padding * 2),
                                 leaseTypeDescriptionSize.height);
        label.numberOfLines = 0;
        label.text = leaseTypeDescription;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayMedium];
        [cell.contentView addSubview: label];

        cell.backgroundColor = [UIColor grayUltraLight];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
                                               0.0f, 0.0f);
        cell.clipsToBounds = YES;
        return cell;
      }
      // View OMB Standard Lease
      else if (indexPath.row == 12) {
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
        linkCell.clipsToBounds = YES;
        return linkCell;
      }

      cell1.textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
                                             size: 15];
      cell1.textField.indexPath = indexPath;
      cell1.textField.tag = indexPath.row;
      cell1.textField.textAlignment = NSTextAlignmentRight;
      cell1.textField.textColor = [UIColor blueDark];
      cell1.textFieldLabel.text = string;
      [cell1.textField addTarget: self action: @selector(textFieldDidChange:)
                forControlEvents: UIControlEventEditingChanged];
      cell1.clipsToBounds = YES;
      return cell1;
    }
  }
  // Delete Listing
  else if (indexPath.section == 2) {
    // Spacing
    if (indexPath.row == 0) {
      headerTitleCell.titleLabel.text = @"";
      headerTitleCell.clipsToBounds = YES;
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
      deleteCell.clipsToBounds = YES;
      return deleteCell;
    }
  }

  // Spacing for when typing
  else if (indexPath.section == 3) {
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
                                           0.0f, 0.0f);
  }
  cell.clipsToBounds = YES;
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
    // Lease Type Description
    // View OMB Standard Lease
    return 13;
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
    if (indexPath.row == 2) {
      [self.table scrollToRowAtIndexPath:
      [NSIndexPath indexPathForRow: 0 inSection: indexPath.section]
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
      [self showPickerView: (UIPickerView *)moveInPicker];
    }
    // Move-out Date
    if (indexPath.row == 4) {
      [self.table scrollToRowAtIndexPath:
       [NSIndexPath indexPathForRow: 0 inSection: indexPath.section]
                        atScrollPosition: UITableViewScrollPositionTop animated: YES];
      [self showPickerView: (UIPickerView *)moveOutPicker];
    }
    // Month Lease
    if (indexPath.row == 6) {
      [self.table scrollToRowAtIndexPath:
       [NSIndexPath indexPathForRow: 0 inSection: indexPath.section]
                        atScrollPosition: UITableViewScrollPositionTop animated: YES];
      [self showPickerView: monthLeasePicker];
    }
    // Lease Type
    if (indexPath.row == 9) {
      [self.table scrollToRowAtIndexPath:
       [NSIndexPath indexPathForRow: 0 inSection: indexPath.section]
                        atScrollPosition: UITableViewScrollPositionTop animated: YES];
      [self showPickerView: leaseTypePicker];
    }
    // Open House Dates
    else if (indexPath.row == 8) {
      [self.navigationController pushViewController:
       [[OMBFinishListingOpenHouseDatesViewController alloc]
        initWithResidence: residence] animated: YES];
    }
    // OMB Standard Lease
    else if (indexPath.row == 12) {
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
      if (indexPath.row == 1) {
        return 0.0f;
      }
      // Move-in  Date date picker
      // Move-out Date date picker
      // Month Lease date picker
      // Lease Type picker view
      if (indexPath.row == 3 || indexPath.row == 5 ||
        indexPath.row == 7 || indexPath.row == 10)
        return 0.0f;

      // Move-out Date
      // Hide the move-out date, we are not using it
      // else if (indexPath.row == 4) {
      //   return 0.0f;
      // }

      // Open House Dates
      else if (indexPath.row == 8) {
        return 0.0f;
      }
      // Lease Type Description
      else if (indexPath.row == 11) {
        return 20.f + leaseTypeDescriptionSize.height + 20.f;
      }
    }
    return 44.0f;
  }
  return 0.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancelPicker
{
  [self updatePicker];
  [self hidePickerView];
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

- (void) donePicker
{
  [self hidePickerView];

  // Move-in Date
  if ([moveInPicker superview]) {
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
      [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForItem:2 inSection:0]];
    residence.moveInDate = [moveInPicker.date timeIntervalSince1970];
    cell.textField.text = [dateFormatter stringFromDate: moveInPicker.date];
    // compare if move out is earlier than move in
    if([[NSDate dateWithTimeIntervalSince1970:residence.moveOutDate]
        compare:moveInPicker.date] == NSOrderedAscending){
      //change move out
      residence.moveOutDate = [moveInPicker.date timeIntervalSince1970];
      OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
        [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForItem:4 inSection:0]];
      cell.textField.text = [dateFormatter stringFromDate: moveInPicker.date];
    }
    residence.leaseMonths = [self numberOfMonthsBetweenMovingDates];
  }
  // Move-out Date
  else if ([moveOutPicker superview]) {
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
    [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
    cell.textField.text = [dateFormatter stringFromDate: moveOutPicker.date];
    residence.moveOutDate = [moveOutPicker.date timeIntervalSince1970];
    // compare if move in is later than move out
    if([[NSDate dateWithTimeIntervalSince1970:residence.moveInDate]
        compare:moveOutPicker.date] == NSOrderedDescending){
      //change move in
      residence.moveInDate = [moveOutPicker.date timeIntervalSince1970];
      OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
      [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForItem:2 inSection:0]];
      cell.textField.text = [dateFormatter stringFromDate: moveOutPicker.date];
    }
    residence.leaseMonths = [self numberOfMonthsBetweenMovingDates];
  }

  // Month Lease
  if ([monthLeasePicker superview]) {
    NSString *string = @"";
    string = [monthLeaseOptions objectAtIndex: auxRow];
    residence.leaseMonths = auxRow;
    if(residence.moveInDate){
      NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
      [dateComponents setMonth:auxRow];
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

  // Lease type
  if ([leaseTypePicker superview]) {
    NSString *string = [leaseTypeOptions objectAtIndex: auxRow];
    residence.leaseType = string;
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
    [self.table cellForRowAtIndexPath:
      [NSIndexPath indexPathForItem:9 inSection:0]];
    cell.textField.text = string;
  }

  [self updatePicker];
}

- (void) hidePickerView
{
  //[self hideNeighborhoodTableViewContainer];
  isShowPicker = NO;
  CGRect rect = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 0.0f;
    pickerViewContainer.frame = rect;
  }];
  //[self showSearchBarButtonItem];
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

- (void) removePickers
{
  [leaseTypePicker removeFromSuperview];
  [monthLeasePicker removeFromSuperview];
  [moveInPicker removeFromSuperview];
  [moveOutPicker removeFromSuperview];
}

- (void) showPickerView:(UIPickerView *)pickerView
{
  NSString *titlePicker = @"";
  [self removePickers];
  if ((UIPickerView *)moveInPicker == pickerView) {
		titlePicker = @"Move-in Date";
		[pickerViewContainer addSubview:moveInPicker];
	}
  if ((UIPickerView *)moveOutPicker == pickerView) {
		titlePicker = @"Move-out Date";
		[pickerViewContainer addSubview:moveOutPicker];
	}
	if (monthLeasePicker == pickerView) {
		titlePicker = @"Month Lease";
		[pickerViewContainer addSubview:monthLeasePicker];
	}
  if (leaseTypePicker == pickerView) {
		titlePicker = @"Lease Type";
		[pickerViewContainer addSubview:leaseTypePicker];
	}
	pickerViewHeaderLabel.text = titlePicker;
  isShowPicker = YES;
  CGRect rect = pickerViewContainer.frame;
  rect.origin.y = self.view.frame.size.height -
  pickerViewContainer.frame.size.height;
  [UIView animateWithDuration: 0.25 animations: ^{
    fadedBackground.alpha = 1.0f;
    pickerViewContainer.frame = rect;
  }];
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


- (void) updateLeaseTypeDescription:(NSInteger)selection
{
  if(selection == 0){
    leaseTypeDescription = @"The OnmyBlock Standard Lease is a California\n"
                          @"realtor approved lease containing all the\n"
                          @"necessary clauses and memos of\n"
                          @"disclosure for optimal\n"
    @"professional use.";
  }
  else if(selection == 1){
    leaseTypeDescription = @"You may create your listing now, but you will\n"
                          @"need to upload your own lease\n"
    @"using desktop OnMyBlock.";
  }
  else if(selection == 2){
    leaseTypeDescription = @"If you are subletting your place, please ensure\n"
                          @"that you have carefully read the subletting\n"
                          @"clause of your current lease or have\n"
    @"consulted with your landlord.";
  }
  CGRect rect = [leaseTypeDescription boundingRectWithSize:
    CGSizeMake(self.table.frame.size.width - (20.0f * 2), 9999)
      font: [UIFont smallTextFont]];
  leaseTypeDescriptionSize = rect.size;
}

- (void) updatePicker
{
  // Move-in date picker
  [moveInPicker setDate:
   [NSDate dateWithTimeIntervalSince1970: residence.moveInDate]
               animated: NO];

  // Move-out date picker
  [moveOutPicker setDate:
   [NSDate dateWithTimeIntervalSince1970: residence.moveOutDate]
                animated: NO];

  // Month lease picker
  NSInteger selectedMonthRow = residence.leaseMonths;
  [monthLeasePicker selectRow: selectedMonthRow inComponent: 0
     animated: NO];
  OMBLabelTextFieldCell *cell2 = (OMBLabelTextFieldCell *)
    [self.table cellForRowAtIndexPath:
     [NSIndexPath indexPathForItem:6 inSection:0]];
  cell2.textField.text = monthLeaseOptions[residence.leaseMonths];

  // Lease type picker
  NSInteger selectedLeaseRow = 0;
  if (residence.leaseType) {
    selectedLeaseRow = [leaseTypeOptions indexOfObjectPassingTest:
                        ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
                          return [[obj lowercaseString] isEqualToString:
                                  [residence.leaseType lowercaseString]];
                        }
                        ];
    if (selectedLeaseRow == NSNotFound)
      selectedLeaseRow = 0;
  }
  [self updateLeaseTypeDescription: selectedLeaseRow];
  [self.table reloadRowsAtIndexPaths:
   @[[NSIndexPath indexPathForRow: 11 inSection: 0]]
                    withRowAnimation: UITableViewRowAnimationNone];
  [leaseTypePicker selectRow: selectedLeaseRow inComponent: 0
                    animated: NO];
}
@end
