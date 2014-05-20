//
//  OMBRenterApplication.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplication.h"

#import "OMBConnectionProtocol.h"
#import "OMBCosigner.h"
#import "OMBCosignerCreateConnection.h"
#import "OMBCosignerListConnection.h"
#import "OMBModelCreateConnection.h"
#import "OMBModelDeleteConnection.h"
#import "OMBModelListConnection.h"
#import "OMBDeleteConnection.h"
#import "OMBEmployment.h"
#import "OMBLegalAnswer.h"
#import "OMBLegalQuestion.h"
#import "OMBPreviousRental.h"
#import "OMBRoommate.h"
#import "OMBRenterApplicationUpdateConnection.h"
#import "OMBSentApplication.h"
#import "OMBSentApplicationListConnection.h"

@interface OMBRenterApplication () <OMBConnectionProtocol>
{
  NSMutableDictionary *cosigners;
  NSMutableDictionary *employments;
  NSMutableDictionary *previousRentals;
  NSMutableDictionary *roommates;
  NSMutableDictionary *sentApplications;
}

@end

@implementation OMBRenterApplication

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _cats             = NO;
  _coapplicantCount = 0;
  _dogs             = NO;
  _hasCosigner      = NO;
  _legalAnswers     = [NSMutableDictionary dictionary];
  cosigners         = [NSMutableDictionary dictionary];
  employments       = [NSMutableDictionary dictionary];
  previousRentals   = [NSMutableDictionary dictionary];
  roommates         = [NSMutableDictionary dictionary];
  sentApplications  = [NSMutableDictionary dictionary];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol OMBConnectionProtocol

