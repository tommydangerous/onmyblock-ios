//
//  OMBEditablePhotoView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBEditablePhotoView.h"

#import "OMBFinishListingPhotosViewController.h"
#import "UIImage+Resize.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBEditablePhotoView

#pragma mark - Initializer

- (id) init
{
  if (!(self = [self initWithFrame: CGRectZero])) return nil;

  moveRecognizer = 
    [[UIPanGestureRecognizer alloc] initWithTarget: self 
      action: @selector(moveObject:)];
  // This gesture will eat any touch it recognizes if set to YES
  moveRecognizer.cancelsTouchesInView = YES;
  moveRecognizer.delegate = self;
  [self addGestureRecognizer: moveRecognizer];

  // longPressRecognizer = 
  //   [[UILongPressGestureRecognizer alloc] initWithTarget: self 
  //     action: @selector(longPress:)];
  // longPressRecognizer.delegate = self;
  // longPressRecognizer.minimumPressDuration = 0.25f;
  // [self addGestureRecognizer: longPressRecognizer];
  
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
  _deleteButton.hidden = YES;
  [self addSubview: _deleteButton];

  [self setFrame: rect];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer: (UIGestureRecognizer *) gestureRecognizer 
shouldRecognizeSimultaneouslyWithGestureRecognizer: 
(UIGestureRecognizer *) otherGestureRecognizer
{
  if (_isEditing)
    return NO;
  return YES;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) checkCurrentPosition
{
  // Create grid
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  // CGFloat screenWidth  = screen.size.width;
  CGFloat maxColumns   = 3.0f;
  CGFloat coverPhotoHeight = screenHeight * 0.4f;
  // CGFloat spacing      = 3.0f;
  // CGFloat imageHeight  = screenHeight * 0.15f;
  // CGFloat imageWidth   = (screenWidth / maxColumns) - 
  //   ((spacing * 2) / maxColumns);
  int index = _currentIndex;

  CGRect boundaries = CGRectZero;
  // Cover photo
  if (index == 0) {
    boundaries = CGRectMake(0.0f, 0.0f, _largeSize.width, _largeSize.height);
  }
  // Every other photo
  else {
    // Example: first image that is not the cover photo (index = 1)
    // row = 0
    // column = 0
    int row = (index - 1) / 3;
    int column = (index - 1) % 3;
    boundaries = CGRectMake(_smallSize.width * column, 
      coverPhotoHeight + (_smallSize.height * row), 
        _smallSize.width, _smallSize.height);
  }
  CGPoint centerPoint = CGPointMake(
    self.frame.origin.x + (self.frame.size.width * 0.5f),
      self.frame.origin.y + (self.frame.size.height * 0.5f));
  // If center left it's boundaries, reposition things
  if (centerPoint.x > boundaries.origin.x + boundaries.size.width ||
    centerPoint.x < boundaries.origin.x ||
    centerPoint.y > boundaries.origin.y + boundaries.size.height ||
    centerPoint.y < boundaries.origin.y) {
    // Calculate which grid it is in to find the new index
    CGFloat newColumn = centerPoint.x / _smallSize.width;
    CGFloat newRow    = (centerPoint.y - coverPhotoHeight) / _smallSize.height;
    // Moved into the boundaries of the cover photo
    if (newRow < 0) {
      _currentIndex = 0;
    }
    else {
      NSInteger maxIndex = [(OMBFinishListingPhotosViewController *) 
        _delegate numberOfImageViews] - 1;
      _currentIndex = 1 + (int) newColumn + ((int) newRow * maxColumns);
      if (_currentIndex > maxIndex) {
        _currentIndex = maxIndex;
      }
    }
    [(OMBFinishListingPhotosViewController *) 
      _delegate rearrangeImageViewsWithImageView: self];
  }
}

- (void) longPress: (UILongPressGestureRecognizer *) gestureRecognizer
{
  if (!_isEditing)
    return;
}

- (void) moveObject: (UIPanGestureRecognizer *) gestureRecognizer
{
  // If we haven't selected a line, we don't do anything here
  // if (![self selectedLine]) {
  //   return;
  // }

  if (!_isEditing)
    return;

  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    // If this image view is the large one
    if (CGSizeEqualToSize(self.frame.size, _largeSize)) {
      CGPoint startTouchPoint = [gestureRecognizer locationInView: 
        [self superview]];
      CGFloat newX = startTouchPoint.x - (_smallSize.width * 0.5f);
      CGFloat newY = startTouchPoint.y - (_smallSize.height * 0.5f);
      [UIView animateWithDuration: 0.25f animations: ^{
        self.frame = CGRectMake(newX, newY,
          _smallSize.width, _smallSize.height);
      }];
    }
    // If this is the small size
    else if (CGSizeEqualToSize(self.frame.size, _smallSize)) {
      // No need to scale down
    }
    // Bring this view to the front
    [[self superview] bringSubviewToFront: self];
  }
  // When the pan recognizer changes its position...
  else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
    // How far has the pan moved?
    CGPoint translation = [gestureRecognizer translationInView: self];

    CGPoint newPoint = self.frame.origin;
    newPoint.x += translation.x;
    newPoint.y += translation.y;

    self.transform = CGAffineTransformTranslate(self.transform,
      translation.x, translation.y);

    // self.frame = CGRectMake(newPoint.x, newPoint.y, self.frame.size.width,
    //   self.frame.size.height);

    // NSLog(@"%f, %f", translation.x, translation.y);

    // Redraw the screen
    // [self setNeedsDisplay];

    // Reset translation point so it doesn't keep compounding
    [gestureRecognizer setTranslation: CGPointZero inView: self];

    [self checkCurrentPosition];
  }
  else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
    gestureRecognizer.state == UIGestureRecognizerStateCancelled ||
    gestureRecognizer.state == UIGestureRecognizerStateFailed) {

    // This is the cover photo, make it larger
    if (_currentIndex == 0) {
      [UIView animateWithDuration: 0.25f animations: ^{
        self.frame = CGRectMake(0.0f, 0.0f,
          _largeSize.width, _largeSize.height);
      }];
    }
    else {
      [self checkCurrentPosition];
      [self resetToSmallSize];
    }
  }
}

- (void) resetToSmallSize
{
  CGFloat spacing      = 3.0f;

  int row    = (_currentIndex - 1) / 3;
  int column = (_currentIndex - 1) % 3;
  CGRect rect = CGRectMake((spacing + _smallSize.width) * column,
    _largeSize.height + spacing + ((spacing + _smallSize.height) * row),
      _smallSize.width, _smallSize.height);
  [UIView animateWithDuration: 0.25f animations: ^{
    self.frame = rect;
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.x,
      rect.size.width, rect.size.height);
  }];
}

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
