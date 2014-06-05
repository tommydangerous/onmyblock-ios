//
//  OMBFinishListingSectionViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/27/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBResidence;
@class OMBFinishListingViewController;

typedef NS_ENUM(NSInteger, OMBFinishListingSection){
  OMBFinishListingSectionTitle,
  OMBFinishListingSectionDescription,
  OMBFinishListingSectionRentDetails,
  OMBFinishListingSectionAddress,
  OMBFinishListingSectionLeaseDetails,
  OMBFinishListingSectionListingDetails,
  //OMBFinishListingSectionAmenities,
  OMBFinishListingSectionNone
};

@interface OMBFinishListingSectionViewController : OMBTableViewController
{
  BOOL isEditing;
  //BOOL nextSection;
  OMBResidence *residence;
  OMBFinishListingSection tagSection;
}

@property (nonatomic, weak) OMBFinishListingViewController *delegate;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) nextSection;
- (void) save;

@end
