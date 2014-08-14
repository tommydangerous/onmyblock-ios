//
//  OMBGroup+Invitations.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBGroup+Invitations.h"

@implementation OMBGroup (Invitations)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (NSArray *)invitationsSortedByFirstName
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"firstName"
    ascending:YES];
  return [[self.invitations allValues] sortedArrayUsingDescriptors:@[sort]];
}

@end
