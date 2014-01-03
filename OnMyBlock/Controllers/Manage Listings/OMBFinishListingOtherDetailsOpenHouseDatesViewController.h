//
//  OMBFinishListingOtherDetailsOpenHouseDatesViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingSectionViewController.h"

@interface OMBFinishListingOtherDetailsOpenHouseDatesViewController : 
  OMBFinishListingSectionViewController
{
  NSInteger openHouseDates;
  NSMutableDictionary *selectedDates;
  NSIndexPath *selectedIndexPath;
}

@end
