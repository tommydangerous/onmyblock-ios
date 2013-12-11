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
NSString *const OnMyBlockAPI          = @"/api-v1";

// Production server
// NSString *const OnMyBlockAPIURL = @"https://onmyblock.com/api-v1";
// Staging server
// NSString *const OnMyBlockAPIURL = @"http://ombrb.nodelist.com/api-v1";

// Localhost
// NSString *const OnMyBlockAPIURL = @"http://localhost:3000/api-v1";
// Josselyn
NSString *const OnMyBlockAPIURL = @"http://10.0.1.6:3000/api-v1";
// iPhone hotspot
// NSString *const OnMyBlockAPIURL = @"http://172.20.10.5:3000/api-v1";
// Evonexus
// NSString *const OnMyBlockAPIURL = @"http://172.17.1.23:3000/api-v1";
// Home
// NSString *const OnMyBlockAPIURL = @"http://192.168.1.72:3000/api-v1";
// Morgan's house
// NSString *const OnMyBlockAPIURL = @"http://192.168.2.136:3000/api-v1";

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
    _request   = (NSMutableURLRequest *) object;
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
  _request = [NSMutableURLRequest requestWithURL: url];
}

- (void) start
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  // Set timeout
  [_request setTimeoutInterval: RequestTimeoutInterval];
  container = [[NSMutableData alloc] init];
  internalConnection = [[NSURLConnection alloc] initWithRequest: _request
    delegate: self startImmediately: YES];
  if (!sharedConnectionList)
    sharedConnectionList = [NSMutableArray array];
  [sharedConnectionList addObject: self];
}

@end
