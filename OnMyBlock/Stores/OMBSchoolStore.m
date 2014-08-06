//
//  OMBSchoolStore.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBSchoolStore.h"

#import "OMBSchool.h"

@implementation OMBSchoolStore

#pragma mark - Initializer

- (id)init
{
  if(!(self = [super init]))
    return nil;
  
  schools = [NSMutableArray array];
  
  // Grossmont College
  OMBSchool *gross  = [OMBSchool new];
  gross.coordinate  = CLLocationCoordinate2DMake(32.8163, -117.0063);
  gross.displayName = @"Grossmont College";
  [schools addObject:gross];
  
  // Mesa College
  OMBSchool *mesa  = [OMBSchool new];
  mesa.coordinate  = CLLocationCoordinate2DMake(32.8044, -117.1703);
  mesa.displayName = @"Mesa College";
  mesa.realName    = @"San Diego Mesa College";
  [schools addObject:mesa];
  
  // MiraCosta College
  OMBSchool *miraCos  = [OMBSchool new];
  miraCos.coordinate  = CLLocationCoordinate2DMake(33.1906, -117.3013);
  miraCos.displayName = @"MiraCosta College";
  [schools addObject:miraCos];
  
  // Miramar College
  OMBSchool *miraMar  = [OMBSchool new];
  miraMar.coordinate  = CLLocationCoordinate2DMake(32.9071, -117.1208);
  miraMar.displayName = @"Miramar College";
  miraMar.realName    = @"San Diego Miramar College";
  [schools addObject:miraMar];
  
  // Palomar College
  OMBSchool *palo  = [OMBSchool new];
  palo.coordinate  = CLLocationCoordinate2DMake(33.1494, -117.1848);
  palo.displayName = @"Palomar College";
  [schools addObject:palo];
  
  // Pt. Loma University
  OMBSchool *loma  = [OMBSchool new];
  loma.coordinate  = CLLocationCoordinate2DMake(32.7169, -117.2507);
  loma.displayName = @"Pt. Loma University";
  loma.realName    = @"Point Loma Nazarene University";
  [schools addObject:loma];
  
  // San Diego City College
  OMBSchool *sdiegoCC  = [OMBSchool new];
  sdiegoCC.coordinate  = CLLocationCoordinate2DMake(32.7174, -117.1526);
  sdiegoCC.displayName = @"San Diego City College";
  [schools addObject:sdiegoCC];
  
  // San Diego State University
  OMBSchool *sdiegoSU  = [OMBSchool new];
  sdiegoSU.coordinate  = CLLocationCoordinate2DMake(32.775619, -117.0713348);
  sdiegoSU.displayName = @"San Diego State University";
  [schools addObject:sdiegoSU];
  
  // UC San Diego
  OMBSchool *ucSDiego  = [OMBSchool new];
  ucSDiego.coordinate  = CLLocationCoordinate2DMake(32.8754964, -117.2383261);
  ucSDiego.displayName = @"UC San Diego";
  ucSDiego.realName    = @"University of California, San Diego";
  [schools addObject:ucSDiego];
  
  // University of San Diego
  OMBSchool *univSDiego  = [OMBSchool new];
  univSDiego.coordinate  = CLLocationCoordinate2DMake(32.7719839, -117.187294);
  univSDiego.displayName = @"University of San Diego";
  [schools addObject:univSDiego];
  
  //---------------------------------------------------------------
  
  // Cal Poly SLO
  OMBSchool *calPoly  = [OMBSchool new];
  calPoly.coordinate  = CLLocationCoordinate2DMake(35.3017, -120.6598);
  calPoly.displayName = @"Cal Poly SLO";
  calPoly.realName    = @"California Polytechnic State University";
  [schools addObject:calPoly];
  
  // Cuesta College
  OMBSchool *cuesta  = [OMBSchool new];
  cuesta.coordinate  = CLLocationCoordinate2DMake(35.3300, -120.7424);
  cuesta.displayName = @"Cuesta College";
  [schools addObject:cuesta];
  
  //---------------------------------------------------------------
  
  OMBSchool *none   = [OMBSchool new];
  none.coordinate   = CLLocationCoordinate2DMake(0.0, 0.0);
  none.displayName  = @"None";
  none.realName     = @"";
  [schools addObject:none];
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBSchoolStore *) sharedStore
{
  static OMBSchoolStore *store = nil;
  if (!store)
    store = [[OMBSchoolStore alloc] init];
  return store;
}

#pragma mark - Instance Methods

- (NSArray *) schools
{
  
  // for now
  return schools;
}

@end
