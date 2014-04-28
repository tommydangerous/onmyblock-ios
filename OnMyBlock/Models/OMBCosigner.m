//
//  OMBCosigner.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCosigner.h"

#import "OMBConnectionProtocol.h"

@implementation OMBCosigner

#pragma mark - Override

#pragma mark - Override NSObject

- (NSUInteger) hash
{
  return self.uid;
}

- (BOOL) isEqual: (id) anObject
{
  return self.uid == [(OMBCosigner *) anObject uid];
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) modelName
{
  return @"cosigner";
}

+ (NSString *) resourceName
{
  return [NSString stringWithFormat: @"%@s", [OMBCosigner modelName]];
}

#pragma mark - Instance Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  // Email
  id email = [dictionary objectForKey: @"email"];
  if (email != [NSNull null]) {
    self.email = email;
  }

  // First name
  id firstName = [dictionary objectForKey: @"first_name"];
  if (firstName != [NSNull null])
    self.firstName = firstName;

  // Last name
  id lastName = [dictionary objectForKey: @"last_name"];
  if (lastName != [NSNull null])
    self.lastName = lastName;

  // Phone
  id phone = [dictionary objectForKey: @"phone"];
  if (phone != [NSNull null])
    self.phone = phone;

  // Relationship type
  id relationshipType = [dictionary objectForKey: @"relationship_type"];
  if (relationshipType != [NSNull null])
    self.relationshipType = relationshipType;

  // UID
  id uid = [dictionary objectForKey: @"id"];
  if (uid != [NSNull null])
    self.uid = [uid intValue];
}

@end
