//
//  OMBCosignerCreateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCosignerCreateConnection.h"

#import "OMBCosigner.h"

@implementation OMBCosignerCreateConnection

#pragma mark - Initializer

- (id) initWithCosigner: (OMBCosigner *) object
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: @"%@/cosigners",
    OnMyBlockAPIURL];
  NSDictionary *objectParams = @{
    @"email":      object.email ? object.email : [NSNull null],
    @"first_name": object.firstName ? object.firstName : [NSNull null],
    @"last_name":  object.lastName ? object.lastName : [NSNull null],
    @"phone":      object.phone ? object.phone : [NSNull null],
    @"relationship_type": object.relationshipType ? 
      object.relationshipType : [NSNull null]
  };
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"cosigner": objectParams
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if ([self successful]) {
    if ([self.delegate respondsToSelector: @selector(JSONDictionary:)]) {
      [self.delegate JSONDictionary: [self json]];
    }    
  }
  else {
    [self createInternalErrorWithDomain: OMBConnectionErrorDomainCosigner
      code: OMBConnectionErrorDomainCosignerCodeCreateFailed];
  }

  [super connectionDidFinishLoading: connection];
}

@end
