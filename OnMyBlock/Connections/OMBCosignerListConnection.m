//
//  OMBCosignerListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCosignerListConnection.h"

@implementation OMBCosignerListConnection

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;
{
  if (!(self = [super init])) return self;

  user = object;

  NSString *string = [NSString stringWithFormat: 
    @"%@/cosigners?access_token=%@&user_id=%i", 
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
  [user readFromCosignerDictionary: json];
  [super connectionDidFinishLoading: connection];
}

@end
