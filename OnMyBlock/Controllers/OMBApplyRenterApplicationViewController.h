//
//  OMBApplyRenterApplicationViewController.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 5/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMyRenterProfileViewController.h"

@class LEffectLabel;
@class OMBAlertViewBlur;

@interface OMBApplyRenterApplicationViewController : OMBMyRenterProfileViewController
{
  OMBAlertViewBlur *alertBlur;
  UIButton *submitOfferButton;
  LEffectLabel *effectLabel;
}

@end
