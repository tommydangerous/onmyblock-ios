//
//  OMBLegalQuestionStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/10/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBLegalQuestionStore.h"

#import "OMBLegalQuestion.h"
#import "OMBLegalQuestionListConnection.h"

@implementation OMBLegalQuestionStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _legalQuestions = [NSMutableDictionary dictionary];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBLegalQuestionStore *) sharedStore
{
  static OMBLegalQuestionStore *store = nil;
  if (!store) {
    store = [[OMBLegalQuestionStore alloc] init];
  }
  return store;
}

#pragma mark - Instance Methods

- (void) addLegalQuestion: (OMBLegalQuestion *) object
{
  OMBLegalQuestion *question = [_legalQuestions objectForKey: 
    [NSNumber numberWithInt: object.uid]];
  if (question) {
    // If the questions don't match, update the question
    if (![question.question isEqualToString: object.question])
      question.question = object.question;
  }
  else {
    [_legalQuestions setObject: object forKey: 
      [NSNumber numberWithInt: object.uid]];
  }
}

- (void) fetchLegalQuestionsWithCompletion: (void (^)(NSError *)) block
{
  OMBLegalQuestionListConnection *connection = 
    [[OMBLegalQuestionListConnection alloc] init];
  connection.completionBlock = block;
  [connection start];
}

- (NSArray *) questionsSortedByQuestion
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:
    @"question" ascending: YES];
  return [[_legalQuestions allValues] sortedArrayUsingDescriptors: @[sort]];
}

@end
