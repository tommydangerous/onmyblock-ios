//
//  OMBUserDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "OMBTableParallaxViewController.h"

@class OMBUser;

// Sections
typedef NS_ENUM(NSInteger, OMBUserDetailSection) {
  OMBUserDetailSectionAbout,
  OMBUserDetailSectionStats,
  OMBUserDetailSectionRoommates,
  OMBUserDetailSectionCosigners,
  OMBUserDetailSectionPreviousRentals,
  OMBUserDetailSectionEmployments,
  OMBUserDetailSectionLegalQuestions,
  OMBUserDetailSectionListings
};

// Rows
// About
typedef NS_ENUM(NSInteger, OMBUserDetailSectionAboutRow) {
  OMBUserDetailSectionAboutRowAbout
};
// Stats
typedef NS_ENUM(NSInteger, OMBUserDetailSectionStatsRow) {
  OMBUserDetailSectionStatsRowCollectionView
};


@interface OMBUserDetailViewController : OMBTableParallaxViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

@end
