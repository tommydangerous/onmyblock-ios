//
//  OMBFinishListingRentAuctionDetailsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingRentAuctionDetailsViewController.h"

#import "NSString+Extensions.h"
#import "OMBDatePickerCell.h"
#import "OMBFinishListingAuctionStartPriceCell.h"
#import "OMBFinishListingRentItNowPriceCell.h"
#import "OMBFinishListingShowMoreCell.h"
#import "OMBPickerViewCell.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBFinishListingRentAuctionDetailsViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  durationOptions = @[
    [NSNumber numberWithInt: 5],
    [NSNumber numberWithInt: 7],
    [NSNumber numberWithInt: 14],
    [NSNumber numberWithInt: 21]
  ];

  self.screenName = self.title = @"Rent / Auction Details";

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillShow:)
      name: UIKeyboardWillShowNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(keyboardWillHide:)
      name: UIKeyboardWillHideNotification object: nil];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self action: @selector(done)];
  [doneBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  saveBarButtonItem.enabled = YES;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;

  [self.table removeFromSuperview];
  self.table.dataSource = nil;
  self.table.delegate   = nil;
  self.table            = nil;

  // Segmented control
  segmentedControl = [[UISegmentedControl alloc] initWithItems: 
    @[@"Rental Auction", @"Fixed Rental Price"]];
  segmentedControl.backgroundColor = [UIColor whiteColor];
  segmentedControl.frame = CGRectMake(padding, 20.0f + 44.0f + padding,
    screenWidth - (padding * 2), segmentedControl.frame.size.height);
  segmentedControl.selectedSegmentIndex = 0;
  segmentedControl.tintColor = [UIColor blue];
  [segmentedControl addTarget: self action: @selector(segmentedControlChanged:)
    forControlEvents: UIControlEventValueChanged];
  [self.view addSubview: segmentedControl];

  UIView *segmentedControlBorder = [UIView new];
  segmentedControlBorder.backgroundColor = [UIColor grayLight];
  segmentedControlBorder.frame = CGRectMake(0.0f, 
    (segmentedControl.frame.origin.y + segmentedControl.frame.size.height + 
    padding) - 0.5f, 
      screenWidth, 0.5f);
  [self.view addSubview: segmentedControlBorder];

  CGFloat tableViewHeight = screen.size.height -
    (segmentedControl.frame.origin.y + segmentedControl.frame.size.height +
      padding);
  auctionTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f,
    screen.size.height - tableViewHeight, screenWidth, tableViewHeight)
      style: UITableViewStylePlain];
  auctionTableView.backgroundColor = [UIColor grayUltraLight];
  auctionTableView.dataSource = self;
  auctionTableView.delegate   = self;
  auctionTableView.separatorColor = [UIColor grayLight];
  auctionTableView.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  auctionTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  auctionTableView.showsVerticalScrollIndicator = NO;
  auctionTableView.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectZero];
  // auctionTableView.tableHeaderView = [[UIView alloc] initWithFrame: 
  //   CGRectMake(0.0f, 0.0f, screenWidth, 44.0f)];
  [self.view addSubview: auctionTableView];

  fixedRentalPriceView = [UIView new];
  fixedRentalPriceView.backgroundColor = auctionTableView.backgroundColor;
  fixedRentalPriceView.frame = auctionTableView.frame;
  fixedRentalPriceView.hidden = YES;
  [self.view addSubview: fixedRentalPriceView];

  CGFloat textFieldHeight = 58.0f;
  CGFloat textFieldWidth = screenWidth * 0.5f;
  fixedRentalPriceTextField = [[TextFieldPadding alloc] init];
  fixedRentalPriceTextField.backgroundColor = [UIColor whiteColor];
  fixedRentalPriceTextField.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 18];
  fixedRentalPriceTextField.frame = CGRectMake(
    (fixedRentalPriceView.frame.size.width - textFieldWidth) * 0.5f, 
      (fixedRentalPriceView.frame.size.height - 
      (textFieldHeight + 216.0f)) * 0.5f, 
        textFieldWidth, textFieldHeight);
  fixedRentalPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
  fixedRentalPriceTextField.layer.borderColor = [UIColor grayLight].CGColor;
  fixedRentalPriceTextField.layer.borderWidth = 1.0f;
  fixedRentalPriceTextField.layer.cornerRadius = 5.0f;
  // Left view
  UILabel *leftView = [UILabel new];
  leftView.font = fixedRentalPriceTextField.font;
  leftView.text = @"$";
  leftView.textAlignment = NSTextAlignmentCenter;
  leftView.textColor = [UIColor grayMedium];
  CGSize maxSize = CGSizeMake(fixedRentalPriceTextField.frame.size.width, 
    fixedRentalPriceTextField.frame.size.height);
  CGRect leftViewRect = [leftView.text boundingRectWithSize: maxSize
    font: leftView.font];
  leftView.frame = CGRectMake(0.0f, 0.0f, 
    (padding * 0.5) + leftViewRect.size.width + (padding * 0.5),
      leftViewRect.size.height);
  fixedRentalPriceTextField.leftView = leftView;
  fixedRentalPriceTextField.leftViewMode = UITextFieldViewModeAlways;
  fixedRentalPriceTextField.leftPaddingX = leftView.frame.size.width;
  fixedRentalPriceTextField.rightPaddingX = padding;
  fixedRentalPriceTextField.textColor = [UIColor blueDark];
  [fixedRentalPriceView addSubview: fixedRentalPriceTextField];

  fixedRentalPriceLabel = [UILabel new];
  fixedRentalPriceLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 15];
  fixedRentalPriceLabel.frame = CGRectMake(0.0f, 
    fixedRentalPriceTextField.frame.origin.y - 30.0f,
      fixedRentalPriceView.frame.size.width, 30.0f);
  fixedRentalPriceLabel.text = @"Rent per month";
  fixedRentalPriceLabel.textAlignment = NSTextAlignmentCenter;
  fixedRentalPriceLabel.textColor = [UIColor grayMedium];
  [fixedRentalPriceView addSubview: fixedRentalPriceLabel];
}

