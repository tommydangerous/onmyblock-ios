//
//  OMBFinishListingOpenHouseDatesViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingSectionViewController.h"

@interface OMBFinishListingOpenHouseDatesViewController : 
  OMBFinishListingSectionViewController
<UIActionSheetDelegate>
{
  NSIndexPath *selectedIndexPath;
  UIActionSheet *sheet;
}

@end
