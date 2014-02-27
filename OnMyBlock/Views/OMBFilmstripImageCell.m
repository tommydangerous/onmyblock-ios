//
//  OMBFilmstripImageCell.m
//  OnMyBlock
//
//  Created by Peter Meyers on 1/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFilmstripImageCell.h"

@implementation OMBFilmstripImageCell

#pragma mark - Initialzer

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  _imageView = [[UIImageView alloc] initWithFrame: self.bounds];
  _imageView.clipsToBounds = YES;
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  [self addSubview: _imageView];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSString *) reuseID
{
	return NSStringFromClass([self class]);
}

@end
