//
//  OMBRenterApplicationAddModelViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/6/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

#import "TextFieldPadding.h"

@interface OMBRenterApplicationAddModelViewController : OMBTableViewController
<UITextFieldDelegate>
{
  UIBarButtonItem *cancelBarButtonItem;
  UIBarButtonItem *clearBarButtonItem;
  UIBarButtonItem *doneBarButtonItem;
  BOOL isEditing;
  UIBarButtonItem *saveBarButtonItem;
  NSArray *textFieldArray;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancel;
- (void) clear;
- (void) done;
- (void) firstTextFieldBecomeFirstResponder;
- (void) save;
- (void) setFrameForTextFields;
- (void) showCancelAndSaveBarButtonItems;
- (void) showClearAndDoneBarButtonItems;
- (id) validateFieldsInArray: (NSArray *) array;

@end
