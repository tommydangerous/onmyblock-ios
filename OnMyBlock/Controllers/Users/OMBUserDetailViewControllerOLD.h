//
//  OMBOtherUserProfileViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "OMBTableViewController.h"

@class OMBCenteredImageView;
@class OMBGradientView;
@class OMBUser;

// Sections
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSection) {
  OMBOtherUserProfileSectionAbout,
  OMBOtherUserProfileSectionStats,
  OMBOtherUserProfileSectionCoapplicants,
  OMBOtherUserProfileSectionCosigners,
  OMBOtherUserProfileSectionPets,
  OMBOtherUserProfileSectionPreviousRental,
  OMBOtherUserProfileSectionEmployment,
  OMBOtherUserProfileSectionLegalQuestion,
  OMBOtherUserProfileSectionListings
};

// Rows
// About
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionAboutRow) {
  OMBOtherUserProfileSectionAboutRowAbout
};
// Stats
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionStatsRow) {
  OMBOtherUserProfileSectionStatsRowCollectionView
};
// Coapplicants
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionCoapplicantsRow) {
  OMBOtherUserProfileSectionCoapplicantsRowHeader
};
// Cosigners
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionCosignersRow) {
  OMBOtherUserProfileSectionCosignersRowHeader
};
// Pets
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionPetsRow) {
  OMBOtherUserProfileSectionPetRowHeader
};
// Rental History
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionPreviousRentalRow) {
  OMBOtherUserProfileSectionPreviousRentalRowHeader
};
// Employment
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionEmploymentRow) {
  OMBOtherUserProfileSectionEmploymentRowHeader
};
// Legal Question
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionLegalQuestionsRow) {
  OMBOtherUserProfileSectionLegalQuestionsRowHeader
};
// Listings
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionListingsRow) {
  OMBOtherUserProfileSectionListingsRowHeader
};

@interface OMBUserDetailViewControllerOLD : OMBTableViewController
<MFMailComposeViewControllerDelegate,
  UICollectionViewDataSource, UICollectionViewDelegate, 
  UICollectionViewDelegateFlowLayout>
{
  OMBCenteredImageView *backImageView;
  UIView *backView;
  NSArray *backViewImageArray;
  CGFloat backViewOriginY;
  UIBarButtonItem *contactBarButtonItem;
  UIToolbar *contactToolbar;
  UIBarButtonItem *editBarButtonItem;
  UIBarButtonItem *emailBarButtonItem;
  OMBGradientView *gradient;
  NSMutableDictionary *legalAnswers;
  UIBarButtonItem *phoneBarButtonItem;
  UIView *scaleBackView;
  OMBUser *user;
  NSArray *userAttributes;
  UICollectionView *userCollectionView;
  OMBCenteredImageView *userIconImageView;
  UILabel *userNameLabel;
  UILabel *userSchoolLabel;
  
}

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

@end
