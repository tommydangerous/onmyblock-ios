//
//  OMBSentApplication+Group.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/8/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSentApplication+Group.h"

// Models
#import "OMBGroup.h"

@implementation OMBSentApplication (Group)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)fetchGroupWithAccessToken:(NSString *)accessToken
delegate:(id<OMBSentApplicationGroupDelegate>)delegate
{
  [[self sessionManager] GET:@"sent_applications/group" parameters:@{
    @"access_token":        accessToken,
    @"sent_application_id": @(self.uid)
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    self.group = [[OMBGroup alloc] init];
    [self.group readFromDictionary:responseObject];
    if ([delegate respondsToSelector:@selector(fetchGroupSucceeded)]) {
      [delegate fetchGroupSucceeded];
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    if ([delegate respondsToSelector:@selector(fetchGroupFailed:)]) {
      [delegate fetchGroupFailed:error];
    }
  }];
}

@end
