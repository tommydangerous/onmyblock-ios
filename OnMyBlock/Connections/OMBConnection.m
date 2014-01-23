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

// Change the __ENVIRONMENT__ value in file OnMyBlock-Prefix.pch
#if __ENVIRONMENT__ == 1
  // Development server
  NSString *const OnMyBlockAPIURL = @"http://localhost:3000/api-v1";
  // Josselyn
  // NSString *const OnMyBlockAPIURL = @"http://10.0.1.33:3000/api-v1";
  // Hotspot
  // NSString *const OnMyBlockAPIURL = @"http://172.20.10.5:3000/api-v1";
#elif __ENVIRONMENT__ == 2
  // Staging server
  NSString *const OnMyBlockAPIURL = @"http://ombrb.nodelist.com/api-v1";
#elif __ENVIRONMENT__ == 3
  // Production server
  NSString *const OnMyBlockAPIURL = @"https://onmyblock.com/api-v1";
#endif

// Home
// NSString *const OnMyBlockAPIURL = @"http://192.168.1.72:3000/api-v1";

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
    if (now - conn.createdAt > [conn.request timeoutInterval]) {
      [conn cancelConnection];
      [connectionsToRemove addObject: conn];
    }
  }
  for (OMBConnection *conn in connectionsToRemove)
    [sharedConnectionList removeObject: conn];
  if (sharedConnectionList.count == 0)
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) connection: (NSURLConnection *) connection 
didSendBodyData: (NSInteger) bytesWritten 
totalBytesWritten: (NSInteger) totalBytesWritten 
totalBytesExpectedToWrite: (NSInteger) totalBytesExpectedToWrite
{
  CGFloat x = (CGFloat) totalBytesWritten;
  CGFloat y = (CGFloat) totalBytesExpectedToWrite;
  NSLog(@"%@: %f", [_request URL].absoluteString, x / y);
    
  // use to notify the progress indicator
  [[NSNotificationCenter defaultCenter] postNotificationName:@"progressConnection" object:[NSNumber numberWithFloat: x/y]];
    
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connection: (NSURLConnection *) connection
didFailWithError: (NSError *) error
{
  if (_completionBlock)
    _completionBlock(error);
  [sharedConnectionList removeObject: self];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  NSLog(@"%@", error.localizedDescription);
}

#pragma mark - Methods

#pragma mark Instance Methods

- (void) cancelConnection
{
  [internalConnection cancel];
}

- (NSDictionary *) json
{
  if (!jsonDictionary)
    jsonDictionary = [NSJSONSerialization JSONObjectWithData: container
      options: 0 error: nil];
  return jsonDictionary;
}

- (NSDictionary *) objectDictionary
{
  return [[self json] objectForKey: @"object"];
}

- (NSDictionary *) objectsDictionary
{
  return [[self json] objectForKey: @"objects"];
}

- (NSInteger) objectUID
{
  return [[[self objectDictionary] objectForKey: @"id"] intValue];
}

- (void) setPostRequestWithString: (NSString *) string
withParameters: (NSDictionary *) dictionary
{
  [self setRequestWithString: string method: @"POST" parameters: dictionary];
}

- (void) setRequestWithString: (NSString *) requestString
{
  NSURL *url = [NSURL URLWithString:
    [requestString stringByAddingPercentEscapesUsingEncoding:
      NSUTF8StringEncoding]];
  _request = [NSMutableURLRequest requestWithURL: url];
}

- (void) setRequestWithString: (NSString *) string method: (NSString *) method
parameters: (NSDictionary *) dictionary
{
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSData *json = [NSJSONSerialization dataWithJSONObject: dictionary
    options: 0 error: nil];
  [req addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
  [req setHTTPBody: json];
  [req setHTTPMethod: [method uppercaseString]];
  _request = req;
}

- (void) start
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  // Set timeout
  [_request setTimeoutInterval: RequestTimeoutInterval];
  container = [[NSMutableData alloc] init];
  internalConnection = [[NSURLConnection alloc] initWithRequest: _request
    delegate: self startImmediately: NO];
  // During scrolling, the run loop is UITrackingRunLoopMode
  // By default, NSURLConnection schedules itself in NSDefaultRunLoopMode
  // Schedule the connection in the common modes, e.g. UITrackingRunLoopMode
  [internalConnection scheduleInRunLoop: [NSRunLoop currentRunLoop]
    forMode: NSRunLoopCommonModes];
  [internalConnection start];
  if (!sharedConnectionList)
    sharedConnectionList = [NSMutableArray array];
  [sharedConnectionList addObject: self];
}

- (BOOL) successful
{
  if ([[self json] objectForKey: @"success"] != [NSNull null]) {
    if ([[[self json] objectForKey: @"success"] intValue]) {
      return YES;
    }
  }
  return NO;
}

@end
