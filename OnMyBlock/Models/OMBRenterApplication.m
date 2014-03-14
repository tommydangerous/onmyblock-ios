//
//  OMBRenterApplication.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplication.h"

#import "OMBCosigner.h"
#import "OMBCosignerCreateConnection.h"
#import "OMBCosignerListConnection.h"
#import "OMBDeleteConnection.h"
#import "OMBEmployment.h"
#import "OMBLegalAnswer.h"
#import "OMBLegalQuestion.h"
#import "OMBPreviousRental.h"
#import "OMBRenterApplicationUpdateConnection.h"

@interface OMBRenterApplication ()
{
  NSMutableDictionary *cosigners;
}

@end

@implementation OMBRenterApplication

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _cats      = NO;
  _coapplicantCount = 0;
  _dogs      = NO;
  _employments     = [NSMutableArray array];
  _hasCosigner = NO;
  _legalAnswers    = [NSMutableDictionary dictionary];
  _previousRentals = [NSMutableArray array];

  cosigners = [NSMutableDictionary dictionary];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addCosigner: (OMBCosigner *) cosigner
{
  [cosigners setObject: cosigner forKey: 
    [NSNumber numberWithInt: cosigner.uid]];
}

- (void) addEmployment: (OMBEmployment *) employment
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"(%K == %@) AND (%K == %f)",
      @"companyName", employment.companyName, 
        @"startDate", employment.startDate];
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
  return [[cosigners allValues] sortedArrayUsingDescriptors: @[sort]];
}

- (void) createCosignerConnection: (OMBCosigner *) cosigner
delegate: (id) delegate completion: (void (^) (NSError *error)) block
{
  OMBCosignerCreateConnection *conn =
    [[OMBCosignerCreateConnection alloc] initWithCosigner: cosigner];
  conn.completionBlock = block;
  conn.delegate        = delegate;
  [conn start]; 
}

- (void) deleteCosignerConnection: (OMBCosigner *) cosigner
delegate: (id) delegate completion: (void (^) (NSError *error)) block
{
  OMBDeleteConnection *conn = [[OMBDeleteConnection alloc] initWithModelString:
    @"cosigners" UID: cosigner.uid];
  conn.completionBlock = block;
  conn.delegate = delegate;
  [conn start];
}

- (NSArray *) employmentsSortedByStartDate
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"startDate"
    ascending: NO];
  return [_employments sortedArrayUsingDescriptors: @[sort]];
}

- (void) fetchCosignersForUserUID: (NSUInteger) userUID delegate: (id) delegate
completion: (void (^) (NSError *error)) block
{
  OMBCosignerListConnection *conn = 
    [[OMBCosignerListConnection alloc] initWithUserUID: userUID];
  conn.completionBlock = block;
  conn.delegate        = delegate;
  [conn start];
}

- (OMBLegalAnswer *) legalAnswerForLegalQuestion: 
(OMBLegalQuestion *) legalQuestion
{
  return [_legalAnswers objectForKey: 
    [NSNumber numberWithInt: legalQuestion.uid]];
}

- (void) readFromCosignerDictionary: (NSDictionary *) dictionary
{
  NSMutableSet *newSet = [NSMutableSet set];
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    OMBCosigner *cosigner = [[OMBCosigner alloc] init];
    [cosigner readFromDictionary: dict];
    [self addCosigner: cosigner];

    [newSet addObject: [NSNumber numberWithInt: cosigner.uid]];
  }
  // Remove objects no longer suppose to be there
  NSMutableSet *oldSet = [NSMutableSet setWithArray: 
    [[cosigners allValues] valueForKey: @"uid"]];
  [oldSet minusSet: newSet];
  for (NSNumber *number in [oldSet allObjects]) {
    [cosigners removeObjectForKey: number];
  }
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // Cats
  if ([[dictionary objectForKey: @"cats"] intValue] == 1)
    _cats = YES;
  // Coapplicant count
  if ([dictionary objectForKey: @"coapplicant_count"] != [NSNull null])
    _coapplicantCount = [[dictionary objectForKey: 
      @"coapplicant_count"] intValue];
  // Dogs
  if ([[dictionary objectForKey: @"dogs"] intValue] == 1)
    _dogs = YES;
  // Facebook authenticated
  if ([[dictionary objectForKey: @"facebook_authenticated"] intValue])
    _facebookAuthenticated = YES;
  else
    _facebookAuthenticated = NO;
  // Has cosigner
  if ([[dictionary objectForKey: @"has_cosigner"] intValue] == 1)
    _hasCosigner = YES;
  else
    _hasCosigner = NO;
  // LinkedIn authenticated
  if ([[dictionary objectForKey: @"linkedin_authenticated"] intValue])
    _linkedinAuthenticated = YES;
  else
    _linkedinAuthenticated = NO;
}

- (void) removeAllObjects
{
  _cats = NO;
  _dogs = NO;
  [_employments removeAllObjects];
  [_legalAnswers removeAllObjects];
  [_previousRentals removeAllObjects];

  [cosigners removeAllObjects];
}

- (void) removeCosigner: (OMBCosigner *) cosigner
{
  [cosigners removeObjectForKey: [NSNumber numberWithInt: cosigner.uid]];
}

- (void) removeEmployment: (OMBEmployment *) employment
{
  for(int i=0; i< _employments.count; i++){
    if(((OMBEmployment *)_employments[i]).uid == employment.uid){
      [_employments removeObjectAtIndex: i];
    }
  }
}

- (void) updateWithDictionary: (NSDictionary *) dictionary
completion: (void (^) (NSError *error)) block
{
  OMBRenterApplicationUpdateConnection *conn = 
    [[OMBRenterApplicationUpdateConnection alloc] initWithRenterApplication:
      self dictionary: dictionary];
  conn.completionBlock = block;
  [conn start];
}

@end
