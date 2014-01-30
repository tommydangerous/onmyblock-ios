//
//  OMBEditProfileViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBBlurView;
@class OMBCenteredImageView;
@class OMBUser;

// Sections
typedef NS_ENUM(NSInteger, OMBEditProfileSection) {
  OMBEditProfileSectionMain,
  OMBEditProfileSectionSpacing
};

// Rows
// in section user info
typedef NS_ENUM(NSInteger, OMBEditProfileSectionMainRow) {
  OMBEditProfileSectionMainRowImage,
  OMBEditProfileSectionMainRowFirstName,
  OMBEditProfileSectionMainRowLastName,
  OMBEditProfileSectionMainRowSchool,
  OMBEditProfileSectionMainRowEmail,
  OMBEditProfileSectionMainRowPhone,
  OMBEditProfileSectionMainRowAbout
};

@interface OMBEditProfileViewController : OMBTableViewController
<UIActionSheetDelegate, UIImagePickerControllerDelegate, 
  UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
  UILabel *aboutTextViewPlaceholder;
  UITextView *aboutTextView;
  OMBBlurView *backgroundBlurView;
  BOOL isEditing;
  UIActionSheet *uploadActionSheet;
  OMBUser *user;
  OMBCenteredImageView *userImageView;
  NSMutableDictionary *valueDictionary;
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

@end
