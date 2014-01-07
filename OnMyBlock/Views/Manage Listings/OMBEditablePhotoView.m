//
//  OMBEditablePhotoView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBEditablePhotoView.h"

#import "UIImage+Resize.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBEditablePhotoView

#pragma mark - Initializer

- (id) init
{
  if (!(self = [self initWithFrame: CGRectZero])) return nil;
  
  return self;
}


- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  _deleteButtonView = [UIImageView new];
  _deleteButtonView.alpha = 0.0f;
  _deleteButtonView.backgroundColor = [UIColor colorWithWhite: 0.0f 
    alpha: 0.8f];
  _deleteButtonView.layer.borderColor = [UIColor whiteColor].CGColor;
  _deleteButtonView.layer.borderWidth = 1.0f;
  [self addSubview: _deleteButtonView];

  backSlash = [UIView new];
  backSlash.backgroundColor = [UIColor whiteColor];
  [_deleteButtonView addSubview: backSlash];

  forwardSlash = [UIView new];
  forwardSlash.backgroundColor = backSlash.backgroundColor;  
  [_deleteButtonView addSubview: forwardSlash];

  _deleteButton = [UIButton new];
  [self addSubview: _deleteButton];

  [self setFrame: rect];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setDeleteButtonFrames
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat imageHeight  = screenHeight * 0.15f;

  CGRect rect = self.frame;
  if (rect.size.height > imageHeight)
    rect.size.height = imageHeight;

  _deleteButtonView.frame = CGRectMake(0.0f, 0.0f, rect.size.height * 0.3,
    rect.size.height * 0.3);
  _deleteButtonView.layer.cornerRadius = 
    _deleteButtonView.frame.size.width * 0.5f;

  backSlash.transform = CGAffineTransformIdentity;
  forwardSlash.transform = CGAffineTransformIdentity;
  CGFloat slashHeight = _deleteButtonView.frame.size.height * 0.5f;
  CGFloat slashWidth  = 3.0f;
  backSlash.frame = CGRectMake(
    (_deleteButtonView.frame.size.width - slashWidth) * 0.5f, 
      (_deleteButtonView.frame.size.height - slashHeight) * 0.5f, 
        slashWidth, slashHeight);
  forwardSlash.frame = backSlash.frame;
  backSlash.transform = 
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
  forwardSlash.transform = 
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45));

  _deleteButton.frame = _deleteButtonView.frame;
}

- (void) setFrame: (CGRect) rect
{
  [super setFrame: rect];

  [self setDeleteButtonFrames];
}

@end
