//
//  OMBUser+Groups.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBUser+Groups.h"

// Models
#import "OMBGroup.h"

@implementation OMBUser (Groups)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)addGroup:(OMBGroup *)group
{
  [self.groups  setObject:group forKey:@(group.uid)];
}

@end
