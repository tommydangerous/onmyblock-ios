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

  self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(cancel)];
  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle: @"Save"
      style: UIBarButtonItemStylePlain target: self 
        action: @selector(save)];
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
    return cell;
  }
  UITableViewCell *emptyCell = [[UITableViewCell alloc] init];
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
  float padding = 20.0f;
  if (indexPath.section == 0) {
    UITextField *t = [textFieldArray objectAtIndex: indexPath.row];
    return padding + t.frame.size.height;
  }
  else if (indexPath.section == 1) {
    float height = padding;
    if (isEditing)
      height += 216.0f;
    return height;
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
    textField.backgroundColor = [UIColor grayUltraLight];
    textField.delegate = self;
    textField.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
    textField.frame = CGRectMake(padding, padding, 
      screenWidth - (padding * 2), 44.0f);
    textField.layer.cornerRadius = 2.0f;
    textField.layer.borderColor = [UIColor grayLight].CGColor;
    textField.layer.borderWidth = 1.0f;
    textField.paddingX = padding / 2.0f;
    textField.paddingY = padding / 2.0f;
    textField.returnKeyType = UIReturnKeyDone;
  }
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
