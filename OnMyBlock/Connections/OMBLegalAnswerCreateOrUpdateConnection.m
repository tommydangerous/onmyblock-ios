//
//  OMBLegalAnswerCreateOrUpdateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/11/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLegalAnswerCreateOrUpdateConnection.h"

#import "NSString+Extensions.h"
#import "OMBLegalAnswer.h"

@implementation OMBLegalAnswerCreateOrUpdateConnection

#pragma mark - Initializer

- (id) initWithLegalAnswer: (OMBLegalAnswer *) object;
{
  if (!(self = [super init])) return nil;

  legalAnswer = object;

  NSString *string = [NSString stringWithFormat:
    @"%@/legal_answers/create_or_update", OnMyBlockAPIURL];
  NSString *explanation = @"";
  if (legalAnswer.explanation &&
    [[legalAnswer.explanation stripWhiteSpace] length] > 0)
    explanation = legalAnswer.explanation;
  NSDictionary *objectParams = @{
    @"answer":            legalAnswer.answer ? @"1" : @"0",
    @"created_source":    OnMyBlockCreatedSource,
    @"explanation":       explanation,
    @"legal_question_id": [NSNumber numberWithInt: legalAnswer.legalQuestionID]
  };
  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"legal_answer": objectParams
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
  if ([[json objectForKey: @"success"] intValue] == 1) {
    NSDictionary *dict = [json objectForKey: @"object"];
    legalAnswer.uid = [[dict objectForKey: @"id"] intValue];
  }
  [super connectionDidFinishLoading: connection];
}


@end
