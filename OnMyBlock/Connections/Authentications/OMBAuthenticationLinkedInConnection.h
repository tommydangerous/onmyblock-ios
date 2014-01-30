//
//  OMBAuthenticationLinkedInConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/29/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@interface OMBAuthenticationLinkedInConnection : OMBConnection

#pragma mark - Initializer

- (id) initWithLinkedInAccessToken: (NSString *) accessToken;

@end
