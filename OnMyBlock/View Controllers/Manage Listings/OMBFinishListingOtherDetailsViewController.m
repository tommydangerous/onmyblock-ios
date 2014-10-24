//
//  OMBFinishListingOtherDetailsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingOtherDetailsViewController.h"

#import "OMBActivityView.h"
#import "OMBHeaderTitleCell.h"
#import "OMBLabelTextFieldCell.h"
#import "OMBPickerViewCell.h"
#import "OMBResidence.h"
#import "OMBResidenceDeleteConnection.h"
#import "OMBResidenceOpenHouseListConnection.h"
#import "OMBResidenceUpdateConnection.h"
#import "OMBViewControllerContainer.h"

float kKeyboardHeight = 196.0;

// Tags
// int kBottomBorderTag = 9999;

@implementation OMBFinishListingOtherDetailsViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  propertyTypeOptions = @[
    @"house",
    @"apartment",
    @"sublet"
  ];
  CGRect rect = [@"Property Type" boundingRectWithSize:
    CGSizeMake(9999, OMBStandardHeight) font: [UIFont normalTextFont]];
  sizeForLabelTextFieldCell = rect.size;

  self.screenName = self.title = @"Listing Details";
  tagSection = OMBFinishListingSectionListingDetails;

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

//  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
//  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
//    style: UIBarButtonItemStylePlain target: self action: @selector(done)];
//  [doneBarButtonItem setTitleTextAttributes: @{
//    NSFontAttributeName: boldFont
//  } forState: UIControlStateNormal];


  saveBarButtonItem.enabled = YES;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  deleteActionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self
    cancelButtonTitle: @"Cancel" destructiveButtonTitle: @"Delete Listing"
      otherButtonTitles: nil];
  [self.view addSubview: deleteActionSheet];

	isShowPicker = NO;

	// Spacing
	UIBarButtonItem *flexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
	 UIBarButtonSystemItemFlexibleSpace target: nil action: nil];

	// Left padding
	UIBarButtonItem *leftPadding =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
	 UIBarButtonSystemItemFixedSpace target: nil action: nil];
	// iOS 7 toolbar spacing is 16px; 20px on iPad
	leftPadding.width = 4.0f;

	// Cancel
	UIBarButtonItem *cancelBarButtonItemForTextFieldToolbar =
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
									 style: UIBarButtonItemStylePlain target: self
									action: @selector(cancelFromInputAccessoryView)];

	// Done
	UIBarButtonItem *doneBarButtonItemForTextFieldToolbar =
    [[UIBarButtonItem alloc] initWithTitle: @"Done"
									 style: UIBarButtonItemStylePlain target: self
									action: @selector(done)];

	// Right padding
	UIBarButtonItem *rightPadding =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
	 UIBarButtonSystemItemFixedSpace target: nil action: nil];
	// iOS 7 toolbar spacing is 16px; 20px on iPad
	rightPadding.width = 4.0f;

	textFieldToolbar = [UIToolbar new];
	textFieldToolbar.clipsToBounds = YES;
	textFieldToolbar.frame = CGRectMake(0.0f, 0.0f,
										[[UIScreen mainScreen] bounds].size.width, OMBStandardHeight);
	textFieldToolbar.items = @[leftPadding,
							   cancelBarButtonItemForTextFieldToolbar,
							   flexibleSpace,
							   doneBarButtonItemForTextFieldToolbar,
							   rightPadding];
	textFieldToolbar.tintColor = [UIColor blue];

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

  // Lease type picker
  propertyTypePicker = [[UIPickerView alloc] init];
  propertyTypePicker.backgroundColor = [UIColor whiteColor];
  propertyTypePicker.dataSource = self;
  propertyTypePicker.delegate   = self;
  propertyTypePicker.frame = CGRectMake(0.0f,
    pickerViewHeader.frame.origin.y +
      pickerViewHeader.frame.size.height,
        propertyTypePicker.frame.size.width, propertyTypePicker.frame.size.height);

  pickerViewContainer.frame = CGRectMake(0.0f, self.view.frame.size.height,
    propertyTypePicker.frame.size.width,
      pickerViewHeader.frame.size.height +
        propertyTypePicker.frame.size.height);
}

