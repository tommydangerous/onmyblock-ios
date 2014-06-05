//
//  OMBApplyResidenceViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBActivityViewFullScreen;
@class LEffectLabel;
@class LIALinkedInHttpClient;
@class OMBAlertViewBlur;
@class OMBCenteredImageView;
@class OMBGradientView;
@class OMBUser;

// Sections
typedef NS_ENUM(NSInteger, OMBMyRenterProfileSection) {
  OMBMyRenterProfileSectionUserInfo,
  OMBMyRenterProfileSectionRenterInfo,
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
// Renter Info
typedef NS_ENUM(NSInteger, OMBMyRenterProfileSectionRenterInfoRow) {
  OMBMyRenterProfileSectionRenterInfoTopSpacing,
  OMBMyRenterProfileSectionRenterInfoRowCoapplicants,
  OMBMyRenterProfileSectionRenterInfoRowCosigners,
  OMBMyRenterProfileSectionRenterInfoRowRentalHistory,
  OMBMyRenterProfileSectionRenterInfoRowWorkHistory,
  OMBMyRenterProfileSectionRenterInfoRowLegalQuestions
};

@interface OMBApplyResidenceViewController : OMBTableViewController
{
  UILabel *aboutTextViewPlaceholder;
  UITextView *aboutTextView;
  OMBCenteredImageView *backImageView;
  UIView *backView;
  CGFloat backViewOriginY;
  UIView *fadedBackground;
  UILabel *fullNameLabel;
  OMBGradientView *gradient;
  LIALinkedInHttpClient *linkedInClient;
  UIView *nameView;
  CGFloat nameViewOriginY;
  UIBarButtonItem *previewBarButtonItem;
  UIView *scaleBackView;
  UIToolbar *textFieldToolbar;
  NSString *savedTextString;
  UITextView *editingTextView;
  UITextField *editingTextField;
  UIActionSheet *uploadActionSheet;
  OMBUser *user;
  OMBCenteredImageView *userIconView;
  NSMutableDictionary *valueDictionary;
  
  OMBAlertViewBlur *alertBlur;
  UIButton *submitOfferButton;
  LEffectLabel *effectLabel;
}

@property BOOL nextSection;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadUser: (OMBUser *) object;
- (void) nextIncompleteSection;

@end
