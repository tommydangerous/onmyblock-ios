//
//  OMBManageListingDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableParallaxViewController.h"

@class OMBResidence;

typedef NS_ENUM(NSInteger, OMBManageListingDetailSection) {
  OMBManageListingDetailSectionTop
};

typedef NS_ENUM(NSInteger, OMBManageListingDetailSectionTopRow) {
  OMBManageListingDetailSectionTopRowEdit,
  OMBManageListingDetailSectionTopRowPreview,
  OMBManageListingDetailSectionTopRowStatus
};

@interface OMBManageListingDetailViewController : OMBTableParallaxViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