#pragma mark - Protocol

#pragma mark - Protocol UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
  return 1;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView
numberOfRowsInComponent: (NSInteger) component
{
  return [durationOptions count];
}

#pragma mark - Protocol UIPickerViewDelegate

- (void) pickerView: (UIPickerView *) pickerView didSelectRow: (NSInteger) row
inComponent: (NSInteger) component
{

}

- (CGFloat) pickerView: (UIPickerView *) pickerView
rowHeightForComponent: (NSInteger) component
{
  return 44.0f;
}

- (UIView *) pickerView: (UIPickerView *) pickerView viewForRow: (NSInteger) row
forComponent: (NSInteger) component reusingView: (UIView *) view
{
  NSString *string = [NSString stringWithFormat: @"%i days",
    [[durationOptions objectAtIndex: row] intValue]];
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
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
      reuseIdentifier: CellIdentifier];
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.backgroundColor = [UIColor whiteColor];
  cell.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 15];
  cell.detailTextLabel.text = @"";
  cell.detailTextLabel.textColor = [UIColor textColor];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.font = cell.detailTextLabel.font;
  cell.textLabel.text = @"";
  cell.textLabel.textColor = cell.detailTextLabel.textColor;
  if (indexPath.section == 0) {
    // Auction Start Price
    if (indexPath.row == 0) {
      static NSString *CellIdentifier0 = @"CellIdentifier0";
      OMBFinishListingAuctionStartPriceCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          CellIdentifier0];
      if (!cell1)
        cell1 = [[OMBFinishListingAuctionStartPriceCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: CellIdentifier0];
      cell1.textField.delegate = self;
      cell1.textField.tag      = 0;
      return cell1;
    }
    // Rent it Now Price
    else if (indexPath.row == 1) {
      static NSString *CellIdentifier1 = @"CellIdentifier1";
      OMBFinishListingRentItNowPriceCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          CellIdentifier1];
      if (!cell1)
        cell1 = [[OMBFinishListingRentItNowPriceCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: CellIdentifier1];
      cell1.textField.delegate = self;
      cell1.textField.tag      = 1;
      return cell1;
    }
    // Duration
    else if (indexPath.row == 2) {
      static NSString *CellIdentifier2 = @"CellIdentifier2";
      UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
        CellIdentifier2];
      if (!cell1)
        cell1 = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleValue1 reuseIdentifier: CellIdentifier2];
      cell1.backgroundColor = [UIColor whiteColor];
      cell1.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
        size: 15];
      cell1.detailTextLabel.text = @"7 days";
      cell1.detailTextLabel.textColor = [UIColor textColor];
      cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
      cell1.textLabel.font = cell1.detailTextLabel.font;
      cell1.textLabel.text = @"Duration";
      cell1.textLabel.textColor = [UIColor textColor];
      if (selectedIndexPath &&
        selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row) {

        cell1.detailTextLabel.textColor = [UIColor blueDark];
      }
      else {
        cell1.detailTextLabel.textColor = [UIColor textColor];
      }
      return cell1;
    }
    // Duration Picker
    else if (indexPath.row == 3) {
      if (showMore && selectedIndexPath &&
        selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row - 1) {

        static NSString *CellIdentifier3 = @"CellIdentifier3";
        OMBPickerViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
          CellIdentifier3];
        if (!cell1)
          cell1 = [[OMBPickerViewCell alloc] initWithStyle: 
            UITableViewCellStyleDefault reuseIdentifier: CellIdentifier3];
        cell1.pickerView.dataSource = self;
        cell1.pickerView.delegate   = self;
        [cell1.pickerView selectRow: 1 inComponent: 0 animated: NO];
        return cell1;
      }
    }
    // Start Date
    else if (indexPath.row == 4) {
      static NSString *CellIdentifier4 = @"CellIdentifier4";
      UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:
        CellIdentifier4];
      if (!cell1)
        cell1 = [[UITableViewCell alloc] initWithStyle: 
          UITableViewCellStyleValue1 reuseIdentifier: CellIdentifier4];
      cell1.backgroundColor = [UIColor whiteColor];
      cell1.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
        size: 15];
      cell1.detailTextLabel.text = @"Immediately";
      cell1.detailTextLabel.textColor = [UIColor textColor];
      cell1.selectionStyle = UITableViewCellSelectionStyleDefault;
      cell1.textLabel.font = cell1.detailTextLabel.font;
      cell1.textLabel.text = @"Start Date";
      cell1.textLabel.textColor = [UIColor textColor];
      if (selectedIndexPath &&
        selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row) {
        
        cell1.detailTextLabel.textColor = [UIColor blueDark];
      }
      else {
        cell1.detailTextLabel.textColor = [UIColor textColor];
      }
      return cell1;
    }
    // Start Date Picker
    else if (indexPath.row == 5) {
      if (showMore && selectedIndexPath &&
        selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row - 1) {

        static NSString *CellIdentifier5 = @"CellIdentifier5";
        OMBDatePickerCell *cell1 = 
          [tableView dequeueReusableCellWithIdentifier:
            CellIdentifier5];
        if (!cell1)
          cell1 = [[OMBDatePickerCell alloc] initWithStyle: 
            UITableViewCellStyleDefault reuseIdentifier: CellIdentifier5];
        [cell1.datePicker addTarget: self action: @selector(datePickerChanged:)
          forControlEvents: UIControlEventValueChanged];
        return cell1;
      }
    }
    // Show More / Show Less
    else if (indexPath.row == 6) {
      static NSString *CellIdentifier6 = @"CellIdentifier6";
      OMBFinishListingShowMoreCell *cell1 = 
        [tableView dequeueReusableCellWithIdentifier:
          CellIdentifier6];
      if (!cell1)
        cell1 = [[OMBFinishListingShowMoreCell alloc] initWithStyle: 
          UITableViewCellStyleDefault reuseIdentifier: CellIdentifier6];
      int degrees = 90;
      if (showMore) {
        cell1.label.text = @"Show Less";
        degrees = 270;
      }
      else {
        cell1.label.text = @"Show More";
      }
      cell1.arrowImageView.transform = CGAffineTransformMakeRotation(
        DEGREES_TO_RADIANS(degrees));
      return cell1;
    }
  }
  else if (indexPath.section == 1) {
    cell.backgroundColor = tableView.backgroundColor;
    cell.separatorInset  = UIEdgeInsetsMake(0, tableView.frame.size.width, 
      0, 0);
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (section == 0) {
    // Starting Price
    // Rent it Now Price
    // Duration
    // Picker
    // Start Date
    // Date Picker
    // Show More
    return 7;
  }
  else if (section == 1) {
    return 1;
  }
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.section == 0) {
    // Duration
    // Start Date
    if (indexPath.row == 2 || indexPath.row == 4) {
      isEditing = NO;
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

      // Change the text color for duraton and start date
      UITableViewCell *pickerViewCell = [tableView cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 2 inSection: 0]];
      UITableViewCell *datePickerCell = [tableView cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow: 4 inSection: 0]];

      if (selectedIndexPath) {
        // Duration
        if (selectedIndexPath.section == 0 && selectedIndexPath.row == 2) {
          pickerViewCell.detailTextLabel.textColor = [UIColor blueDark];
          datePickerCell.detailTextLabel.textColor = [UIColor textColor];
        }
        // Start Date
        else if (selectedIndexPath.section == 0 && selectedIndexPath.row == 4) {
          pickerViewCell.detailTextLabel.textColor = [UIColor textColor];
          datePickerCell.detailTextLabel.textColor = [UIColor blueDark];
        }
      }
      else {
        pickerViewCell.detailTextLabel.textColor = [UIColor textColor];
        datePickerCell.detailTextLabel.textColor = [UIColor textColor];
      }

      [tableView reloadRowsAtIndexPaths: @[
        [NSIndexPath indexPathForRow: 
          indexPath.row + 1 inSection: indexPath.section]
        ] withRowAnimation: UITableViewRowAnimationFade];

      [self.navigationItem setRightBarButtonItem: saveBarButtonItem];
      [self.view endEditing: YES];
    }
    // Show More / Show Less
    else if (indexPath.row == 6) {
      showMore = !showMore;
      
      [tableView reloadRowsAtIndexPaths: @[
        [NSIndexPath indexPathForRow: 2 inSection: indexPath.section],
        [NSIndexPath indexPathForRow: 3 inSection: indexPath.section],
        [NSIndexPath indexPathForRow: 4 inSection: indexPath.section],
        [NSIndexPath indexPathForRow: 5 inSection: indexPath.section],
        [NSIndexPath indexPathForRow: 6 inSection: indexPath.section]
        ]
        withRowAnimation: UITableViewRowAnimationFade];
      
      OMBFinishListingShowMoreCell *cell = (OMBFinishListingShowMoreCell *) 
        [tableView cellForRowAtIndexPath: indexPath];
      int degrees = 90;
      if (showMore)
        degrees = 270;
      [UIView animateWithDuration: 0.25f animations: ^{
        cell.arrowImageView.transform = CGAffineTransformMakeRotation(
          DEGREES_TO_RADIANS(degrees));
      }];
    }
  }
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.section == 0) {
    // Starting PRice
    if (indexPath.row == 0) {
      return [OMBFinishListingAuctionStartPriceCell heightForCell];
    }
    // Rent it Now
    else if (indexPath.row == 1) {
      return [OMBFinishListingRentItNowPriceCell heightForCell];
    }
    // Duration
    else if (indexPath.row == 2) {
      if (showMore)
        return 44.0f;
    }
    // Duration Picker
    else if (indexPath.row == 3) {
      if (showMore && selectedIndexPath && 
        selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row - 1) {

        return [OMBPickerViewCell heightForCell];
      }
    }
    // Start Date
    else if (indexPath.row == 4) {
      if (showMore)
        return 44.0f;
    }
    // Start Date Picker
    else if (indexPath.row == 5) {
      if (showMore && selectedIndexPath && 
        selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row - 1) {
        
        return [OMBDatePickerCell heightForCell];
      }
    }
    // Show More / Show Less
    else if (indexPath.row == 6) {
      return [OMBFinishListingShowMoreCell heightForCell];
    }
  }
  else if (indexPath.section == [tableView numberOfSections] - 1) {
    if (isEditing) {
      return 216.0f;
    }
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
    [auctionTableView reloadRowsAtIndexPaths: @[previousIndexPath]
      withRowAnimation: UITableViewRowAnimationFade];
  }
  else {
    [auctionTableView beginUpdates];
    [auctionTableView endUpdates];
  }
  
  // [auctionTableView beginUpdates];
  // [auctionTableView endUpdates];

  // // Reload
  // UITableViewCell *pickerViewCell = [auctionTableView cellForRowAtIndexPath:
  //   [NSIndexPath indexPathForRow: 2 inSection: 0]];
  // pickerViewCell.detailTextLabel.textColor = [UIColor textColor];
  // UITableViewCell *datePickerCell = [auctionTableView cellForRowAtIndexPath:
  //   [NSIndexPath indexPathForRow: 4 inSection: 0]];
  // datePickerCell.detailTextLabel.textColor = [UIColor textColor];

  // // Picker View
  // [auctionTableView reloadRowsAtIndexPaths: 
  //   @[[NSIndexPath indexPathForRow: 3 inSection: 0]] 
  //     withRowAnimation: UITableViewRowAnimationFade];
  // // Date Picker
  // [auctionTableView reloadRowsAtIndexPaths: 
  //   @[[NSIndexPath indexPathForRow: 5 inSection: 0]] 
  //     withRowAnimation: UITableViewRowAnimationFade];
  // // Section spacing bottom
  // [auctionTableView reloadRowsAtIndexPaths: 
  //   @[[NSIndexPath indexPathForRow: 0 inSection: 1]] 
  //     withRowAnimation: UITableViewRowAnimationFade];

  // Scroll 
  [auctionTableView scrollToRowAtIndexPath: 
    [NSIndexPath indexPathForRow: textField.tag inSection: 0]
      atScrollPosition: UITableViewScrollPositionTop animated: YES];

  if (textField != fixedRentalPriceTextField) {
    [self.navigationItem setRightBarButtonItem: doneBarButtonItem];
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) datePickerChanged: (UIDatePicker *) datePicker
{
  if (selectedIndexPath) {
    // Start Date
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MMMM d, yyyy";
    NSString *todayString = [dateFormatter stringFromDate: [NSDate date]];
    NSString *dateSelectedString = [dateFormatter stringFromDate: 
      datePicker.date];
    UITableViewCell *cell = [auctionTableView cellForRowAtIndexPath:
      selectedIndexPath];
    if ([todayString isEqualToString: dateSelectedString]) {
      cell.detailTextLabel.text = @"Immediately";
    }
    else {
      cell.detailTextLabel.text = dateSelectedString;
    }
  }
}

