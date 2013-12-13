//
//  OMBPayPalVerifyMobilePaymentConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/12/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBPayPalVerifyMobilePaymentConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithPaymentConfirmation: (NSDictionary *) dictionary;

@end
