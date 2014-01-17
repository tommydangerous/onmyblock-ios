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
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"message": @{
      @"content":      message.content,
      @"recipient_id": [NSNumber numberWithInt: message.recipient.uid]
    }
  };
  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"OMBMessageCreateConnection\n%@", json);

  if ([[json objectForKey: @"success"] intValue]) {
    [message readFromDictionary: [json objectForKey: @"object"]];
  }

  [super connectionDidFinishLoading: connection];
}

@end
