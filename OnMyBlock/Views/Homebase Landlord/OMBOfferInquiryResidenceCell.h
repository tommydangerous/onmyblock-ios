//
//  OMBOfferInquiryResidenceCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBImageThreeLabelCell.h"

@class OMBResidence;

@interface OMBOfferInquiryResidenceCell : OMBImageThreeLabelCell

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidence: (OMBResidence *) object;

@end
