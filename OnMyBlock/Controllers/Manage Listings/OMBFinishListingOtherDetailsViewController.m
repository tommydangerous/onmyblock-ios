//
//  OMBFinishListingOtherDetailsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingOtherDetailsViewController.h"

#import "OMBDatePickerCell.h"
#import "OMBFinishListingAmenitiesViewController.h"
#import "OMBHeaderTitleCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBPickerViewCell.h"
#import "OMBStandardLeaseViewController.h"

float kKeyboardHeight = 216.0;

// Tags
int kBottomBorderTag           = 9999;
int kPropertyTypePickerViewTag = 5555;
int kMoveInDatePickerTag       = 5554;
int kMoveOutDatePickerTag      = 5553;
int kOpenHouse1DatePickerTag   = 5552;
int kOpenHouse2DatePickerTag   = 5551;
int kLeaseTypePickerViewTag    = 5550;

@implementation OMBFinishListingOtherDetailsViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  leaseTypeOptions = @[
    @"OMB Standard Lease",
    @"Contact Me"
  ];

  propertyTypeOptions = @[
    @"sublet",
    @"house",
    @"apartment"
  ];

  self.screenName = self.title = @"Other Details";

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
  if (pickerView.tag == kPropertyTypePickerViewTag) {
    return 1;
  }
  else if (pickerView.tag == kLeaseTypePickerViewTag) {
    return 1;
  }
  return 0;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView
numberOfRowsInComponent: (NSInteger) component
{
  if (pickerView.tag == kPropertyTypePickerViewTag) {
    return [propertyTypeOptions count];
  }
  else if (pickerView.tag == kLeaseTypePickerViewTag) {
    return [leaseTypeOptions count];
  }
  return 0;
}

#pragma mark - Protocol UIPickerViewDelegate

