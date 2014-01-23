//
//  OMBPayoutMethodPayPalViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBSelectedPayoutMethodViewController.h"

#import "PayPalMobile.h"

@class TextFieldPadding;

@interface OMBPayoutMethodPayPalViewController : 
  OMBSelectedPayoutMethodViewController
<PayPalPaymentDelegate, UITextFieldDelegate>
{
  TextFieldPadding *emailTextField;
}

@end
