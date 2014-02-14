//
//  OMBMessageCreateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMessageCreateConnection.h"

#import "OMBMessage.h"

@implementation OMBMessageCreateConnection

#pragma mark - Initializer

- (id) initWithMessage: (OMBMessage *) object
{
  if (!(self = [super init])) return nil;

  message = object;

  NSString *string = [NSString stringWithFormat: @"%@/messages", 
    OnMyBlockAPIURL];
  NSMutableDictionary *objectParams = 
    [NSMutableDictionary dictionaryWithDictionary: @{
      @"content": message.content,
      @"recipient_id": [NSNumber numberWithInt: message.recipient.uid]
    }];
  if (message.residenceUID)
    [objectParams setObject: [NSNumber numberWithInt: message.residenceUID]
      forKey: @"residence_id"];
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"message": objectParams
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // NSLog(@"OMBMessageCreateConnection\n%@", [self json]);

  if ([self successful]) {
    // Do not read the created at from the server;
    // the server's time is different than user's time by about 1 minute
    // 40 seconds
    NSInteger uid = [[[self objectDictionary] objectForKey: @"id"] intValue];
    message.uid = uid;
    // [message readFromDictionary: [self objectDictionary]];
  }
  else {
    [self createInternalErrorWithDomain: OMBConnectionErrorDomainMessage
      code: OMBConnectionErrorDomainMessageCodeCreateFailed];
  }

  [super connectionDidFinishLoading: connection];
}

@end
