//
//  OMBPlaceOfferInformationStepsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/11/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBPlaceOfferInformationStepsViewController.h"

@implementation OMBPlaceOfferInformationStepsViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"How it Works";

  self.informationArray = @[
    @{
      @"title": @"Authorize",
      @"information": @"Review your offer and add "
        @"a payment method. You will NOT be charged until the landlord "
        @"accepts your offer. Only then can you confirm and pay for the place."
    },
    @{
      @"title": @"Review",
      @"information": @"The landlord or subletter will review your offer and "
        @"renter profile. They will have 24 hours to confirm your offer at "
        @"which point you will be notified."
    },
    @{
      @"title": @"Sign & Pay",
      @"information": @"Once accepted, you will receive a lease to e-sign via "
        @"email. You will have 48 hours to confirm, sign the lease, and pay "
        @"the 1st month’s rent and deposit using your selected payment method."
    }
  ];

  return self;
}

@end
