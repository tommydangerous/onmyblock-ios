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
  BOOL isEditing;
  NSArray *textFieldArray;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancel;
- (void) save;
- (void) setFrameForTextFields;
- (id) validateFieldsInArray: (NSArray *) array;

@end
