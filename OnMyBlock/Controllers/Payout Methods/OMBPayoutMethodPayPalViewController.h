//
//  OMBPayoutMethodPayPalViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBSelectedPayoutMethodViewController.h"

#import "PayPalMobile.h"

@interface OMBPayoutMethodPayPalViewController : 
  OMBSelectedPayoutMethodViewController
<PayPalPaymentDelegate>

@end
