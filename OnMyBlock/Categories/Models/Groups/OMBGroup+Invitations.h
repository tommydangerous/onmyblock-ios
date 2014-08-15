//
//  OMBGroup+Invitations.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/14/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBGroup.h"

@class OMBInvitation;

@protocol OMBGroupInvitationsDelegate <NSObject>

@optional

- (void)deleteInvitationFailed:(NSError *)error;
- (void)deleteInvitationSucceeded;

@end

@interface OMBGroup (Invitations)

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void)deleteInvitation:(OMBInvitation *)invitation 
accessToken:(NSString *)accessToken 
delegate:(id<OMBGroupInvitationsDelegate>)delegate;
- (NSArray *)invitationsSortedByFirstName;

@end
