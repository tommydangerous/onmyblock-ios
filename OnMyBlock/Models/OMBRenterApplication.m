//
//  OMBRenterApplication.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBRenterApplication.h"

#import "OMBCosigner.h"
#import "OMBPreviousRental.h"

@implementation OMBRenterApplication

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _cats      = NO;
  _cosigners = [NSMutableArray array];
  _dogs      = NO;
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

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  if ([[dictionary objectForKey: @"cats"] intValue] == 1)
    _cats = YES;
  if ([[dictionary objectForKey: @"dogs"] intValue] == 1)
    _dogs = YES;
}

@end
