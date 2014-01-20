//
//  OMBLegalQuestionListConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLegalQuestionListConnection.h"

#import "OMBLegalQuestion.h"

@implementation OMBLegalQuestionListConnection

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/legal_questions/?access_token=%@",
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
  for (NSDictionary *dictionary in [json objectForKey: @"objects"]) {
    OMBLegalQuestion *object = [[OMBLegalQuestion alloc] init];
    [object readFromDictionary: dictionary];
  }
  [super connectionDidFinishLoading: connection];
}

@end
