//
//  OMBConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

NSTimeInterval RequestTimeoutInterval = 10;
NSMutableArray *sharedConnectionList  = nil;
// Localhost
// NSString *const OnMyBlockAPIURL       = @"http://localhost:3000";

// Evonexus
// NSString *const OnMyBlockAPIURL       = @"http://172.17.1.23:3000";

// Home
// NSString *const OnMyBlockAPIURL       = @"http://192.168.1.72:3000";

// Production server
NSString *const OnMyBlockAPIURL       = @"http://onmyblock.com";

// Staging server
// NSString *const OnMyBlockAPIURL       = @"http://ombrb.nodelist.com";

@implementation OMBConnection

@synthesize completionBlock = _completionBlock;
@synthesize createdAt       = _createdAt;
@synthesize delegate        = _delegate;
@synthesize request         = _request;

#pragma mark - Initializer

- (id) init
{
  return [self initWithRequest: nil];
}

- (id) initWithRequest: (NSURLRequest *) object
{
  self = [super init];
  if (self) {
    _createdAt = [[NSDate date] timeIntervalSince1970];
    _request   = object;
  }
  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connection: (NSURLConnection *) connection
didReceiveData: (NSData *) data
{
  [container appendData: data];
}

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if (_completionBlock)
    _completionBlock(nil);
  [sharedConnectionList removeObject: self];
  NSMutableArray *connectionsToRemove = [NSMutableArray array];
  for (OMBConnection *conn in sharedConnectionList) {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - conn.createdAt > 5) {
      [conn cancelConnection];
      [connectionsToRemove addObject: conn];
    }
  }
  for (OMBConnection *conn in connectionsToRemove)
    [sharedConnectionList removeObject: conn];
  if (sharedConnectionList.count == 0)
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connection: (NSURLConnection *) connection
didFailWithError: (NSError *) error
{
  if (_completionBlock)
    _completionBlock(error);
  [sharedConnectionList removeObject: self];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Methods

#pragma mark Instance Methods

- (void) cancelConnection
{
  [internalConnection cancel];
}

- (void) setRequestFromString: (NSString *) requestString
{
  NSURL *url = [NSURL URLWithString:
    [requestString stringByAddingPercentEscapesUsingEncoding:
      NSUTF8StringEncoding]];
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL: url];
  [urlRequest setTimeoutInterval: RequestTimeoutInterval];
  _request = urlRequest;
}

- (void) start
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  container = [[NSMutableData alloc] init];
  internalConnection = [[NSURLConnection alloc] initWithRequest: _request
    delegate: self startImmediately: YES];
  if (!sharedConnectionList)
    sharedConnectionList = [NSMutableArray array];
  [sharedConnectionList addObject: self];
}

@end
