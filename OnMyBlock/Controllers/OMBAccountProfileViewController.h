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
<UIActionSheetDelegate, UIImagePickerControllerDelegate,
  UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
  UIBarButtonItem *doneBarButtonItem;
  UIBarButtonItem *editBarButtonItem;
  UIImagePickerController *imagePickerController;
  UIBarButtonItem *saveBarButtonItem;
  UIActionSheet *uploadActionSheet;
  UIView *uploadPhotoView;
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
  NSArray *textFieldsArray;
  // Text fields
  TextFieldPadding *emailTextField;
  TextFieldPadding *firstNameTextField;
  TextFieldPadding *lastNameTextField;
  TextFieldPadding *phoneTextField;
  TextFieldPadding *schoolTextField;
  UITextView *aboutTextView;

  BOOL isEditing;

  // Scroll to hold all the text fields
  UITableView *textFieldTableView;
}

@end
