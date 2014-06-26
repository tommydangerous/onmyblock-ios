//
//  OMBFeedbackSendEmailConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 5/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBFeedbackSendEmailConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithEmail: (NSString *) email content: (NSString *) content
userInfo: (NSDictionary *) userInfo;

@end
