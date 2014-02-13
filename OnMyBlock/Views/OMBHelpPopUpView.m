//
//  OMBHelpPopUpView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/12/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHelpPopUpView.h"

#import "NSString+Extensions.h"
#import "OMBCloseButtonView.h"
#import "OMBViewController.h"
#import "UIColor+Extensions.h"

@implementation OMBHelpPopUpView

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame 
backgroundColor: (UIColor *) color 
andTransparentRects: (NSArray *) rects
{
  if (!(self = [super initWithFrame: frame])) return nil;
  
  backgroundColor = color;
  rectsArray      = rects;
  
  self.opaque = NO;

  return self;
}

- (id) initWithFrame: (CGRect) rect
{
  if (!(self = [super initWithFrame: rect])) return nil;

  CGFloat padding = OMBPadding;

  self.backgroundColor = [UIColor blueAlpha: 0.95f];

  CGFloat buttonSize = self.frame.size.height * 0.3f;
  CGFloat spacing = (self.frame.size.height - buttonSize) * 0.5f;
  closeButtonView = [[OMBCloseButtonView alloc] initWithFrame:
    CGRectMake(self.frame.size.width - (buttonSize + padding), 
      spacing, buttonSize, buttonSize) 
        color: [UIColor colorWithWhite: 1.0f alpha: 0.5f]];
  [self addSubview: closeButtonView];

  _label = [UILabel new];
  _label.font = [UIFont mediumTextFont];
  // The 27.0f * 0.1f is to move it a bit higher to make up for the line height
  _label.frame = CGRectMake(padding, 27.0f * -0.1f, 
    self.frame.size.width - (padding + buttonSize + padding), 
      self.frame.size.height);
  _label.numberOfLines = 0;
  _label.textColor = [UIColor whiteColor];
  [self addSubview: _label];

  _button = [UIButton new];
  _button.frame = self.bounds;
  [self addSubview: _button];

  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// - (void)drawRect:(CGRect)rect
// {
//     // Drawing code
//     [backgroundColor setFill];
//     UIRectFill(rect);

//     // clear the background in the given rectangles
//     for (NSValue *holeRectValue in rectsArray) {
//         CGRect holeRect = [holeRectValue CGRectValue];
//         CGRect holeRectIntersection = CGRectIntersection( holeRect, rect );
//         [[UIColor clearColor] setFill];
//         UIRectFill(holeRectIntersection);
//     }

// }

- (void) setLabelText: (NSString *) string
{
  _label.attributedText = [string attributedStringWithFont: _label.font
    lineHeight: 27.0f];
}

@end
