//
//  OMBPreviousRentalListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/9/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPreviousRentalListConnection.h"

@implementation OMBPreviousRentalListConnection

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;
{
  if (!(self = [super init])) return self;

  user = object;

  NSString *string = [NSString stringWithFormat: 
    @"%@/previous_rentals?access_token=%@&user_id=%i", 
      OnMyBlockAPIURL, [OMBUser currentUser].accessToken, user.uid];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  self.request = req;

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  // [user readFromPreviousRentalDictionary: json];
  [super connectionDidFinishLoading: connection];
}

@end
