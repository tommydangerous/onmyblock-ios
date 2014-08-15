//
//  OMBGroup+Invitations.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBGroup+Invitations.h"

// Models
#import "OMBInvitation.h"

@implementation OMBGroup (Invitations)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Private

- (void)removeInvitation:(OMBInvitation *)invitation
{
  [self.invitations removeObjectForKey:@(invitation.uid)];
}

#pragma mark - Public

- (void)deleteInvitation:(OMBInvitation *)invitation 
accessToken:(NSString *)accessToken 
delegate:(id<OMBGroupInvitationsDelegate>)delegate
{
  NSString *urlString = [NSString stringWithFormat:@"invitations/%i", 
    invitation.uid];
  [[self sessionManager] DELETE:urlString parameters:@{
    @"access_token": accessToken
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    if ([delegate respondsToSelector:@selector(deleteInvitationSucceeded)]) {
      [self removeInvitation:invitation];
      [delegate deleteInvitationSucceeded];
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    if ([delegate respondsToSelector:@selector(deleteInvitationFailed:)]) {
      [delegate deleteInvitationFailed:error];
    }
  }];
}

- (NSArray *)invitationsSortedByFirstName
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"firstName"
    ascending:YES];
  return [[self.invitations allValues] sortedArrayUsingDescriptors:@[sort]];
}

@end
