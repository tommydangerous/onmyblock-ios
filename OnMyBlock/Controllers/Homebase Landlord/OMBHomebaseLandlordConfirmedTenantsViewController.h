//
//  OMBHomebaseLandlordConfirmedTenantsViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBOffer;

@interface OMBHomebaseLandlordConfirmedTenantsViewController : 
  OMBTableViewController
{
  OMBOffer *offer;
}

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object;

@end
