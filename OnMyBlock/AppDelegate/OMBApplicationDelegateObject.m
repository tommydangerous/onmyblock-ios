//
//  OMBApplicationDelegateObject.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/15/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBApplicationDelegateObject.h"

// Networking
#import "OMBSessionManager.h"

@implementation OMBApplicationDelegateObject

#pragma mark - Methods

#pragma mark - Class Methods

#pragma mark - Public Methods

+ (OMBApplicationDelegateObject *)sharedObject
{
  static OMBApplicationDelegateObject *object = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    object = [[OMBApplicationDelegateObject alloc] init];
  });
  return object;
}

#pragma mark - Instance Methods

#pragma mark - Private Methods

- (void)checkMinimumVersion
{
  [[OMBSessionManager sharedManager] GET:@"system/minimum-version" parameters:@{
    @"platform": @"ios"
  } success:^(NSURLSessionDataTask *task, id responseObject) {
    id minimumVersion = [responseObject objectForKey:@"version"];
    if (minimumVersion != [NSNull null]) {
      NSString *currentVersion = 
        [[NSBundle mainBundle] objectForInfoDictionaryKey:
          @"CFBundleShortVersionString"];
      NSArray *currentVersionNumbers = 
        [currentVersion componentsSeparatedByString:@"."];

      NSArray *minimumVersionNumbers = 
        [minimumVersion componentsSeparatedByString:@"."];

      if ([currentVersionNumbers count] == [minimumVersionNumbers count]) {
        BOOL older = NO;
        for (int i = 0; i < [currentVersionNumbers count]; i++) {
          int currentNumber        = [currentVersionNumbers[i] intValue];
          int minimumVersionNumber = [minimumVersionNumbers[i] intValue];
          if (currentNumber < minimumVersionNumber) {
            older = YES;
            break;
          }
          else if (currentNumber > minimumVersionNumber) {
            older = NO;
            break;
          }
        }
        if (older) {
          NSString *message = [NSString stringWithFormat:
            @"You are using an unsupported version, "
            @"please update to version %@", minimumVersion];
          UIAlertView *alertView = 
            [[UIAlertView alloc] initWithTitle:@"Please Update"
            message:message delegate:self cancelButtonTitle:@"Update" 
              otherButtonTitles:nil];
          [alertView show];
        }
      }
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSString *message = error.localizedFailureReason != (id) [NSNull null] ?
      error.localizedFailureReason : @"Please try again.";
    NSString *title =  error.localizedDescription != (id) [NSNull null] ?
      error.localizedDescription : @"Unsuccessful";

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
      message:message delegate:nil cancelButtonTitle:@"Okay"
        otherButtonTitles:nil];
    [alertView show];
    NSLog(@"%@", error);
  }];
}

#pragma mark - Protocol

#pragma mark - Protocol UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
      @"https://itunes.apple.com/us/app/onmyblock/id737199914?mt=8"]];
  }
}

@end
