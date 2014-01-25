//
//  OMBPayoutMethodCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageTwoLabelCell.h"

@class OMBPayoutMethod;

@interface OMBPayoutMethodListCell : OMBImageTwoLabelCell
{
  UIView *imageHolder;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadPayoutMethod: (OMBPayoutMethod *) object;

@end
