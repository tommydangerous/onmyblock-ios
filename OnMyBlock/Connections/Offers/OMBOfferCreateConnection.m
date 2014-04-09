//
//  OMBOfferCreateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferCreateConnection.h"

#import "NSString+Extensions.h"
#import "OMBOffer.h"
#import "OMBResidence.h"

@implementation OMBOfferCreateConnection

#pragma mark - Initializer

- (id) initWithOffer: (OMBOffer *) object
{
  if (!(self = [super init])) return nil;

  offer = object;

  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat       = @"yyyy-MM-dd HH:mm:ss ZZZ";

  NSString *string = [NSString stringWithFormat: @"%@/offers", OnMyBlockAPIURL];
  CGFloat amount = offer.amount;
  if (!amount)
    amount = 0;
  NSString *note = offer.note;
  if (!offer.note || ![[offer.note stripWhiteSpace] length])
    note = @"";
  NSInteger residenceID = object.residence.uid;
  if (!residenceID)
    residenceID = 0;
  NSMutableDictionary *objectParams =
    [NSMutableDictionary dictionaryWithDictionary: @{
      @"amount":       [NSNumber numberWithFloat: amount],
      @"note":         note,
      @"residence_id": [NSNumber numberWithInt: residenceID]
    }];

  // Authorization code
  if (offer.authorizationCode) {
    [objectParams setObject: offer.authorizationCode forKey: @"code"];
  }
  // Move-in date
  if (offer.moveInDate) {
    [objectParams setObject: [dateFormatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: offer.moveInDate]]
        forKey: @"move_in_date"];
  }
  // Move-out date
  if (offer.moveOutDate) {
    [objectParams setObject: [dateFormatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: offer.moveOutDate]]
        forKey: @"move_out_date"];
  }

  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"offer": objectParams
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if ([self successful]) {
    offer.uid = [self objectUID];
  }
  [super connectionDidFinishLoading: connection];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) start
{
  [self startWithTimeoutInterval: 60 onMainRunLoop: NO];
}

@end
