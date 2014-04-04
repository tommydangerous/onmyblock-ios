//
//  OMBViewController+PayPalPayment.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 4/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

#import "PayPalMobile.h"

@interface OMBViewController (PayPalPayment)

- (PayPalPaymentViewController *) payPalPaymentViewControllerWithAmount:
(CGFloat) amount
intent: (PayPalPaymentIntent) intent
shortDescription: (NSString *) shortDescription delegate: (id) delegate;

@end