- (void) pickerView: (UIPickerView *) pickerView didSelectRow: (NSInteger) row
inComponent: (NSInteger) component
{
  if (pickerView.tag == kPropertyTypePickerViewTag ||
    pickerView.tag == kLeaseTypePickerViewTag) {

    NSIndexPath *indexPath;
    NSString *string = @"";
    // Property Type
    if (pickerView.tag == kPropertyTypePickerViewTag) {
      indexPath = [NSIndexPath indexPathForRow: 4 inSection: 0];
      string = [[propertyTypeOptions objectAtIndex: row] capitalizedString];
    }
    // Lease Type
    else if (pickerView.tag == kLeaseTypePickerViewTag) {
      indexPath = [NSIndexPath indexPathForRow: 11 inSection: 1];
      string = [leaseTypeOptions objectAtIndex: row];
    }
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *) 
      [self.table cellForRowAtIndexPath: indexPath];
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
  // Property Type
  if (pickerView.tag == kPropertyTypePickerViewTag) {
    string = [[propertyTypeOptions objectAtIndex: row] capitalizedString];
  }
  // Lease Type
  else if (pickerView.tag == kLeaseTypePickerViewTag) {
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
  // Listing Details
  // Lease & Open House
  // Amenities
  // Delete Listing
  // Spacing for when typing
  return 5;
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

  // Listing Details
  if (indexPath.section == 0) {
    // Spacing
    if (indexPath.row == 0) {
      cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
        0.0f, 0.0f);
    }
    // Header title
    else if (indexPath.row == 1) {
      headerTitleCell.titleLabel.text = @"Listing Details";
      return headerTitleCell;
    }
    else {
      static NSString *TextFieldCellIdentifier = @"TextFieldCellIdentifier";
      OMBLabelTextFieldCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier: TextFieldCellIdentifier];
      if (!cell1)
        cell1 = [[OMBLabelTextFieldCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: TextFieldCellIdentifier];
      cell1.selectionStyle = UITableViewCellSelectionStyleNone;
      cell1.textField.userInteractionEnabled = YES;
      // Bottom border
      UIView *bottomBorder = [cell1.contentView viewWithTag: kBottomBorderTag];
      if (bottomBorder) {
        [bottomBorder removeFromSuperview];
      }
      else {
        bottomBorder = [UIView new];
        bottomBorder.backgroundColor = [UIColor grayLight];
        bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
          tableView.frame.size.width, 0.5f);
        bottomBorder.tag = kBottomBorderTag;
      }
      NSString *string = @"";
      // Bedrooms
      if (indexPath.row == 2) {
        string = @"Bedrooms";
        cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell1.textField.text = @"2";
      }
      // Bathrooms
      else if (indexPath.row == 3) {
        string = @"Bathrooms";
        cell1.textField.keyboardType = UIKeyboardTypeDecimalPad;
        cell1.textField.text = @"1";
      }
      // Property type
      else if (indexPath.row == 4) {
        string = @"Property Type";
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell1.textField.text = @"Sublet";
        cell1.textField.userInteractionEnabled = NO;
      }
      // Picker view
      else if (indexPath.row == 5) {
        static NSString *PickerCellIdentifier = @"PickerCellIdentifier";
        OMBPickerViewCell *pickerCell = 
          [tableView dequeueReusableCellWithIdentifier: PickerCellIdentifier];
        if (!pickerCell)
          pickerCell = [[OMBPickerViewCell alloc] initWithStyle: 
            UITableViewCellStyleDefault reuseIdentifier: PickerCellIdentifier];
        pickerCell.pickerView.dataSource = self;
        pickerCell.pickerView.delegate   = self;
        pickerCell.pickerView.tag = kPropertyTypePickerViewTag;
        [pickerCell.pickerView selectRow: 1 inComponent: 0 animated: NO];
        return pickerCell;
      }
      // Square footage
      else if (indexPath.row == 6) {
        string = @"Sq Footage";
        cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell1.textField.placeholder = @"optional";
        // Add bottom border
        [cell1.contentView addSubview: bottomBorder];
      }
      cell1.textField.delegate = self;
      cell1.textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
        size: 15];
      cell1.textField.indexPath = indexPath;
      cell1.textField.tag = indexPath.row;
      cell1.textField.textAlignment = NSTextAlignmentRight;
      cell1.textField.textColor = [UIColor blueDark];
      cell1.textFieldLabel.text = string;
      [cell1 setFramesUsingString: @"Move-out Date"];
      return cell1;
    }
  }

  // Lease & Open House
  else if (indexPath.section == 1) {
    // Spacing
    if (indexPath.row == 0) {
      cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
        0.0f, 0.0f);
    }
    // Header title
    else if (indexPath.row == 1) {
      headerTitleCell.titleLabel.text = @"Lease & Open House";
      return headerTitleCell;
    }
    else {
      // Text field cell
      static NSString *TextFieldCellIdentifier = @"TextFieldCellIdentifier";
      OMBLabelTextFieldCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier: TextFieldCellIdentifier];
      if (!cell1)
        cell1 = [[OMBLabelTextFieldCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: TextFieldCellIdentifier];
      cell1.selectionStyle = UITableViewCellSelectionStyleNone;
      cell1.textField.userInteractionEnabled = YES;
      NSString *string = @"";
      // Move-in Date
      if (indexPath.row == 2) {
        string = @"Move-in Date";
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell1.textField.placeholder = @"required";
        cell1.textField.userInteractionEnabled = NO;
      }
      // Date picker
      else if (indexPath.row == 3) {
        // Date picker cell
        static NSString *DatePickerCellIdentifier1 = 
          @"DatePickerCellIdentifier1";
        OMBDatePickerCell *datePickerCell = 
          [tableView dequeueReusableCellWithIdentifier:
            DatePickerCellIdentifier1];
        if (!datePickerCell)
          datePickerCell = [[OMBDatePickerCell alloc] initWithStyle: 
            UITableViewCellStyleDefault reuseIdentifier: 
              DatePickerCellIdentifier1];
        [datePickerCell.datePicker addTarget: self 
          action: @selector(datePickerChanged:)
            forControlEvents: UIControlEventValueChanged];
        datePickerCell.datePicker.datePickerMode = UIDatePickerModeDate;
        datePickerCell.datePicker.tag = kMoveInDatePickerTag;
        return datePickerCell;
      }
      // Move-out Date
      else if (indexPath.row == 4) {
        string = @"Move-out Date";
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell1.textField.placeholder = @"required";
        cell1.textField.userInteractionEnabled = NO;
      }
      // Date Picker
      else if (indexPath.row == 5) {
        // Date picker cell
        static NSString *DatePickerCellIdentifier2 = 
          @"DatePickerCellIdentifier2";
        OMBDatePickerCell *datePickerCell = 
          [tableView dequeueReusableCellWithIdentifier:
            DatePickerCellIdentifier2];
        if (!datePickerCell)
          datePickerCell = [[OMBDatePickerCell alloc] initWithStyle: 
            UITableViewCellStyleDefault reuseIdentifier: 
              DatePickerCellIdentifier2];
        [datePickerCell.datePicker addTarget: self 
          action: @selector(datePickerChanged:)
            forControlEvents: UIControlEventValueChanged];
        datePickerCell.datePicker.datePickerMode = UIDatePickerModeDate;
        datePickerCell.datePicker.tag = kMoveOutDatePickerTag;
        return datePickerCell;
      }
      // Month Lease
      else if (indexPath.row == 6) {
        string = @"Month Lease";
        cell1.textField.indexPath = indexPath;
        cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell1.textField.text = @"12";
      }
      // Open House 1
      else if (indexPath.row == 7) {
        string = @"Open House 1";
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell1.textField.userInteractionEnabled = NO;
      }
      // Date Picker (date and time)
      else if (indexPath.row == 8) {
        // Date picker cell
        static NSString *DatePickerCellIdentifier3 = 
          @"DatePickerCellIdentifier3";
        OMBDatePickerCell *datePickerCell = 
          [tableView dequeueReusableCellWithIdentifier:
            DatePickerCellIdentifier3];
        if (!datePickerCell)
          datePickerCell = [[OMBDatePickerCell alloc] initWithStyle: 
            UITableViewCellStyleDefault reuseIdentifier: 
              DatePickerCellIdentifier3];
        [datePickerCell.datePicker addTarget: self 
          action: @selector(datePickerChanged:)
            forControlEvents: UIControlEventValueChanged];
        datePickerCell.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePickerCell.datePicker.tag = kOpenHouse1DatePickerTag;
        return datePickerCell;
      }
      // Open House 2
      else if (indexPath.row == 9) {
        string = @"Open House 2";
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell1.textField.userInteractionEnabled = NO;
      }
      // Date Picker (date and time)
      else if (indexPath.row == 10) {
        // Date picker cell
        static NSString *DatePickerCellIdentifier4 = 
          @"DatePickerCellIdentifier4";
        OMBDatePickerCell *datePickerCell = 
          [tableView dequeueReusableCellWithIdentifier:
            DatePickerCellIdentifier4];
        if (!datePickerCell)
          datePickerCell = [[OMBDatePickerCell alloc] initWithStyle: 
            UITableViewCellStyleDefault reuseIdentifier: 
              DatePickerCellIdentifier4];
        [datePickerCell.datePicker addTarget: self 
          action: @selector(datePickerChanged:)
            forControlEvents: UIControlEventValueChanged];
        datePickerCell.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePickerCell.datePicker.tag = kOpenHouse2DatePickerTag;
        return datePickerCell;
      }
      // Lease Type
      else if (indexPath.row == 11) {
        string = @"Lease Type";
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
      // Picker View
      else if (indexPath.row == 12) {
        static NSString *PickerCellIdentifier = @"PickerCellIdentifier";
        OMBPickerViewCell *pickerCell = 
          [tableView dequeueReusableCellWithIdentifier: PickerCellIdentifier];
        if (!pickerCell)
          pickerCell = [[OMBPickerViewCell alloc] initWithStyle: 
            UITableViewCellStyleDefault reuseIdentifier: PickerCellIdentifier];
        pickerCell.pickerView.dataSource = self;
        pickerCell.pickerView.delegate   = self;
        pickerCell.pickerView.tag = kLeaseTypePickerViewTag;
        [pickerCell.pickerView selectRow: 0 inComponent: 0 animated: NO];

        // Bottom border
        // Use layer because after clicking the row, the view goes away
        CALayer *bottomBorderLayer = [CALayer layer];
        bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
        bottomBorderLayer.frame = CGRectMake(0.0f, kKeyboardHeight - 0.5f, 
          tableView.frame.size.width, 0.5f);
        [pickerCell.contentView.layer addSublayer: bottomBorderLayer];

        return pickerCell;
      }
      // View OMB Standard Lease
      else if (indexPath.row == 13) {
        static NSString *LinkCellIdentifier = @"LinkCellIdentifier";
        UITableViewCell *linkCell = 
          [tableView dequeueReusableCellWithIdentifier: LinkCellIdentifier];
        if (!linkCell)
          linkCell = [[UITableViewCell alloc] initWithStyle: 
            UITableViewCellStyleValue1 reuseIdentifier: LinkCellIdentifier];
        linkCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        linkCell.backgroundColor = tableView.backgroundColor;
        linkCell.selectionStyle = UITableViewCellSelectionStyleNone;
        linkCell.separatorInset = UIEdgeInsetsMake(0.0f,
          tableView.frame.size.width, 0.0f, 0.0f);
        // View OMB Standard Lease label
        UILabel *label = (UILabel *) [linkCell.contentView viewWithTag: 7777];
        if (!label) {
          label = [UILabel new];
          label.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 13];
          label.frame = CGRectMake(0.0f, 0.0f, 
            tableView.frame.size.width - (20.0f * 2), 44.0f);
          label.text = @"View OMB Standard Lease";
          label.textAlignment = NSTextAlignmentRight;
          label.textColor = [UIColor blue];
        }
        [linkCell.contentView addSubview: label];
        return linkCell;
      }

      cell1.textField.delegate = self;
      cell1.textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" 
        size: 15];
      cell1.textField.tag = indexPath.row;
      cell1.textField.textAlignment = NSTextAlignmentRight;
      cell1.textField.textColor = [UIColor blueDark];
      cell1.textFieldLabel.text = string;
      [cell1 setFramesUsingString: @"Move-out Date"];
      return cell1;
    }
  }

  // Amenities
  else if (indexPath.section == 2) {
    // Spacing
    if (indexPath.row == 0) {
      headerTitleCell.titleLabel.text = @"";
      return headerTitleCell;
    }
    // Amenities
    else if (indexPath.row == 1) {
      // Amenities Cell
      static NSString *AmenitiesCellIdentifier = @"AmenitiesCellIdentifier";
      UITableViewCell *amenitiesCell = 
        [tableView dequeueReusableCellWithIdentifier: AmenitiesCellIdentifier];
      if (!amenitiesCell)
        amenitiesCell = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: AmenitiesCellIdentifier];
      amenitiesCell.textLabel.font = [UIFont fontWithName: 
        @"HelveticaNeue-Light" size: 15];
      amenitiesCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      amenitiesCell.backgroundColor = [UIColor whiteColor];
      amenitiesCell.textLabel.text = @"Amenities (5)";
      amenitiesCell.textLabel.textColor = [UIColor textColor];

      // Bottom border
      // Use layer because after clicking the row, the view goes away
      CALayer *bottomBorderLayer = [CALayer layer];
      bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
      bottomBorderLayer.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
        tableView.frame.size.width, 0.5f);
      [amenitiesCell.contentView.layer addSublayer: bottomBorderLayer];

      return amenitiesCell;
    }
  }

  // Delete Listing
  else if (indexPath.section == 3) {
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
        label.text = @"Delete Listing";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor red];
      }
      [deleteCell.contentView addSubview: label];
      
      // Bottom border
      // Use layer because after clicking the row, the view goes away
      CALayer *bottomBorderLayer = [CALayer layer];
      bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
      bottomBorderLayer.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
        tableView.frame.size.width, 0.5f);
      [deleteCell.contentView.layer addSublayer: bottomBorderLayer];

      return deleteCell;
    }
  }

  // Spaing for when typing
  else if (indexPath.section == 4) {
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
  }

  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  // Listing Details
  if (section == 0) {
    // Spacing
    // Header title
    // Bedrooms
    // Bathrooms
    // Property Type
    // - Picker view
    // Sq Footage
    return 7;
  }
  // Lease & Open House
  else if (section == 1) {
    // Spacing
    // Header title
    // Move-in Date
    // - Date picker
    // Move-out Date
    // - Date Picker
    // Month Lease
    // Open House 1
    // - Date Picker
    // Open House 2
    // - Date Picker
    // Lease Type
    // - Picker view
    // View OMB Standard Lease
    return 14;
  }
  // Amenities
  else if (section == 2) {
    // Spacing
    // Amenities
    return 2;
  }
  // Delete Listing
  else if (section == 3) {
    // Spacing
    // Delete Listing
    return 2;
  }
  // Spacing for when typing
  else if (section == 4) {
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
  // Listing Details
  if (indexPath.section == 0) {
    // Property Type
    if (indexPath.row == 4) {
      isEditingLeaseType    = NO;
      isEditingMoveInDate   = NO;
      isEditingMoveOutDate  = NO;
      isEditingOpenHouse1   = NO;
      isEditingOpenHouse2   = NO;
      isEditingPropertyType = !isEditingPropertyType;
      [self reloadForDatePickerAndPickerViewRowsAtIndexPath: indexPath];
    }
  }
  // Lease & Open House
  else if (indexPath.section == 1) {
    // Move-in Date
    if (indexPath.row == 2) {
      isEditingLeaseType    = NO;
      isEditingMoveInDate   = !isEditingMoveInDate;
      isEditingMoveOutDate  = NO;
      isEditingOpenHouse1   = NO;
      isEditingOpenHouse2   = NO;
      isEditingPropertyType = NO;
      [self reloadForDatePickerAndPickerViewRowsAtIndexPath: indexPath];
    }
    // Move-out Date
    else if (indexPath.row == 4) {
      isEditingLeaseType    = NO;
      isEditingMoveInDate   = NO;
      isEditingMoveOutDate  = !isEditingMoveOutDate;
      isEditingOpenHouse1   = NO;
      isEditingOpenHouse2   = NO;
      isEditingPropertyType = NO;
      [self reloadForDatePickerAndPickerViewRowsAtIndexPath: indexPath];
    }
    // Open House 1
    else if (indexPath.row == 7) {
      isEditingLeaseType    = NO;
      isEditingMoveInDate   = NO;
      isEditingMoveOutDate  = NO;
      isEditingOpenHouse1   = !isEditingOpenHouse1;
      isEditingOpenHouse2   = NO;
      isEditingPropertyType = NO;
      [self reloadForDatePickerAndPickerViewRowsAtIndexPath: indexPath];
    }
    // Open House 2
    else if (indexPath.row == 9) {
      isEditingLeaseType    = NO;
      isEditingMoveInDate   = NO;
      isEditingMoveOutDate  = NO;
      isEditingOpenHouse1   = NO;
      isEditingOpenHouse2   = !isEditingOpenHouse2;
      isEditingPropertyType = NO;
      [self reloadForDatePickerAndPickerViewRowsAtIndexPath: indexPath];
    }
    // Lease Type
    else if (indexPath.row == 11) {
      isEditingLeaseType    = !isEditingLeaseType;
      isEditingMoveInDate   = NO;
      isEditingMoveOutDate  = NO;
      isEditingOpenHouse1   = NO;
      isEditingOpenHouse2   = NO;
      isEditingPropertyType = NO;
      [self reloadForDatePickerAndPickerViewRowsAtIndexPath: indexPath];
    }
    // OMB Standard Lease
    else if (indexPath.row == 13) {
      [self.navigationController pushViewController: 
        [[OMBStandardLeaseViewController alloc] init] animated: YES];
    }
  }
  // Amenities
  else if (indexPath.section == 2) {
    if (indexPath.row == 1) {
      [self.navigationController pushViewController:
        [[OMBFinishListingAmenitiesViewController alloc] initWithResidence: 
          residence] animated: YES];
    }
  }
  // Delete Listing
  else if (indexPath.section == 3) {
    [deleteActionSheet showInView: self.view];
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
    // Listing Details
    if (indexPath.section == 0) {
      // Property Type picker view 
      if (indexPath.row == 5) {
        if (isEditingPropertyType) {
          return kKeyboardHeight;
        }
        else {
          return 0.0f;
        }
      }
    }
    // Lease & Open House
    else if (indexPath.section == 1) {
      // Move-in Date date picker
      if (indexPath.row == 3) {
        if (isEditingMoveInDate) {
          return kKeyboardHeight;
        }
        else {
          return 0.0f;
        }
      }
      // Move-out Date date picker
      else if (indexPath.row == 5) {
        if (isEditingMoveOutDate) {
          return kKeyboardHeight;
        }
        else {
          return 0.0f;
        }
      }
      // Open House 1 date picker
      else if (indexPath.row == 8) {
        if (isEditingOpenHouse1) {
          return kKeyboardHeight;
        }
        else {
          return 0.0f;
        }
      }
      // Open House 2 date picker
      else if (indexPath.row == 10) {
        if (isEditingOpenHouse2) {
          return kKeyboardHeight;
        }
        else {
          return 0.0f;
        }
      }
      // Lease Type picker view
      else if (indexPath.row == 12) {
        if (isEditingLeaseType) {
          return kKeyboardHeight;
        }
        else {
          return 0.0f;
        }
      }
    }
    return 44.0f;
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  isEditing             = YES;
  isEditingLeaseType    = NO;
  isEditingMoveInDate   = NO;
  isEditingMoveOutDate  = NO;
  isEditingOpenHouse1   = NO;
  isEditingOpenHouse2   = NO;
  isEditingPropertyType = NO;
  [self reloadPickerRows];
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
  [textField resignFirstResponder];
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) datePickerChanged: (UIDatePicker *) datePicker
{
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"MMMM d, yyyy";
  NSDateFormatter *dateTimeFormatter = [NSDateFormatter new];
  dateTimeFormatter.dateFormat = @"MMM d, yy   h:mm a";
  int row = 0;
  if (datePicker.tag == kMoveInDatePickerTag   || 
    datePicker.tag == kMoveOutDatePickerTag    ||
    datePicker.tag == kOpenHouse1DatePickerTag ||
    datePicker.tag == kOpenHouse2DatePickerTag) {

    NSString *dateString = [dateFormatter stringFromDate: datePicker.date];
    if (datePicker.tag == kMoveInDatePickerTag) {
      row = 2;
    }
    else if (datePicker.tag == kMoveOutDatePickerTag) {
      row = 4;
    }
    else if (datePicker.tag == kOpenHouse1DatePickerTag) {
      row = 7;
      dateString = [dateTimeFormatter stringFromDate: datePicker.date];
    }
    else if (datePicker.tag == kOpenHouse2DatePickerTag) {
      row = 9;
      dateString = [dateTimeFormatter stringFromDate: datePicker.date];
      NSLog(@"%@", dateString);
    }
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *) 
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: row inSection: 1]];
    cell.textField.text = dateString;
  }
}

