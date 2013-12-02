//
//  OMBAccountProfileViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBCenteredImageView;
@class TextFieldPadding;

@interface OMBAccountProfileViewController : OMBTableViewController
<UITextFieldDelegate, UITextViewDelegate>
{
  UIBarButtonItem *doneBarButtonItem;
  UIBarButtonItem *editBarButtonItem;
  UIBarButtonItem *saveBarButtonItem;
  OMBCenteredImageView *userProfileImageView;

  // View that will hold all of these views
  UIView *userProfileView;
  UIView *userTextFieldView;

  // Arrays to hold labels and text fields
  // Non-editable views
  NSMutableArray *labelsArray;
  // Labels
  UILabel *emailLabel;
  UILabel *fullNameLabel;
  UILabel *phoneLabel;
  UILabel *schoolLabel;
  UILabel *aboutLabel;
  // Text fields
  NSMutableArray *textFieldsArray;
  // Text fields
  TextFieldPadding *emailTextField;
  TextFieldPadding *firstNameTextField;
  TextFieldPadding *lastNameTextField;
  TextFieldPadding *phoneTextField;
  TextFieldPadding *schoolTextField;
  UITextView *aboutTextView;

  BOOL isEditing;
}

@end
