//
//  OMBRenterProfileViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "OMBTableViewController.h"

@class AMBlurView;
@class OMBCenteredImageView;
@class OMBEditProfileViewController;
@class OMBUser;

// Sections
typedef NS_ENUM(NSInteger, OMBRenterProfileSection) {
  OMBRenterProfileSectionUserInfo,
  OMBRenterProfileSectionRenterInfo,
  OMBRenterProfileSectionEmployment,
  OMBRenterProfileSectionListings
};

// Rows
// in section user info
typedef NS_ENUM(NSInteger, OMBRenterProfileSectionUserInfoRow) {
  OMBRenterProfileSectionUserInfoRowName,
  OMBRenterProfileSectionUserInfoRowSchool,
  OMBRenterProfileSectionUserInfoRowEmail,
  OMBRenterProfileSectionUserInfoRowPhone,
  OMBRenterProfileSectionUserInfoRowAbout
};

// in section renter info
typedef NS_ENUM(NSInteger, OMBRenterProfileSectionRenterInfoRow) {
  OMBRenterProfileSectionRenterInfoRowPriorityRentalInfoHeader,
  OMBRenterProfileSectionRenterInfoRowPriorityRentalInfoNote,
  OMBRenterProfileSectionRenterInfoRowBecomeRenterVerified,
  OMBRenterProfileSectionRenterInfoRowCoapplicants,
  OMBRenterProfileSectionRenterInfoRowCosigner,
  OMBRenterProfileSectionRenterInfoRowFacebook,
  OMBRenterProfileSectionRenterInfoRowLinkedIn
};

// in section listings
typedef NS_ENUM(NSInteger, OMBRenterProfileSectionListingsRow) {
  OMBRenterProfileSectionListingsRowInfoHeader,
  OMBRenterProfileSectionListingsCreateListing
};

@interface OMBRenterProfileViewController : OMBTableViewController
<MFMailComposeViewControllerDelegate>
{
  OMBCenteredImageView *backImageView;
  UIView *backView;
  CGFloat backViewOriginY;
  UIBarButtonItem *contactBarButtonItem;
  UIToolbar *contactToolbar;
  UIBarButtonItem *editBarButtonItem;
  UIButton *editButton;
  AMBlurView *editButtonView;
  OMBEditProfileViewController *editProfileViewController;
  UILabel *fullNameLabel;
  UIView *nameView;
  CGFloat nameViewOriginY;
  OMBUser *user;
  OMBCenteredImageView *userIconView;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadUser: (OMBUser *) object;

@end
