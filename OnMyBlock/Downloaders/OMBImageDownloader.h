//
//  OMBImageDownloader.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBImageDownloader : NSObject
{
  NSMutableData *activeDownload;
  NSURLConnection *imageConnection;
  NSURL *imageURL;
}

@property (nonatomic, copy) void (^completionBlock) (NSError *error);

#pragma mark - Protocol

#pragma mark Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection;

#pragma mark - Methods

#pragma mark Instance Methods

- (void) cancelDownload;
- (void) startDownload;

@end
