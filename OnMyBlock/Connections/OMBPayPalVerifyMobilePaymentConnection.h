//
//  OMBPayPalVerifyMobilePaymentConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBOffer;

@interface OMBPayPalVerifyMobilePaymentConnection : OMBConnection
{
  OMBOffer *offer;
}

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object 
paymentConfirmation: (NSDictionary *) dictionary;

@end
