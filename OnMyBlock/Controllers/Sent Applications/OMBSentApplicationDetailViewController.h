//
//  OMBSentApplicationDetailViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferInquiryViewController.h"

@class OMBSentApplication;

@interface OMBSentApplicationDetailViewController : OMBOfferInquiryViewController

#pragma mark - Initializer

- (id) initWithSentApplication: (OMBSentApplication *) object;

@end
