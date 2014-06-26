//
//  OMBConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/18/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

// App delegate
#import "OMBAppDelegate.h"
// View controllers
#import "OMBViewControllerContainer.h"

NSTimeInterval RequestTimeoutInterval = 20;
NSMutableArray *sharedConnectionList  = nil;
NSString *const OnMyBlockAPI          = @"/api-v1";

// Change the __ENVIRONMENT__ value in file OnMyBlock-Prefix.pch
#if __ENVIRONMENT__ == 1
  // Development server
  NSString *const OnMyBlockAPIURL = @"http://localhost:3000/api-v1";
  // Josselyn
  // NSString *const OnMyBlockAPIURL = @"http://10.0.1.8:3000/api-v1";
  // Santa Clara
  // NSString *const OnMyBlockAPIURL = @"http://192.168.1.107:3000/api-v1";
#elif __ENVIRONMENT__ == 2
  // Staging server
  NSString *const OnMyBlockAPIURL = @"http://ombrb.nodelist.com/api-v1";
#elif __ENVIRONMENT__ == 3
  // Production server
  NSString *const OnMyBlockAPIURL = @"https://onmyblock.com/api-v1";
#endif

NSString *const OnMyBlockCreatedSource = @"ios";

@implementation OMBConnection

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
  if (_completionBlock) {
    _completionBlock(internalError);
  }
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
  CGFloat percentage = x / y;

  // Use to notify the progress indicator
  [[NSNotificationCenter defaultCenter] postNotificationName:
    @"progressConnection" object: [NSNumber numberWithFloat: percentage]];

  // NSLog(@"%@: %f/%f (%f)", [_request URL].absoluteString, x, y, percentage);
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connection: (NSURLConnection *) connection
didFailWithError: (NSError *) error
{
  if (_completionBlock) {
    _completionBlock(error);
  }
  [sharedConnectionList removeObject: self];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

  OMBAppDelegate *appDelegate = 
    (OMBAppDelegate *) [UIApplication sharedApplication].delegate;
  [appDelegate.container showAlertViewWithError: error];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSString *) accessToken
{
  return [OMBUser currentUser].accessToken;
}

- (void) cancelConnection
{
  [internalConnection cancel];
}

- (void) createInternalErrorWithDomain: (NSString *) domain
code: (NSInteger) code
{
  id errorMessage = [self errorMessage];
  id errorTitle   = [self errorTitle];
  if ([self errorMessage] == (id) [NSNull null])
    errorMessage = @"Please try again.";
  else
    errorMessage = [errorMessage capitalizedString];
  if ([self errorTitle] == (id) [NSNull null])
    errorTitle = @"Error";
  else
    errorTitle = [errorTitle capitalizedString];
  internalError = [NSError errorWithDomain: domain code: code userInfo: @{
    NSLocalizedDescriptionKey:        errorTitle,
    NSLocalizedFailureReasonErrorKey: errorMessage,
  }];
}

- (NSString *) errorMessage
{
  if ([[self json] objectForKey: @"error_message"])
    return [[self json] objectForKey: @"error_message"];
  return @"";
}

- (NSString *) errorTitle
{
  if ([[self json] objectForKey: @"error_title"])
    return [[self json] objectForKey: @"error_title"];
  return @"";
}

- (NSDictionary *) json
{
  if (!jsonDictionary)
    jsonDictionary = [NSJSONSerialization JSONObjectWithData: container
      options: 0 error: nil];
  return jsonDictionary;
}

- (NSUInteger) numberOfPages
{
  return [[[self json] objectForKey: @"pages"] intValue];
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
parameters: (NSDictionary *) dictionary
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

- (void) setRequestWithString: (NSString *) requestString
parameters: (NSDictionary *) dictionary
{
  requestString = [requestString stringByAppendingString: @"?"];
  for (NSString *key in [dictionary allKeys]) {
    NSString *string = [NSString stringWithFormat: @"%@=%@&",
      key, [dictionary objectForKey: key]];
    requestString = [requestString stringByAppendingString: string];
  }
  [self setRequestWithString: requestString];
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
  [self startWithTimeoutInterval: 0 onMainRunLoop: NO];
}

- (void) startWithTimeoutInterval: (NSTimeInterval) interval
onMainRunLoop: (BOOL) onMain
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  container = [NSMutableData data];
  // Set timeout
  if (interval)
    timeoutInterval = interval;
  else
    timeoutInterval = RequestTimeoutInterval;
  [_request setTimeoutInterval: timeoutInterval];
  internalConnection = [[NSURLConnection alloc] initWithRequest: _request
    delegate: self startImmediately: NO];
  // During scrolling, the run loop is UITrackingRunLoopMode
  // By default, NSURLConnection schedules itself in NSDefaultRunLoopMode
  // Schedule the connection in the common modes, e.g. UITrackingRunLoopMode
  if (onMain)
    [internalConnection scheduleInRunLoop: [NSRunLoop mainRunLoop]
      forMode: NSDefaultRunLoopMode];
  else
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
    else if ([[[self json] objectForKey: @"success"] boolValue]) {
      return YES;
    }
  }
  return NO;
}

@end
