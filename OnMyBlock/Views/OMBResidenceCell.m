//
//  OMBResidenceCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceCell.h"

#import "OMBResidence.h"
#import "OMBResidenceCoverPhotoURLConnection.h"
#import "UIImage+Resize.h"

@implementation OMBResidenceCell

@synthesize residence = _residence;

- (id) initWithStyle: (UITableViewCellStyle) style  
reuseIdentifier: (NSString *) reuseIdentifier
{
  self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
  if (self) {
    CGRect screen = [[UIScreen mainScreen] bounds];
    // Main view
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor blackColor];
    mainView.frame = CGRectMake(0, 0, screen.size.width, 
      (screen.size.height * 0.3));
    [self.contentView addSubview: mainView];

    // Address
    addressLabel = [[UILabel alloc] init];
    addressLabel.frame = CGRectMake(0, 0, 100, 100);

    // Image view
    imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds   = YES;
    imageView.contentMode     = UIViewContentModeTopLeft;
    imageView.frame = CGRectMake(0, 0, mainView.frame.size.width, 
      mainView.frame.size.height);
    [mainView addSubview: imageView];
  }
  return self;
}

- (void) setSelected: (BOOL) selected animated: (BOOL) animated
{
  [super setSelected: selected animated: animated];
  // Configure the view for the selected state
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidence: (OMBResidence *) object
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  _residence = object;
  // Image
  if (_residence.coverPhotoForCell)
    imageView.image = _residence.coverPhotoForCell;
  else {
    // Get _residence cover photo url
    OMBResidenceCoverPhotoURLConnection *connection = 
      [[OMBResidenceCoverPhotoURLConnection alloc] initWithResidence: 
        _residence];
    connection.completionBlock = ^(NSError *error) {
      _residence.coverPhotoForCell = [_residence coverPhotoWithSize: 
        CGSizeMake(screen.size.width, imageView.frame.size.height)];
      imageView.image = _residence.coverPhotoForCell;
    };
    [connection start];
  }
}

@end
