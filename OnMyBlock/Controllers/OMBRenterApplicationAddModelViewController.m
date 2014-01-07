//
//  OMBRenterApplicationAddModelViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplicationAddModelViewController.h"

#import "OMBRenterApplicationAddModelCell.h"
#import "UIColor+Extensions.h"

@implementation OMBRenterApplicationAddModelViewController

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  cancelBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(cancel)];
  clearBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Clear"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(clear)];
  doneBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Done"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(done)];
  saveBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Save"
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(save)];

  self.navigationItem.leftBarButtonItem  = cancelBarButtonItem;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

  CGRect screen = [[UIScreen mainScreen] bounds];

  CGRect rect = CGRectMake(0, 0, screen.size.width, 44.0f);
  self.table.separatorColor = [UIColor grayLight];
  self.table.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
  self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.table.backgroundColor = [UIColor grayUltraLight];
  self.table.tableFooterView = [[UIView alloc] initWithFrame: rect];
  self.table.tableFooterView.backgroundColor = [UIColor clearColor];
  self.table.tableHeaderView = [[UIView alloc] initWithFrame: rect];
  self.table.tableHeaderView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 2;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  if (indexPath.section == 0) {
    OMBRenterApplicationAddModelCell *cell = 
      [self.table dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell) {
      cell = [[OMBRenterApplicationAddModelCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTextField: [textFieldArray objectAtIndex: indexPath.row]];
    CGRect screen = [[UIScreen mainScreen] bounds];
    if (indexPath.row == 0) {
      CALayer *topBorder = [CALayer layer];
      topBorder.backgroundColor = self.table.separatorColor.CGColor; 
      topBorder.frame = CGRectMake(0.0f, 0.0f, screen.size.width, 0.5f);
      [cell.contentView.layer addSublayer: topBorder];
    }
    else if (indexPath.row == [self tableView: self.table 
      numberOfRowsInSection: 0] - 1) {
      CALayer *bottomBorder = [CALayer layer];
      bottomBorder.backgroundColor = self.table.separatorColor.CGColor;
      bottomBorder.frame = CGRectMake(0.0f, 44.0f - 0.5f,
        screen.size.width, 0.5f);
      [cell.contentView.layer addSublayer: bottomBorder];
    }
    return cell;
  }
  UITableViewCell *emptyCell = [[UITableViewCell alloc] init];
  emptyCell.backgroundColor = [UIColor clearColor];
  emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
  return emptyCell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (section == 0)
    return [textFieldArray count];
  else if (section == 1)
    return 1;
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.section == 0) {
    UITextField *t = [textFieldArray objectAtIndex: indexPath.row];
    return t.frame.size.height;
  }
  else if (indexPath.section == 1) {
    if (isEditing)
      return 216.0f;
  }
  return 0.0f;
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];
  int row = [textFieldArray indexOfObject: textField];
  [self.table scrollToRowAtIndexPath: 
    [NSIndexPath indexPathForRow: row inSection: 0]
      atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
  [self.view endEditing: YES];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancel
{
  [self.view endEditing: YES];
  [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) clear
{
  // Subclasses implement this
}

- (void) done
{
  // Subclasses implement this
}

- (void) firstTextFieldBecomeFirstResponder
{
  if ([textFieldArray count] > 0)
    [[textFieldArray objectAtIndex: 0] becomeFirstResponder];
}

- (void) save
{
  // Subclasses implement this
}

- (void) setFrameForTextFields
{ 
  CGRect screen     = [[UIScreen mainScreen] bounds];
  float screenWidth = screen.size.width;

  int padding = 20;

  for (TextFieldPadding *textField in textFieldArray) {
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.delegate = self;
    textField.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
    textField.frame = CGRectMake(padding, 0, 
      screenWidth - (padding * 2), 44.0f);
    textField.returnKeyType = UIReturnKeyDone;
  }
}

- (void) showCancelAndSaveBarButtonItems
{
  [self.navigationItem setLeftBarButtonItem: cancelBarButtonItem animated: YES];
  [self.navigationItem setRightBarButtonItem: saveBarButtonItem animated: YES];
}

- (void) showClearAndDoneBarButtonItems
{
  [self.navigationItem setLeftBarButtonItem: clearBarButtonItem animated: YES];
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];
}


- (id) validateFieldsInArray: (NSArray *) array
{
  NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
  for (TextFieldPadding *textField in array) {
    if ([[textField.text stringByTrimmingCharactersInSet: set] length] == 0) {
      int row = [textFieldArray indexOfObject: textField];
      [self.table scrollToRowAtIndexPath: 
        [NSIndexPath indexPathForRow: row inSection: 0]
          atScrollPosition: UITableViewScrollPositionTop animated: YES];
      // This isn't working right now because fields disappear when
      // scrolling to the index path after it becomes first responder
      // [textField becomeFirstResponder];
      return textField;
    }
  }
  return nil;
}

@end
