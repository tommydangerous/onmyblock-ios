//
//  OMBConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OMBUser.h"

extern NSTimeInterval RequestTimeoutInterval;
extern NSMutableArray *sharedConnectionList;
extern NSString *const OnMyBlockAPI;
extern NSString *const OnMyBlockAPIURL;

@interface OMBConnection : NSURLConnection
{
  NSMutableData *container;
  NSURLConnection *internalConnection;
}

@property (nonatomic, copy) void (^completionBlock) (NSError *error);
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableURLRequest *request;

#pragma mark - Initializer

- (id) initWithRequest: (NSURLRequest *) object;

#pragma mark - Protocol

#pragma mark Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection;

#pragma mark Protocol NSURLConnectionDelegate

- (void) connection: (NSURLConnection *) connection
didFailWithError: (NSError *) error;

#pragma mark - Methods

#pragma mark Instance Methods

- (void) cancelConnection;
- (void) setRequestFromString: (NSString *) requestString;

@end
