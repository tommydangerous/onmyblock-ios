//
//  OMBResidenceDetailMapCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/17/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceDetailMapCell.h"

#import "OMBViewController.h"

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
  CGFloat padding      = OMBPadding;

  _segmentedControl = [[UISegmentedControl alloc] initWithItems:
                     @[@"Map", @"Street"]];
  _segmentedControl.selectedSegmentIndex = 0;
  CGRect segmentedFrame = CGRectMake( (screenWidth - _segmentedControl.frame.size.width) / 2, 44.0f + padding / 2,
                                     _segmentedControl.frame.size.width, _segmentedControl.frame.size.height);
  _segmentedControl.frame = segmentedFrame;
  _segmentedControl.tintColor = [UIColor blue];
  [self.contentView addSubview:_segmentedControl];

  // _mapView          = [[MKMapView alloc] init];
  // _mapView.frame    = CGRectMake(padding, 44.0f + padding + 29.0f,
  //                                screenWidth - (padding * 2), screenWidth * 0.5);
  // _mapView.mapType       = MKMapTypeStandard;
  // _mapView.rotateEnabled = NO;
  // _mapView.scrollEnabled = NO;
  // _mapView.showsPointsOfInterest = NO;
  // _mapView.zoomEnabled   = NO;
  // _mapView.hidden = NO;
  // [self.contentView addSubview: _mapView];
  
  _streetView = [[UIImageView alloc] init];
  _streetView.frame = [OMBResidenceDetailMapCell frameForMapView];
  _streetView.hidden = YES;
  [self.contentView addSubview: _streetView];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGRect) frameForMapView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = OMBPadding;
  return CGRectMake(padding, 44.0f + padding + 29.0f,
    screenWidth - (padding * 2), screenWidth * 0.5);
}

+ (CGFloat) heightForCell
{
  CGRect screen = [[UIScreen mainScreen] bounds];

  return 44.0f + 20.0f + 29.0f + (screen.size.width * 0.5f) + 20.0f;
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
