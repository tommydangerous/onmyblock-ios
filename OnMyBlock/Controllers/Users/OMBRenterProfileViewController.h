//
//  OMBRenterProfileViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBCenteredImageView;
@class OMBUser;

// Sections
typedef NS_ENUM(NSInteger, OMBRenterProfileSection) {
  OMBRenterProfileSectionUserInfo,
  OMBRenterProfileSectionRenterInfo
};

// Rows
// in section user info
typedef NS_ENUM(NSInteger, OMBRenterProfileSectionUserInfoRow) {
  OMBRenterProfileSectionUserInfoRowSchool,
  OMBRenterProfileSectionUserInfoRowEmail,
  OMBRenterProfileSectionUserInfoRowPhone,
  OMBRenterProfileSectionUserInfoRowAbout
};

// in section renter info
typedef NS_ENUM(NSInteger, OMBRenterProfileSectionRenterInfoRow) {
  OMBRenterProfileSectionRenterInfoRowPriorityRentalInfoHeader,
  OMBRenterProfileSectionRenterInfoRowCoapplicants,
  OMBRenterProfileSectionRenterInfoRowCosigner,
  OMBRenterProfileSectionRenterInfoRowFacebook,
  OMBRenterProfileSectionRenterInfoRowLinkedIn,
  OMBRenterProfileSectionRenterInfoRowPriorityRentalInfoNote,
  OMBRenterProfileSectionRenterInfoRowBecomeRenterVerified
};

@interface OMBRenterProfileViewController : OMBTableViewController
{
  OMBCenteredImageView *backImageView;
  UIView *backView;
  CGFloat backViewOriginY;
  UIBarButtonItem *editBarButtonItem;
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
