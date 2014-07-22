//
//  QVClusterAnnotationView.m
//  MapCluster
//
//  Created by Tommy DANGerous on 4/14/14.
//  Copyright (c) 2014 Quantum Ventures. All rights reserved.
//

#import "QVClusterAnnotationView.h"

#import "QVClusterAnnotation.h"
#import "OMBViewController.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

CGPoint QVRectCenter (CGRect rect)
{
  return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect QVCenterRect (CGRect rect, CGPoint center)
{
  CGRect r = CGRectMake(center.x - rect.size.width / 2.0,
    center.y - rect.size.height / 2.0,
      rect.size.width, rect.size.height);

  return r;
}

static CGFloat const QVScaleFactorAlpha = 0.3;
static CGFloat const QVScaleFactorBeta  = 0.4;

CGFloat QVScaledFactorForValue (CGFloat value)
{
  return 1.0f / (1.0 + expf(-1 * QVScaleFactorAlpha * powf(value,
    QVScaleFactorBeta)));
}

@interface QVClusterAnnotationView ()

@property (strong, nonatomic) UILabel *countLabel;

@end

@implementation QVClusterAnnotationView

#pragma mark - Initializer

- (id) initWithAnnotation: (id <MKAnnotation>) annotation
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithAnnotation: annotation
    reuseIdentifier: reuseIdentifier])) return nil;

  self.backgroundColor = [UIColor clearColor];
  self.canShowCallout  = NO;
  [self setupLabel];
  [self setCount: 1];

  if ([annotation isKindOfClass: [QVClusterAnnotation class]]) {
    QVClusterAnnotation *clusterAnnotation = (QVClusterAnnotation *)
      annotation;
    clusterAnnotation.annotationView = self;
  }

  return self;
}

#pragma mark - Override

#pragma mark - Override UIView

- (void) drawRect: (CGRect) rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetAllowsAntialiasing(context, true);

  UIColor *outerCircleStrokeColor = [UIColor colorWithWhite: 0 alpha: 0.3f];
  // UIColor *innerCircleStrokeColor = [UIColor colorWithWhite: 0 alpha: 0.3f];
  UIColor *innerCircleFillColor = [UIColor blue];
  if(_isRented){ //  && _count == 1
    innerCircleFillColor = [UIColor grayMedium];
  }
  if (self.isSelected)
    innerCircleFillColor = [UIColor grayDark];

  CGRect circleFrame = CGRectInset(rect, 4, 4);

  [outerCircleStrokeColor setStroke];
  CGContextSetLineWidth(context, 8.0);
  CGContextStrokeEllipseInRect(context, circleFrame);

  // [innerCircleStrokeColor setStroke];
  // CGContextSetLineWidth(context, 4);
  // CGContextStrokeEllipseInRect(context, circleFrame);

  [innerCircleFillColor setFill];
  CGContextFillEllipseInRect(context, circleFrame);
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) deselect
{
  self.isSelected = NO;
  [self setNeedsDisplay];
  // [UIView animateWithDuration: OMBStandardDuration * 0.3f animations: ^{
  //   self.transform = CGAffineTransformIdentity;
  // }];
}

- (void) select
{
  self.isSelected = YES;
  [self setNeedsDisplay];
  [UIView animateWithDuration: OMBStandardDuration * 0.3f animations: ^{
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity,
      1.1f, 1.1f);
  } completion: ^(BOOL finished) {
    if (finished) {
      [UIView animateWithDuration: OMBStandardDuration * 0.3f animations: ^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity,
          0.9f, 0.9f);
      } completion: ^(BOOL finished) {
        if (finished) {
          [UIView animateWithDuration: OMBStandardDuration * 0.3f animations: ^{
            self.transform = CGAffineTransformIdentity;
          }];
        }
      }];
    }
  }];
}

- (void) setCount: (NSUInteger) count
{
  _count = count;

  CGFloat maxSize = 60.0f;
  // Our max size is (44,44)
  CGRect newBounds = CGRectMake(0, 0,
    roundf(maxSize * QVScaledFactorForValue(count)),
      roundf(maxSize * QVScaledFactorForValue(count)));
  self.frame = QVCenterRect(newBounds, self.center);

  CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3,
    newBounds.size.height / 1.3);
  self.countLabel.frame = QVCenterRect(newLabelBounds, QVRectCenter(newBounds));
  self.countLabel.text  = [@(_count) stringValue];

  [self setNeedsDisplay];
}

- (void) setupLabel
{
  _countLabel = [[UILabel alloc] initWithFrame: self.frame];
  _countLabel.adjustsFontSizeToFitWidth = YES;
  _countLabel.backgroundColor = [UIColor clearColor];
  _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  // _countLabel.font = [UIFont boldSystemFontOfSize: 12];
  _countLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 14];
  _countLabel.numberOfLines = 1;
  // _countLabel.shadowColor = [UIColor colorWithWhite: 0.0f alpha: 0.75f];
  // _countLabel.shadowOffset = CGSizeMake(0, -1);
  _countLabel.textAlignment = NSTextAlignmentCenter;
  _countLabel.textColor = [UIColor whiteColor];
  [self addSubview: _countLabel];
}

@end
