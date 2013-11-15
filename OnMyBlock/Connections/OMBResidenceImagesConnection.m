//
//  OMBResidenceImagesConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceImagesConnection.h"

#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBResidenceGoogleStaticImageDownloader.h"
#import "OMBResidenceImageDownloader.h"
#import "UIImage+Resize.h"

@implementation OMBResidenceImagesConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;
  // http://localhost:3000/places/135/show_images.json
  NSString *string = [NSString stringWithFormat:
    @"%@/places/%i/show_images/", OnMyBlockAPIURL, residence.uid];
  [self setRequestFromString: string];

  return self;
}

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  NSArray *array = (NSArray *) [json objectForKey: @"images"];
  OMBResidenceDetailViewController *viewController = 
    (OMBResidenceDetailViewController *) self.delegate;
  if ([viewController.imageViewArray count] == 0) {
    CGSize size = CGSizeMake(
      viewController.imagesScrollView.frame.size.width,
        viewController.imagesScrollView.frame.size.height);
    // If the residence has no image, use the cover photo
    // which is most likely the Google Static street view image
    if ([array count] == 0) {
      // This will set the cover photo as the first and probably
      // only image in the residence's image scroll view
      void (^block) (void) = ^(void) {
        UIImageView *imageView    = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds   = YES;
        imageView.contentMode     = UIViewContentModeTopLeft;
        imageView.image           = [UIImage image: 
          [residence coverPhoto] sizeToFitVertical: size];
        [viewController.imageViewArray addObject: imageView];
        [viewController addImageViewsToImageScrollView];
        viewController.pageOfImagesLabel.text = 
          [NSString stringWithFormat: @"%i/%i",
            [viewController currentPageOfImages], 
              (int) [[residence imagesArray] count]];
      };
      // If residence has a cover photo
      if ([residence coverPhoto]) {
        block();
      }
      else {
        // Download the Google Static street view image
        OMBResidenceGoogleStaticImageDownloader *downloader =
          [[OMBResidenceGoogleStaticImageDownloader alloc] initWithResidence:
            residence url: [residence googleStaticStreetViewImageURL]];
        downloader.completionBlock = ^(NSError *error) {
          block();
          [super connectionDidFinishLoading: connection];
        };
        [downloader startDownload];
        [residence.images setObject:
          [UIImage imageNamed: @"placeholder_property.png"] forKey: @"1"];
      }
    }
    for (NSString *jsonString in array) {
      // Create X number of image views for the residence detail view controller
      UIImageView *imageView    = [[UIImageView alloc] init];
      imageView.backgroundColor = [UIColor clearColor];
      imageView.clipsToBounds   = YES;
      imageView.contentMode     = UIViewContentModeTopLeft;
      [viewController.imageViewArray addObject: imageView];
      // Download the image
      NSData *data = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
      NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: data
        options: 0 error: nil];
      NSString *string = [dict objectForKey: @"image"];
      int position;
      if ([dict objectForKey: @"position"] == [NSNull null]) {
        residence.lastImagePosition += 1;
        position = residence.lastImagePosition;
      }
      else {
        position = [[dict objectForKey: @"position"] intValue];
      }
      // If URL is something like this //ombrb-prod.s3.amazonaws.com
      if ([string hasPrefix: @"//"]) {
        string = [@"http:" stringByAppendingString: string];
      }
      else if (![string hasPrefix: @"http"]) {
        NSString *baseURLString = 
          [[OnMyBlockAPIURL componentsSeparatedByString: 
            OnMyBlockAPI] objectAtIndex: 0];
        string = [NSString stringWithFormat: @"%@%@", baseURLString, string];
      }
      OMBResidenceImageDownloader *downloader = 
       [[OMBResidenceImageDownloader alloc] initWithResidence: residence];
      downloader.completionBlock = ^(NSError *error) {
        // When the download is complete, set the image for the image view
        UIImage *image = [residence.images objectForKey: 
          [NSString stringWithFormat: @"%i", position]];
        imageView.image = [UIImage image: image sizeToFitVertical: size];
        // Update the number of pages for the images scroll view
        viewController.pageOfImagesLabel.text = [NSString stringWithFormat:
          @"%i/%i", [viewController currentPageOfImages], 
            (int) [[residence imagesArray] count]];
        [super connectionDidFinishLoading: connection];
      };
      downloader.imageURL = [NSURL URLWithString: string];
      downloader.position = position;
      [downloader startDownload];
    }
    [viewController addImageViewsToImageScrollView];
  }
  [super connectionDidFinishLoading: connection];
}

@end
