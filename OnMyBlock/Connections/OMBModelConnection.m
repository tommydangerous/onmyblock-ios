//
//  OMBModelConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/22/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBModelConnection.h"

#import "NSString+Extensions.h"

@implementation OMBModelConnection

#pragma mark - Initializer

- (id) initWithModel: (OMBObject *) object
{
  if (!(self = [super init])) return nil;

  self.resourceName = [object resourceName];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if ([self successful]) {
    // Delegate the parsing of JSON to the model
    if ([self.delegate respondsToSelector:
      @selector(JSONDictionary:forResourceName:)]){
      [self.delegate JSONDictionary: [self json]
        forResourceName: self.resourceName];
    }
    else if ([self.delegate respondsToSelector: @selector(JSONDictionary:)]) {
      [self.delegate JSONDictionary: [self json]];
    }
  }
  else {
    [self createInternalErrorWithDomain: OMBConnectionErrorDomainModel
      code: OMBConnectionErrorDomainModelCodeCreateFailed];
  }
  [super connectionDidFinishLoading: connection];
}

@end
