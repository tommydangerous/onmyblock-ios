//
//  OMBLegalAnswer.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLegalAnswer.h"

@implementation OMBLegalAnswer

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  if ([[dictionary objectForKey: @"answer"] intValue] == 1)
    _answer = YES;
  else
    _answer = NO;

  id explanation = [dictionary objectForKey: @"explanation"];
  if (explanation != [NSNull null]) {
    self.explanation = [dictionary objectForKey: @"explanation"];
  }
  
  _legalQuestionID = [[dictionary objectForKey: @"legal_question_id"] intValue];
  _uid = [[dictionary objectForKey: @"id"] intValue];
}

@end
