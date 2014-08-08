//
//  OMBSentApplication+Group.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/8/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSentApplication.h"

@protocol OMBSentApplicationGroupDelegate <NSObject>

- (void)fetchGroupSucceeded;
- (void)fetchGroupFailed:(NSError *)error;

@end

@interface OMBSentApplication (Group)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)fetchGroupWithAccessToken:(NSString *)accessToken
delegate:(id<OMBSentApplicationGroupDelegate>)delegate;

@end
