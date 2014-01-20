//
//  OMBMessagesUnviewedCountConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/17/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMessagesUnviewedCountConnection.h"

@implementation OMBMessagesUnviewedCountConnection

#pragma mark - Init

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/messages/unviewed_count/?access_token=%@",
      OnMyBlockAPIURL, [OMBUser currentUser].accessToken];
  [self setRequestWithString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  // NSLog(@"OMBMessagesUnviewedCountConnection\n%@", json);

  NSInteger count = [[json objectForKey: @"count"] intValue];
  [[NSNotificationCenter defaultCenter] postNotificationName:
    OMBMessagesUnviewedCountNotification object: nil userInfo: @{
      @"count": [NSNumber numberWithInt: count]
    }
  ];

  [super connectionDidFinishLoading: connection];
}

@end