- (void) JSONDictionary: (NSDictionary *) dictionary
forResourceName: (NSString *) resourceName
{
  // Sent Applications
  if ([resourceName isEqualToString: [OMBSentApplication resourceName]]) {
    [self readFromSentApplicationDictionary: dictionary];
  }
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addCosigner: (OMBCosigner *) object
{
  [cosigners setObject: object forKey: [NSNumber numberWithInt: object.uid]];
}

- (void) addEmployment: (OMBEmployment *) object
{
  [employments setObject: object forKey: [NSNumber numberWithInt: object.uid]];
}

- (void) addModel: (OMBObject *) object
{
  NSNumber *key = [NSNumber numberWithInt: [object uid]];
  // Employments
  if ([[object modelName] isEqualToString: [OMBEmployment modelName]])
    [employments setObject: object forKey: key];
  // Previous rentals
  else if ([[object modelName] isEqualToString: [OMBPreviousRental modelName]])
    [previousRentals setObject: object forKey: key];
  // Roommate
  else if ([[object modelName] isEqualToString: [OMBRoommate modelName]])
    [roommates setObject: object forKey: key];
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

- (void) addRoommate: (OMBRoommate *) object
{
  // don't have uid,
  object.uid = [self lastIndexFromRoomates];
  [roommates setObject: object forKey: [NSNumber numberWithInt: object.uid]];
}

- (void) addSentApplication: (OMBSentApplication *) object
{
  [sentApplications setObject: object forKey: @(object.uid)];
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

- (void) createModelConnection: (OMBObject *) object
delegate: (id) delegate completion: (void (^) (NSError *error)) block
{
  OMBModelCreateConnection *conn =
    [[OMBModelCreateConnection alloc] initWithModel: object];
  conn.completionBlock = block;
  conn.delegate = delegate;
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

- (void) deleteModelConnection: (OMBObject *) object
delegate: (id) delegate completion: (void (^) (NSError *error)) block
{
  OMBModelDeleteConnection *conn = [[OMBModelDeleteConnection alloc]
    initWithModel: object];
  conn.completionBlock = block;
  conn.delegate        = delegate;
  [conn start];
}

- (NSArray *) employmentsSortedByStartDate
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"startDate"
    ascending: NO];
  return [[employments allValues] sortedArrayUsingDescriptors: @[sort]];
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

- (void) fetchListForResourceName: (NSString *) resourceName
userUID: (NSUInteger) userUID delegate: (id) delegate
completion: (void (^) (NSError *error)) block
{
  OMBModelListConnection *conn =
    [[OMBModelListConnection alloc] initWithResourceName: resourceName
      userUID: userUID];
  conn.completionBlock = block;
  conn.delegate = delegate;
  [conn start];
}

- (void) fetchSentApplicationsWithDelegate: (id) delegate
completion: (void (^) (NSError *error)) block
{
  OMBSentApplicationListConnection *conn =
    [[OMBSentApplicationListConnection alloc] init];
  conn.completionBlock = block;
  conn.delegate        = delegate;
  conn.resourceName    = [OMBSentApplication resourceName];
  [conn start];
}

- (NSInteger) lastIndexFromRoomates
{
  NSInteger index = 0;
  for(OMBRoommate *roommate in [roommates allValues]){
    if(index <= roommate.uid)
      index = roommate.uid + 1;
  }

  return index;
}

- (OMBLegalAnswer *) legalAnswerForLegalQuestion:
(OMBLegalQuestion *) legalQuestion
{
  return [_legalAnswers objectForKey:
    [NSNumber numberWithInt: legalQuestion.uid]];
}

- (NSArray *) objectsWithModelName: (NSString *) modelName
sortedWithKey: (NSString *) key ascending: (BOOL)  ascending
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: key
    ascending: ascending];
  NSArray *array = [NSArray array];
  // Employments
  if ([modelName isEqualToString: [OMBEmployment modelName]])
    array = [employments allValues];
  // Previous rentals
  else if ([modelName isEqualToString: [OMBPreviousRental modelName]])
    array = [previousRentals allValues];
  // Roommates
  else if ([modelName isEqualToString: [OMBRoommate modelName]])
    array = [roommates allValues];
  return [array sortedArrayUsingDescriptors: @[sort]];
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

- (void) readFromDictionary: (NSDictionary *) dictionary
forModelName: (NSString *) modelName
{
  if ([dictionary objectForKey: @"objects"] == [NSNull null])
    return;

  NSMutableSet *newSet = [NSMutableSet set];
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    id model;
    // Employments
    if ([modelName isEqualToString: [OMBEmployment modelName]]) {
      model = [[OMBEmployment alloc] init];
      [model readFromDictionary: dict];
    }
    // Previous rentals
    else if ([modelName isEqualToString: [OMBPreviousRental modelName]]) {
      model = [[OMBPreviousRental alloc] init];
      [model readFromDictionary: dict];
    }
    // Roommates
    else if ([modelName isEqualToString: [OMBRoommate modelName]]) {
      model = [[OMBRoommate alloc] init];
      [model readFromDictionary: dict];
    }
    [self addModel: model];
    [newSet addObject: [NSNumber numberWithInt: [model uid]]];
  }
  // Remove objects no longer suppose to be there
  NSArray *values;
  // Employments
  if ([modelName isEqualToString: [OMBEmployment modelName]]) {
    values = [employments allValues];
  }
  // Previous rentals
  else if ([modelName isEqualToString: [OMBPreviousRental modelName]]) {
    values = [previousRentals allValues];
  }
  // Roommates
  else if ([modelName isEqualToString: [OMBRoommate modelName]]) {
    values = [roommates allValues];
  }
  NSMutableSet *oldSet = [NSMutableSet setWithArray:
    [values valueForKey: @"uid"]];
  [oldSet minusSet: newSet];
  for (NSNumber *number in [oldSet allObjects]) {
    // Employments
    if ([modelName isEqualToString: [OMBEmployment modelName]]) {
      [employments removeObjectForKey: number];
    }
    // Previous rentals
    else if ([modelName isEqualToString: [OMBPreviousRental modelName]]) {
      [previousRentals removeObjectForKey: number];
    }
    // Roommates
    else if ([modelName isEqualToString: [OMBRoommate modelName]]) {
      [roommates removeObjectForKey: number];
    }
  }
}

- (void) readFromSentApplicationDictionary: (NSDictionary *) dictionary
{
  for (NSDictionary *dict in [dictionary objectForKey: @"objects"]) {
    OMBSentApplication *sa = [[OMBSentApplication alloc] init];
    [sa readFromDictionary: dict];
    [self addSentApplication: sa];
  }
}

- (void) removeAllObjects
{
  _cats = NO;
  _dogs = NO;
  [_legalAnswers removeAllObjects];

  [cosigners removeAllObjects];
  [employments removeAllObjects];
  [previousRentals removeAllObjects];
  [roommates removeAllObjects];
  [sentApplications removeAllObjects];
}

- (void) removeCosigner: (OMBCosigner *) object
{
  [cosigners removeObjectForKey: [NSNumber numberWithInt: object.uid]];
}

- (void) removeEmployment: (OMBEmployment *) object
{
  [employments removeObjectForKey: [NSNumber numberWithInt: object.uid]];
}

- (void) removeModel: (OMBObject *) object
{
  NSNumber *number = [NSNumber numberWithInt: [object uid]];
  // Employments
  if ([[object modelName] isEqualToString: [OMBEmployment modelName]])
    [employments removeObjectForKey: number];
  // Previous rentals
  else if ([[object modelName] isEqualToString: [OMBPreviousRental modelName]])
    [previousRentals removeObjectForKey: number];
  // Roommates
  else if ([[object modelName] isEqualToString: [OMBRoommate modelName]])
    [roommates removeObjectForKey: number];
}

- (void) removeRoommate: (OMBRoommate *) roommate
{
  [roommates removeObjectForKey: [NSNumber numberWithInt: roommate.uid]];
}

- (NSArray *) roommatesSort
{
  return [roommates allValues];
}

- (NSArray *) sentApplicationsSortedByKey: (NSString *) key
ascending: (BOOL) ascending
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: key
    ascending: ascending];
  return [[sentApplications allValues] sortedArrayUsingDescriptors: @[sort]];
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
