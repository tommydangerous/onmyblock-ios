//
//  OMBRenterApplication.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplication.h"

#import "OMBCosigner.h"
#import "OMBEmployment.h"
#import "OMBLegalAnswer.h"
#import "OMBLegalQuestion.h"
#import "OMBPreviousRental.h"

@implementation OMBRenterApplication

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _cats      = NO;
  _cosigners = [NSMutableArray array];
  _dogs      = NO;
  _employments     = [NSMutableArray array];
  _legalAnswers    = [NSMutableDictionary dictionary];
  _previousRentals = [NSMutableArray array];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addCosigner: (OMBCosigner *) cosigner
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"(%K == %@) AND (%K == %@)", 
      @"firstName", cosigner.firstName, @"lastName", cosigner.lastName];
  NSArray *array = [_cosigners filteredArrayUsingPredicate: predicate];
  if ([array count] == 0)
    [_cosigners addObject: cosigner];
}

- (void) addEmployment: (OMBEmployment *) employment
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"(%K == %@) AND (%K == %@)",
      @"companyName", employment.companyName, @"title", employment.title];
  NSArray *array = [_employments filteredArrayUsingPredicate: predicate];
  if ([array count] == 0)
    [_employments addObject: employment];
}

- (void) addLegalAnswer: (OMBLegalAnswer *) legalAnswer
{
  NSNumber *key = [NSNumber numberWithInt: legalAnswer.legalQuestionID];
  OMBLegalAnswer *object = [_legalAnswers objectForKey: key];
  if (object) {
    object.answer      = legalAnswer.answer;
    object.explanation = legalAnswer.explanation;
  }
  else
    [_legalAnswers setObject: legalAnswer forKey: key];
}

- (void) addPreviousRental: (OMBPreviousRental *) previousRental
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"(%K == %@) AND (%K == %@) AND (%K == %@)", 
      @"address", previousRental.address, @"city", previousRental.city,
        @"state", previousRental.state];
  NSArray *array = [_previousRentals filteredArrayUsingPredicate: predicate];
  if ([array count] == 0)
    [_previousRentals insertObject: previousRental atIndex: 0];
}

- (NSArray *) cosignersSortedByFirstName
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"firstName"
    ascending: YES];
  return [_cosigners sortedArrayUsingDescriptors: @[sort]];
}

- (NSArray *) employmentsSortedByStartDate
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"startDate"
    ascending: NO];
  return [_employments sortedArrayUsingDescriptors: @[sort]];
}

- (OMBLegalAnswer *) legalAnswerForLegalQuestion: 
(OMBLegalQuestion *) legalQuestion
{
  return [_legalAnswers objectForKey: 
    [NSNumber numberWithInt: legalQuestion.uid]];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  if ([[dictionary objectForKey: @"cats"] intValue] == 1)
    _cats = YES;
  if ([[dictionary objectForKey: @"dogs"] intValue] == 1)
    _dogs = YES;
}

- (void) removeAllObjects
{
  _cats = NO;
  _dogs = NO;
  [_cosigners removeAllObjects];
  [_employments removeAllObjects];
  [_legalAnswers removeAllObjects];
  [_previousRentals removeAllObjects];
}

@end