- (void) done
{
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
  [self.view endEditing: YES];
  isEditing = NO;
  [auctionTableView reloadRowsAtIndexPaths: 
    @[[NSIndexPath indexPathForRow: 0 inSection: 1]] 
      withRowAnimation: UITableViewRowAnimationFade];
}

- (void) keyboardWillHide: (NSNotification *) notification
{
  // Animate the fixed rental price label and text field
  // NSTimeInterval duration = [[notification.userInfo objectForKey: 
  //   UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  // [UIView animateWithDuration: duration animations: ^{
  //   CGRect screen = [[UIScreen mainScreen] bounds];
  //   CGFloat padding = 20.0f;
  //   CGFloat tableViewHeight = screen.size.height -
  //     (segmentedControl.frame.origin.y + segmentedControl.frame.size.height +
  //       padding);
  //   CGFloat height = tableViewHeight;
  // 
  //   CGRect rect1 = fixedRentalPriceTextField.frame;
  //   rect1.origin.y = (height - rect1.size.height) * 0.5f;
  //   fixedRentalPriceTextField.frame = rect1;
  // 
  //   CGRect rect2 = fixedRentalPriceLabel.frame;
  //   rect2.origin.y = fixedRentalPriceTextField.frame.origin.y - 
  //     rect2.size.height;
  //   fixedRentalPriceLabel.frame = rect2;
  // }];

  // isEditing = NO;
  // if (refreshTableView) {
  //   [auctionTableView beginUpdates];
  //   [auctionTableView endUpdates];
  // }
  // else {
  //   refreshTableView = YES;
  // }
}

