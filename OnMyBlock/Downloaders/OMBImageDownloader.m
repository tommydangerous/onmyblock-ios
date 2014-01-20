//
//  OMBImageDownloader.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBImageDownloader.h"

@implementation OMBImageDownloader

@synthesize completionBlock = _completionBlock;
@synthesize imageURL        = _imageURL;

#pragma mark - Protocol

#pragma mark Protocol NSURLConnectionDataDelegate

- (void) connection: (NSURLConnection *) connection
didReceiveData: (NSData *) data
{
  [activeDownload appendData: data];
}

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  [self cancelDownload];
  if (_completionBlock)
    _completionBlock(nil);
}

#pragma mark Protocol NSURLConnectionDelegate

- (void) connection: (NSURLConnection *) connection
didFailWithError: (NSError *) error
{
  [self cancelDownload];
  if (_completionBlock)
    _completionBlock(error);
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) cancelDownload
{
  [imageConnection cancel];
  activeDownload  = nil;
  imageConnection = nil;
}

- (void) startDownload
{
  activeDownload  = [NSMutableData data];
  imageConnection = [[NSURLConnection alloc] initWithRequest:
    [NSURLRequest requestWithURL: _imageURL] delegate: self
      startImmediately: NO];
  [imageConnection scheduleInRunLoop: [NSRunLoop currentRunLoop]
    forMode: NSRunLoopCommonModes];
  [imageConnection start];
}

@end