- (void) cancelFromInputAccessoryView
{
	editingTextField.text = savedTextFieldString;
	[self done];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  // List Connection
  /*OMBResidenceOpenHouseListConnection *conn =
    [[OMBResidenceOpenHouseListConnection alloc] initWithResidence:
      residence];*/

  // Property type picker
  NSUInteger passingIndex =
  [propertyTypeOptions indexOfObjectPassingTest:
   ^BOOL (id obj, NSUInteger idx, BOOL *stop){
     return [obj isEqualToString:
       [residence.propertyType lowercaseString]];
   }
   ];
  if (passingIndex == NSNotFound)
    passingIndex = 0;
  [propertyTypePicker selectRow: passingIndex
                    inComponent: 0 animated: NO];


  [self.table reloadData];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];

  if (residence) {
    OMBResidenceUpdateConnection *conn =
      [[OMBResidenceUpdateConnection alloc] initWithResidence: residence
        attributes: @[
          @"bathrooms",
          @"bedrooms",
          // @"leaseMonths",
          // @"leaseType",
          // @"moveInDate",
          @"propertyType",
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

#pragma mark - Protocol UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [self.navigationController popToRootViewControllerAnimated: YES];
}

#pragma mark - Protocol UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
  return 1;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView
numberOfRowsInComponent: (NSInteger) component
{
  // Property type
  if (pickerView == propertyTypePicker)
    return [propertyTypeOptions count];

  return 0;
}

#pragma mark - Protocol UIPickerViewDelegate

- (void) pickerView: (UIPickerView *) pickerView didSelectRow: (NSInteger) row
inComponent: (NSInteger) component
{
  // Property type
  if (pickerView == propertyTypePicker && isShowPicker) {
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
  // Property type
  if (pickerView == propertyTypePicker) {
    string = [[propertyTypeOptions objectAtIndex: row] capitalizedString];
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
  // Delete Listing
  // Spacing for when typing
  return 4;
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

  UIEdgeInsets maxEdgeInsets = UIEdgeInsetsMake(0.0f,
    tableView.frame.size.width, 0.0f, 0.0f);

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
      cell.separatorInset = maxEdgeInsets;
    }
    // Header title
    else if (indexPath.row == 1) {
      headerTitleCell.titleLabel.text = @"Listing Details";
      headerTitleCell.clipsToBounds = YES;
      return headerTitleCell;
    }
    // Bedrooms, Bathrooms, Property Type, picker view, Square Footage
    else {
      static NSString *TextFieldCellIdentifier = @"TextFieldCellIdentifier";
      OMBLabelTextFieldCell *cell1 =
      [tableView dequeueReusableCellWithIdentifier: TextFieldCellIdentifier];
      if (!cell1) {
        cell1 = [[OMBLabelTextFieldCell alloc] initWithStyle:
          UITableViewCellStyleDefault reuseIdentifier: TextFieldCellIdentifier];
        [cell1 setFrameUsingSize: sizeForLabelTextFieldCell];
      }
      cell1.selectionStyle = UITableViewCellSelectionStyleNone;
      cell1.textField.placeholderColor = [UIColor grayLight];
      cell1.textField.placeholder = @"required";
      cell1.textField.userInteractionEnabled = YES;
		  cell1.textField.inputAccessoryView = textFieldToolbar;
      NSString *string = @"";
      // Bedrooms
      if (indexPath.row == 2) {
        string = @"Bedrooms";
        cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell1.textField.text = [NSString stringWithFormat: @"%0.0f",
          residence.bedrooms];
      }
      // Bathrooms
      else if (indexPath.row == 3) {
        string = @"Bathrooms";
        cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell1.textField.text = [NSString stringWithFormat: @"%0.0f",
          residence.bathrooms];
      }
      // Property type
      else if (indexPath.row == 4) {
        string = @"Property Type";
        cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell1.separatorInset = maxEdgeInsets;
        cell1.textField.placeholder = @"optional";
        cell1.textField.text = [residence.propertyType capitalizedString];
        cell1.textField.userInteractionEnabled = NO;
      }
      // Picker view
      else if (indexPath.row == 5) {

      }
      // Square footage
      else if (indexPath.row == 6) {
        string = @"Sq Footage";
        cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell1.textField.placeholder = @"optional";
        if (residence.squareFeet)
          cell1.textField.text = [NSString stringWithFormat: @"%i",
                                  residence.squareFeet];
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
      CALayer *bottomBorderLayer = [CALayer layer];
      bottomBorderLayer.backgroundColor = tableView.separatorColor.CGColor;
      bottomBorderLayer.frame = CGRectMake(0.0f, 44.0f - 0.5f,
        tableView.frame.size.width, 0.5f);
      [deleteCell.contentView.layer addSublayer: bottomBorderLayer];
      deleteCell.clipsToBounds = YES;
      return deleteCell;
    }
  }

  // Spacing for when typing
  else if (indexPath.section == 3) {
    cell.separatorInset = maxEdgeInsets;
  }
  cell.clipsToBounds = YES;
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
  // Delete Listing
  else if (section == 2) {
    // Spacing
    // Delete Listing
    return 2;
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
  // Listing Details
  if (indexPath.section == 0) {
    // Bedrooms
    // Bathrooms
    if (indexPath.row == 2 || indexPath.row == 3) {
      [((OMBLabelTextFieldCell *)
        [self.table cellForRowAtIndexPath:
          indexPath]).textField becomeFirstResponder];
    }
    // Property Type
    if (indexPath.row == 4) {
      //[self reloadForDatePickerAndPickerViewRowsAtIndexPath: indexPath];
      [self showPickerView: propertyTypePicker];
      [self.view endEditing: YES];
    }
  }
  // Delete Listing
  else if (indexPath.section == 2) {
    if(indexPath.row == 1)
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
      if (editingTextField)
        return 196.0f;
    }
  }
  // If all the other sections
  else {
    // Listing Details
    if (indexPath.section == 0) {
      // Listing Details header
      if (indexPath.row == 1) {
        return 0.0f;
      }
      // Property Type picker view
      else if (indexPath.row == 5) {
        if (selectedIndexPath &&
            selectedIndexPath.section == indexPath.section &&
            selectedIndexPath.row == indexPath.row - 1) {
          return 0.0;
        }
        else {
          return 0.0f;
        }
      }
      else if(indexPath.row == 6){
        return 0.0f;
      }
    }
    return 44.0f;
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

  if([[textField.text stringByReplacingCharactersInRange:range withString:string] floatValue] > 10) {
    return NO;
  };

  return YES;
}

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
	editingTextField = textField;
	savedTextFieldString = textField.text;

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
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
	editingTextField = nil;
	savedTextFieldString = nil;
  [textField resignFirstResponder];
  [self.table beginUpdates];
  [self.table endUpdates];
  return YES;
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
      NSString *message = @"Listing Deleted";
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: nil
        message: message delegate: self cancelButtonTitle: @"Okay"
          otherButtonTitles: nil];
      [alertView show];
    }
    [[self appDelegate].container stopSpinning];
    // [activityView stopSpinning];
  };
  [conn start];
}