- (void) keyboardWillShow: (NSNotification *) notification
{
  // if (isEditingStartDate) {
  //   isEditingStartDate = NO;
  //   [auctionTableView beginUpdates];
  //   [auctionTableView reloadRowsAtIndexPaths: 
  //     @[[NSIndexPath indexPathForRow: 4 inSection: 0]]
  //       withRowAnimation: UITableViewRowAnimationFade];
  //   [auctionTableView endUpdates];
  // }
  // Animate the fixed rental price label and text field
  // NSTimeInterval duration = [[notification.userInfo objectForKey: 
  //   UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  // [UIView animateWithDuration: duration animations: ^{
  //   CGRect screen = [[UIScreen mainScreen] bounds];
  //   CGFloat padding = 20.0f;
  //   CGFloat tableViewHeight = screen.size.height -
  //     (segmentedControl.frame.origin.y + segmentedControl.frame.size.height +
  //       padding);
  //   CGFloat height = tableViewHeight - 216.0f;

  //   CGRect rect1 = fixedRentalPriceTextField.frame;
  //   rect1.origin.y = (height - rect1.size.height) * 0.5f;
  //   fixedRentalPriceTextField.frame = rect1;

  //   CGRect rect2 = fixedRentalPriceLabel.frame;
  //   rect2.origin.y = fixedRentalPriceTextField.frame.origin.y - 
  //     rect2.size.height;
  //   fixedRentalPriceLabel.frame = rect2;
  // }];
}

- (void) segmentedControlChanged: (UISegmentedControl *) control
{
  // Show Rental Auction
  if (control.selectedSegmentIndex == 0) {
    auctionTableView.hidden     = NO;
    fixedRentalPriceView.hidden = YES;
    [self.view endEditing: YES];
  }
  // Show Fixed Rental Price
  else if (control.selectedSegmentIndex == 1) {
    auctionTableView.hidden     = YES;
    fixedRentalPriceView.hidden = NO;
    [fixedRentalPriceTextField becomeFirstResponder];
    [self.navigationItem setRightBarButtonItem: saveBarButtonItem];
  }
}

@end