- (void) deleteListing
{
  NSLog(@"DELETE LISTING");
  [self.navigationController popToRootViewControllerAnimated: NO];
}

- (void) done
{
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
  [self.view endEditing: YES];
  isEditing = NO;
  [self.table reloadRowsAtIndexPaths: @[
    [NSIndexPath indexPathForRow: 1 
      inSection: [self.table numberOfSections] - 1]
    ] 
    withRowAnimation: UITableViewRowAnimationFade];
}

- (void) reloadPickerRows
{
  NSArray *rows = @[
    // Property Type picker view
    [NSIndexPath indexPathForRow: 5 inSection: 0],
    // Move-in Date date picker
    [NSIndexPath indexPathForRow: 3 inSection: 1],
    // Move-out Date date picker
    [NSIndexPath indexPathForRow: 5 inSection: 1],
    // Open House 1
    [NSIndexPath indexPathForRow: 8 inSection: 1],
    // Open House 2
    [NSIndexPath indexPathForRow: 10 inSection: 1],
    // Lease Type picker view
    [NSIndexPath indexPathForRow: 12 inSection: 1],
    // The spacing section at the bottom
    [NSIndexPath indexPathForRow: 1 
      inSection: [self.table numberOfSections] - 1]
  ];
  // Reload rows
  [self.table reloadRowsAtIndexPaths: rows
    withRowAnimation: UITableViewRowAnimationFade];
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem];
}

- (void) reloadForDatePickerAndPickerViewRowsAtIndexPath: 
(NSIndexPath *) indexPath
{
  isEditing = NO;
  // [self reloadPickerRows];
  [self.view endEditing: YES];
  // [self scrollToRowAtIndexPath: indexPath];

  [self.table beginUpdates];
  [self.table endUpdates];
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem];
}

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.table scrollToRowAtIndexPath: indexPath 
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

@end
