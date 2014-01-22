//
//  OMBOfferDecisionConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/21/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

typedef enum {
  OMBOfferDecisionConnectionTypeAccept,
  OMBOfferDecisionConnectionTypeConfirm,
  OMBOfferDecisionConnectionTypeDecline,
  OMBOfferDecisionConnectionTypeReject
} OMBOfferDecisionConnectionType;

@class OMBOffer;

@interface OMBOfferDecisionConnection : OMBConnection
{
  OMBOffer *offer;
}

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object 
decision: (OMBOfferDecisionConnectionType) type;

@end
