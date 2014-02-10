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
  OMBOtherUserProfileSectionEmployment,
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
// Employment
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionEmploymentRow) {
  OMBOtherUserProfileSectionEmploymentRowHeader
};
// Listings
typedef NS_ENUM(NSInteger, OMBOtherUserProfileSectionListingsRow) {
  OMBOtherUserProfileSectionListingsRowHeader
};

@interface OMBOtherUserProfileViewController : OMBTableViewController
<MFMailComposeViewControllerDelegate,
  UICollectionViewDataSource, UICollectionViewDelegate, 
  UICollectionViewDelegateFlowLayout>
{
  OMBCenteredImageView *backImageView;
  UIView *backView;
  CGFloat backViewOriginY;
  UIBarButtonItem *contactBarButtonItem;
  UIToolbar *contactToolbar;
  UIBarButtonItem *emailBarButtonItem;
  OMBGradientView *gradient;
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
