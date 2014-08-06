//
//  QVCoordinateQuadTree.m
//  MapCluster
//
//  Created by Tommy DANGerous on 4/14/14.
//  Copyright (c) 2014 Quantum Ventures. All rights reserved.
//

#import "QVCoordinateQuadTree.h"

#import "OMBResidence.h"
#import "QVClusterAnnotation.h"

typedef struct QVHotelInfo {
  char *hotelName;
  char *hotelPhoneNumber;
} QVHotelInfo;

typedef struct QVResidenceInfo {
  int  id;
  bool rented;
} QVResidenceInfo;

QVQuadTreeNodeData QVDataFromLine (NSString *line)
{
  // Example line:
  // -80.26262, 25.81015, Everglades Motel, USA-United States, +1 305-888-8797

  NSArray *components = [line componentsSeparatedByString: @","];
  double latitude     = [components[1] doubleValue];
  double longitude    = [components[0] doubleValue];

  QVHotelInfo *hotelInfo = malloc(sizeof(QVHotelInfo));

  NSString *hotelName = [components[2] stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  hotelInfo->hotelName = malloc(sizeof(char) * hotelName.length + 1);
  strncpy(hotelInfo->hotelName, [hotelName UTF8String], hotelName.length + 1);

  NSString *hotelPhoneNumber =
    [[components lastObject] stringByTrimmingCharactersInSet:
      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  hotelInfo->hotelPhoneNumber =
    malloc(sizeof(char) * hotelPhoneNumber.length + 1);
  strncpy(hotelInfo->hotelPhoneNumber, [hotelPhoneNumber UTF8String],
    hotelPhoneNumber.length + 1);

  return QVQuadTreeNodeDataMake(latitude, longitude, hotelInfo);
}

QVQuadTreeNodeData QVDataFromResidence (OMBResidence *residence)
{
  // NSDictionary *dict = @{
  //   @"id": @(residence.uid)
  // };
  QVResidenceInfo *residenceInfo = malloc(sizeof(QVResidenceInfo));
  residenceInfo->id     = residence.uid;
  residenceInfo->rented = (residence.rented ? YES : NO);
  
  return QVQuadTreeNodeDataMake(residence.latitude, residence.longitude, residenceInfo);
}

QVBoundingBox QVBoundingBoxForMapRect (MKMapRect mapRect)
{
  CLLocationCoordinate2D topLeft  = MKCoordinateForMapPoint(mapRect.origin);
  CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(
    MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));

  CLLocationDegrees minLat = botRight.latitude;
  CLLocationDegrees maxLat = topLeft.latitude;

  CLLocationDegrees minLon = topLeft.longitude;
  CLLocationDegrees maxLon = botRight.longitude;

  return QVBoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

MKMapRect QVMapRectForBoundingBox (QVBoundingBox boundingBox)
{
  MKMapPoint topLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
    boundingBox.x0, boundingBox.y0));
  MKMapPoint botRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
    boundingBox.xf, boundingBox.yf));

  return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x),
    fabs(botRight.y - topLeft.y));
}

NSInteger QVZoomScaleToZoomLevel (MKZoomScale scale)
{
  // Change the clustering grid based on how zoomed in we are on the map.
  // We want to cluster smaller cells the closer we are.
  // To do this we define the current zoom of our map,
  // where scale = mapView.bounds.size.width / mapView.visibleMapRect.size.width
  double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
  NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
  NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2(scale) + 0.5));

  return zoomLevel;
}

float QVCellSizeForZoomScale (MKZoomScale zoomScale)
{
  NSInteger zoomLevel = QVZoomScaleToZoomLevel(zoomScale);

  switch (zoomLevel) {
    case 13:
    case 14:
    case 15:
      return 64;
    case 16:
    case 17:
    case 18:
      return 32;
    case 19:
      return 16;
    default:
      return 88;
  }
}

@implementation QVCoordinateQuadTree

- (void) buildTree
{
  NSString *data = [NSString stringWithContentsOfFile:
    [[NSBundle mainBundle] pathForResource: @"USA-HotelMotel" ofType: @"csv"]
      encoding: NSASCIIStringEncoding error: nil];
  NSArray *lines = [data componentsSeparatedByString: @"\n"];

  NSInteger count = lines.count - 1;

  QVQuadTreeNodeData *dataArray = malloc(sizeof(QVQuadTreeNodeData) * count);
  for (NSInteger i = 0; i < count; i++) {
    dataArray[i] = QVDataFromLine(lines[i]);
  }

  QVBoundingBox world = QVBoundingBoxMake(19, -166, 72, -53);
  _root = QVQuadTreeBuildWithData(dataArray, count, world, 4);
}

- (void) buildTreeWithResidences: (NSArray *) array
{
  NSInteger count = array.count - 1;

  QVQuadTreeNodeData *dataArray = malloc(sizeof(QVQuadTreeNodeData) * count);
  for (NSInteger i = 0; i < count; i++) {
    dataArray[i] = QVDataFromResidence(array[i]);
  }

  QVBoundingBox world = QVBoundingBoxMake(19, -166, 72, -53);
  _root = QVQuadTreeBuildWithData(dataArray, count, world, 4);
}

- (NSArray *) clusteredAnnotationsWithinMapRect: (MKMapRect) rect
withZoomScale: (double) zoomScale
{
  // This will make clustered annotations for us for a defined cell size
  double QVCellSize  = QVCellSizeForZoomScale(zoomScale);
  double scaleFactor = zoomScale / QVCellSize;

  NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
  NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
  NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
  NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);

  NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];

  for (NSInteger x = minX; x <= maxX; x++) {
    for (NSInteger y = minY; y <= maxY; y++) {
      MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor,
        1.0 / scaleFactor, 1.0 / scaleFactor);

      __block double totalX = 0;
      __block double totalY = 0;
      __block int count     = 0;
      __block bool rented   = false;
      __block int residenceId = 0;

      NSMutableArray *array = [NSMutableArray array];

      QVQuadTreeGatherDataInRange(self.root, QVBoundingBoxForMapRect(mapRect),
        ^(QVQuadTreeNodeData data) {
          totalX += data.x;
          totalY += data.y;
          rented  = ((struct QVResidenceInfo *)data.data)->rented;
          residenceId = ((struct QVResidenceInfo *)data.data)->id;
          
          count++;
          [array addObject: @{
            @"latitude": @(data.x),
            @"longitude": @(data.y)
          }];
        });

      if (count >= 1) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
          totalX / count, totalY / count);
        QVClusterAnnotation *annotation =
          [[QVClusterAnnotation alloc] initWithCoordinate: coordinate
            count: count coordinates: [NSArray arrayWithArray: array]];
        annotation.rented      = (count == 1 ? rented : NO);
        annotation.residenceId = (count == 1 ? residenceId : 0);
        [clusteredAnnotations addObject: annotation];
      }
    }
  }

  return [NSArray arrayWithArray: clusteredAnnotations];
}

@end
