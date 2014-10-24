//
//  OMBHomebaseRenterViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableParallaxViewController.h"

typedef NS_ENUM(NSUInteger, OMBHomebaseRenterSection) {
  OMBHomebaseRenterSectionSentApplications,
  OMBHomebaseRenterSectionMovedIn
};

// Sent applications
typedef NS_ENUM(NSUInteger, OMBHomebaseRenterSectionSentApplicationsRow) {
  OMBHomebaseRenterSectionSentApplicationsRowEmpty
};

// Moved in
typedef NS_ENUM(NSUInteger, OMBHomebaseRenterSectionMovedInRow) {
  OMBHomebaseRenterSectionMovedInRowEmpty
};

@interface OMBHomebaseRenterViewController : OMBTableParallaxViewController

@end
