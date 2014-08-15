//
// Created by Tommy DANGerous on 8/4/14.
// Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBUser+Collections.h"

@implementation OMBUser (Collections)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)initializeCollections
{
  self.acceptedOffers            = [NSMutableDictionary dictionary];
  self.confirmedTenants          = [NSMutableDictionary dictionary];
  self.depositPayoutTransactions = [NSMutableDictionary dictionary];
  self.favorites                 = [NSMutableDictionary dictionary];
  self.imageSizeDictionary       = [NSMutableDictionary dictionary];
  self.messages                  = [NSMutableDictionary dictionary];
  self.movedIn                   = [NSMutableDictionary dictionary];
  self.movedInOut                = [NSMutableDictionary dictionary];
  self.payoutMethods             = [NSMutableDictionary dictionary];
  self.receivedOffers            = [NSMutableDictionary dictionary];
  self.residences = [NSMutableDictionary dictionaryWithDictionary: @{
    @"residences":          [NSMutableDictionary dictionary],
    @"temporaryResidences": [NSMutableDictionary dictionary]
  }];
  self.residencesVisited            = [NSMutableDictionary dictionary];
  self.heightForAboutTextDictionary = [NSMutableDictionary dictionary];
}

@end
