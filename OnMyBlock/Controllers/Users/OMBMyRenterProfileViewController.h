//
//  OMBMyRenterProfileViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class LIALinkedInHttpClient;
@class OMBUser;

// Sections
typedef NS_ENUM(NSInteger, OMBMyRenterProfileSection) {
  OMBMyRenterProfileSectionUserInfo,
  OMBMyRenterProfileSectionRentalInfo,
  OMBMyRenterProfileSectionEmployments,
  OMBMyRenterProfileSectionSpacing
};

// Rows
// User Info
typedef NS_ENUM(NSInteger, OMBMyRenterProfileSectionUserInfoRow) {
  OMBMyRenterProfileSectionUserInfoRowImage,
  OMBMyRenterProfileSectionUserInfoRowFirstName,
  OMBMyRenterProfileSectionUserInfoRowLastName,
  OMBMyRenterProfileSectionUserInfoRowSchool,
  OMBMyRenterProfileSectionUserInfoRowEmail,
  OMBMyRenterProfileSectionUserInfoRowPhone,
  OMBMyRenterProfileSectionUserInfoRowAbout
};
// Rental Info
typedef NS_ENUM(NSInteger, OMBMyRenterProfileSectionRentalInfoRow) {
  OMBMyRenterProfileSectionRentalInfoRowCoapplicants,
  OMBMyRenterProfileSectionRentalInfoRowCoapplicantsPickerView,
  OMBMyRenterProfileSectionRentalInfoRowCosigners,
  OMBMyRenterProfileSectionRentalInfoRowFacebook,
  OMBMyRenterProfileSectionRentalInfoRowLinkedIn
};

@interface OMBMyRenterProfileViewController : OMBTableViewController
<UIActionSheetDelegate, UIImagePickerControllerDelegate, 
  UINavigationControllerDelegate, UIPickerViewDataSource,
  UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
  UILabel *aboutTextViewPlaceholder;
  UITextView *aboutTextView;
  BOOL isEditing;
  LIALinkedInHttpClient *linkedInClient;
  NSIndexPath *selectedIndexPath;
  UIActionSheet *uploadActionSheet;
  OMBUser *user;
  NSMutableDictionary *valueDictionary;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadUser: (OMBUser *) object;

@end
