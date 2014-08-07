//
//  OMBSessionManager.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 8/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSessionManager.h"

#import "OMBConnection.h"

@implementation OMBSessionManager

#pragma mark - Methods

#pragma mark - Class Methods

#pragma mark - Public

+ (OMBSessionManager *)sharedManager
{
  static OMBSessionManager *_sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSURL *baseURL = [NSURL URLWithString:OnMyBlockAPIURL];
    NSURLSessionConfiguration *configuration = 
      [NSURLSessionConfiguration defaultSessionConfiguration];
    _sharedManager = 
      [[OMBSessionManager alloc] initWithBaseURL:baseURL
        sessionConfiguration:configuration];
  });
  return _sharedManager;
}

@end
