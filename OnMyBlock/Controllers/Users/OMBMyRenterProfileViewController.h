//
//  OMBMyRenterProfileViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class LIALinkedInHttpClient;
@class OMBCenteredImageView;
@class OMBGradientView;
@class OMBUser;

// Sections
typedef NS_ENUM(NSInteger, OMBMyRenterProfileSection) {
  OMBMyRenterProfileSectionUserInfo,
  OMBMyRenterProfileSectionRenterInfo,
  OMBMyRenterProfileSectionListings,
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
// Listing
typedef NS_ENUM(NSInteger, OMBMyRenterProfileSectionListingsRow) {
  OMBMyRenterProfileSectionListingsRowInfoHeader
};

@interface OMBMyRenterProfileViewController : OMBTableViewController

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadUser: (OMBUser *) object;

@end