- (void) done
{
  [self.view endEditing: YES];
	editingTextField = nil;
	savedTextFieldString = nil;
  [self.table reloadRowsAtIndexPaths: @[[self indexPathForSpacing]]
    withRowAnimation: UITableViewRowAnimationFade];
}


- (void) donePicker
{
  [self hidePickerView];

  // Property type
  if ([propertyTypePicker superview]) {
    NSString *string = [propertyTypeOptions objectAtIndex: auxRow];
    residence.propertyType = string;
    OMBLabelTextFieldCell *cell = (OMBLabelTextFieldCell *)
      [self.table cellForRowAtIndexPath:
        [NSIndexPath indexPathForItem:4 inSection:0]];
    cell.textField.text = [string capitalizedString];
  }

  [self updatePicker];
}

- (void) hidePickerView
{
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

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.table scrollToRowAtIndexPath: indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void) textFieldDidChange: (TextFieldPadding *) textField
{
  // Listing Details
  if (textField.indexPath.section == 0) {
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


- (void) showPickerView:(UIPickerView *)pickerView
{
  NSString *titlePicker = @"";
  if (propertyTypePicker == pickerView) {
		titlePicker = @"Property Type";
		[pickerViewContainer addSubview:propertyTypePicker];
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

- (void) updatePicker
{
  // Property type picker
  NSUInteger passingIndex =
  [propertyTypeOptions indexOfObjectPassingTest:
   ^BOOL (id obj, NSUInteger idx, BOOL *stop){
     return [obj isEqualToString:
             [residence.propertyType lowercaseString]];
   }
   ];
  if (passingIndex == NSNotFound)
    passingIndex = 0;
  [propertyTypePicker selectRow: passingIndex
    inComponent: 0 animated: NO];
}

@end
