//
//  OMBRenterInfoAddViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoAddViewController.h"

#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"

@implementation OMBRenterInfoAddViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  valueDictionary = [NSMutableDictionary dictionary];

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.leftBarButtonItem  = cancelBarButtonItem;
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;

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
        action: @selector(doneFromInputAccessoryView)];

  // Right padding
  UIBarButtonItem *rightPadding = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
      UIBarButtonSystemItemFixedSpace target: nil action: nil];
  // iOS 7 toolbar spacing is 16px; 20px on iPad
  rightPadding.width = 4.0f;

  textFieldToolbar = [UIToolbar new];
  textFieldToolbar.barTintColor = [UIColor whiteColor];
  textFieldToolbar.clipsToBounds = YES;
  textFieldToolbar.frame = CGRectMake(0.0f, 0.0f, 
    [self screen].size.width, OMBStandardHeight);
  textFieldToolbar.items = @[
    leftPadding,
    cancelBarButtonItemForTextFieldToolbar,
    flexibleSpace,
    doneBarButtonItemForTextFieldToolbar,
    rightPadding
  ];
  textFieldToolbar.tintColor = [UIColor blue];
}

#pragma mark - Protocol

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (TextFieldPadding *) textField
{
  isEditing = YES;
  [self.table beginUpdates];
  [self.table endUpdates];

  textField.inputAccessoryView = textFieldToolbar;

  // [self scrollToRectAtIndexPath: textField.indexPath];
  [self scrollToRowAtIndexPath: textField.indexPath];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  [self doneFromInputAccessoryView];
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancel
{
  [self.navigationController dismissViewControllerAnimated: YES
    completion: nil];
}

- (void) cancelFromInputAccessoryView
{
  [self.view endEditing: YES];
  isEditing = NO;
  [self.table beginUpdates];
  [self.table endUpdates];
}

- (void) doneFromInputAccessoryView
{
  [self cancelFromInputAccessoryView];
}

- (OMBRenterApplication *) renterApplication
{
  return [OMBUser currentUser].renterApplication;
}

- (void) scrollToRectAtIndexPath: (NSIndexPath *) indexPath
{
  CGRect rect = [self.table rectForRowAtIndexPath: indexPath];
  rect.origin.y -= (OMBPadding + textFieldToolbar.frame.size.height);
  [self.table setContentOffset: rect.origin animated: YES];
}

- (void) scrollToRowAtIndexPath: (NSIndexPath *) indexPath
{
  [self.table scrollToRowAtIndexPath: indexPath
    atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void) save
{
  if (isSaving)
    return;
  else
    isSaving = YES;
  if (modelObject) {
    for (NSString *key in [valueDictionary allKeys]) {
      [modelObject setValue: [valueDictionary objectForKey: key] forKey: key];
    }
  }
}
  
@end
