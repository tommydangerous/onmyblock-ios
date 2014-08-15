//
//  OMBSchoolStore.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBSchoolStore : NSObject
{
  NSMutableArray *schools;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBSchoolStore *) sharedStore;

#pragma mark - Instance Methods

- (NSArray *) schools;

@end
