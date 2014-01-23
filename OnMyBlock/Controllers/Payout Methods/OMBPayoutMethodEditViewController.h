//
//  OMBPayoutMethodEditViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewController.h"

@class OMBPayoutMethod;

@interface OMBPayoutMethodEditViewController : OMBTableViewController
{
  BOOL deposit;
  OMBPayoutMethod *payoutMethod;
  BOOL primary;
}

#pragma mark - Initializer

- (id) initWithPayoutMethod: (OMBPayoutMethod *) object;

@end
