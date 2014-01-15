//
//  OMBResidenceDetailMapCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailMapCell.h"

@implementation OMBResidenceDetailMapCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.titleLabel.text = @"Map";

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = 20.0f;

  _mapView          = [[MKMapView alloc] init];
  _mapView.frame    = CGRectMake(padding, 44.0f + padding,
    screenWidth - (padding * 2), screenWidth * 0.5);
  _mapView.mapType       = MKMapTypeStandard;
  _mapView.rotateEnabled = NO;
  _mapView.scrollEnabled = NO;
  _mapView.showsPointsOfInterest = NO;
  _mapView.zoomEnabled   = NO;
  [self.contentView addSubview: _mapView];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell
{
  CGRect screen = [[UIScreen mainScreen] bounds];

  return 44.0f + 20.0f + (screen.size.width * 0.5f) + 20.0f;
}

#pragma mark - Instance Methods

// - (void) setMapView: (MKMapView *) map
// {
//   [self.contentView.subviews enumerateObjectsUsingBlock:
//     ^(id obj, NSUInteger idx, BOOL *stop) {
//       if ([obj isKindOfClass: [MKMapView class]]) {
//         [(UIView *) obj removeFromSuperview];
//       }
//     }
//   ];
//   [self.contentView addSubview: map];
// }

@end
