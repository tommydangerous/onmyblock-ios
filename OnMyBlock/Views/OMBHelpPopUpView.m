//
//  OMBHelpPopUpView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/12/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHelpPopUpView.h"

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

  self.backgroundColor = [UIColor blueLightAlpha: 0.95f];

  CGFloat buttonSize = self.frame.size.height * 0.5f;
  CGFloat spacing = (self.frame.size.height - buttonSize) * 0.5f;
  closeButtonView = [[OMBCloseButtonView alloc] initWithFrame:
    CGRectMake(self.frame.size.width - (buttonSize + spacing), 
      spacing, buttonSize, buttonSize) 
        color: [UIColor textColor]];
  [self addSubview: closeButtonView];

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

@end
