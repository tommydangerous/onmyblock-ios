//
//  OMBFinishListingOtherDetailsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingOtherDetailsViewController.h"

#import "OMBLabelTextFieldCell.h"

@implementation OMBFinishListingOtherDetailsViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super initWithResidence: object])) return nil;

  self.screenName = self.title = @"Other Details";

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadView
{
  [super loadView];

  [self setupForTable];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 3;
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
  cell.backgroundColor = tableView.backgroundColor;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  cell.textLabel.text = @"";
  cell.textLabel.textColor = [UIColor textColor];
  // Bottom border
  UIView *bottomBorder = [cell.contentView viewWithTag: 9999];
  if (bottomBorder)
    [bottomBorder removeFromSuperview];
  else {
    bottomBorder = [UIView new];
    bottomBorder.backgroundColor = [UIColor grayLight];
    bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
      tableView.frame.size.width, 0.5f);
    bottomBorder.tag = 9999;
  }
  if (indexPath.row == 0 && indexPath.section !=
    [tableView numberOfSections] - 1) {
    [cell.contentView addSubview: bottomBorder];
  }
  if (indexPath.section == 0 && indexPath.row != 0) {
    static NSString *TextFieldCellIdentifier = @"TextFieldCellIdentifier";
    OMBLabelTextFieldCell *c = [tableView dequeueReusableCellWithIdentifier:
      TextFieldCellIdentifier];
    if (!c)
      c = [[OMBLabelTextFieldCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: TextFieldCellIdentifier];
    c.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *bottomBorder2 = [c.contentView viewWithTag: 9999];
    if (bottomBorder2) {
      [bottomBorder2 removeFromSuperview];
    }
    else {
      bottomBorder2 = [UIView new];
      bottomBorder2.backgroundColor = [UIColor grayLight];
      bottomBorder2.frame = CGRectMake(0.0f, 44.0f - 0.5f, 
        tableView.frame.size.width, 0.5f);
      bottomBorder2.tag = 9999;
    }
    NSString *string = @"";
    if (indexPath.row == 1) {
      string = @"Bedrooms";
      c.textField.text = @"2";
    }
    else if (indexPath.row == 2) {
      string = @"Bathrooms";
      c.textField.text = @"1";
    }
    else if (indexPath.row == 3) {
      string = @"Month Lease";
      c.textField.text = @"12";
    }
    else if (indexPath.row == 4) {
      string = @"Property Type";
      c.textField.text = @"Sublet";
    }
    else if (indexPath.row == 5) {
      string = @"Move-in Date";
    }
    else if (indexPath.row == 6) {
      string = @"Move-out Date";
      [c.contentView addSubview: bottomBorder2];
    }
    c.textField.delegate = self;
    c.textField.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
    c.textField.tag = indexPath.row;
    c.textField.textAlignment = NSTextAlignmentRight;
    c.textField.textColor = [UIColor blueDark];
    c.textFieldLabel.text = string;
    [c setFramesUsingString: @"Move-out Date"];
    return c;
  }
  else if (indexPath.section == 1) {
    UILabel *label = (UILabel *) [cell.contentView viewWithTag: 999];
    if (indexPath.row == 1) {
      cell.backgroundColor = [UIColor whiteColor];
      cell.textLabel.text = @"";
      if (!label)
        label = [UILabel new];
      label.font = cell.textLabel.font;
      label.frame = CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 44.0f);
      label.text = @"Delete Listing";
      label.textAlignment = NSTextAlignmentCenter;
      label.textColor = [UIColor red];
      [cell.contentView addSubview: bottomBorder];
      [cell.contentView addSubview: label];
    }
    else {
      if (label)
        [label removeFromSuperview];
    }
  }
  else if (indexPath.section == 2) {
    cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.frame.size.width,
      0.0f, 0.0f);
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (section == 0) {
    return 1 + 6;
  }
  else if (section == 1) {
    return 1 + 1;
  }
  else if (section == 2) {
    return 1 + 1;
  }
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
    return 44.0f;
  }
  else if (indexPath.section == 1) {
    return 44.0f;
  }
  else if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      return 44.0f;
    }
    else {
      if (isEditing)
        return 216.0f;
    }
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];
  int tag = textField.tag;
  if (tag)
    [self.table scrollToRowAtIndexPath: 
      [NSIndexPath indexPathForRow: tag inSection: 0] atScrollPosition: 
        UITableViewScrollPositionTop animated: YES];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [textField resignFirstResponder];
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
  return YES;
}

@end
