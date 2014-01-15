//
//  OMBResidence.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidence.h"

#import "NSString+Extensions.h"
#import "OMBOffer.h"
#import "OMBOpenHouse.h"
#import "OMBResidenceGoogleStaticImageDownloader.h"
#import "OMBResidenceImage.h"
#import "OMBUser.h"
#import "OMBUserStore.h"
#import "UIImage+Resize.h"

@implementation OMBResidence

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _amenities = [NSMutableDictionary dictionary];
  for (NSString *string in [OMBResidence defaultListOfAmenities]) {
    [_amenities setObject: [NSNumber numberWithInt: 0] forKey: string];
  }
  
  _images              = [NSMutableArray array];
  _imageSizeDictionary = [NSMutableDictionary dictionary];
  _lastImagePosition   = 1000;
  _offers              = [NSMutableArray array];
  _openHouseDates      = [NSMutableArray array];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (NSArray *) defaultListOfAmenities
{
  return @[
    @"air conditioning",
    @"backyard",
    @"central heating",
    @"dishwasher",
    @"fence",
    @"front yard",
    @"garbage disposal",
    @"gym",
    @"hard floors",
    @"newly remodeled",
    @"patio/balcony",
    @"pool",
    @"storage",
    @"washer/dryer" 
  ];
}

+ (OMBResidence *) fakeResidence
{
  static OMBResidence *residence = nil;
  if (!residence) {
    residence = [[OMBResidence alloc] init];
    residence.address = @"2546 Minas Morgul Way";
    residence.availableOn = [[NSDate date] timeIntervalSince1970];
    residence.bathrooms = 2.0f;
    residence.bedrooms = 3.0f;
    residence.city = @"Gondor";
    residence.createdAt = [[NSDate date] timeIntervalSince1970];
    residence.description = @"The best place to not suffer.";
    residence.email = @"witch_king@gmail.com";
    residence.landlordName = @"Nazgul Smith";
    residence.latitude = -32;
    residence.leaseMonths = 12;
    residence.longitude = 113;
    residence.minRent = 1750.00;
    residence.phone = @"8581234567";
    residence.propertyType = @"sublet";
    residence.squareFeet = 900;
    residence.state = @"CA";
    residence.title = @"Best College Pad Ever";
    residence.uid = 9999;
    residence.updatedAt = [[NSDate date] timeIntervalSince1970];
    residence.zip = @"92122";

    OMBResidenceImage *image = [[OMBResidenceImage alloc] init];
    image.absoluteString = @"fake_image.jpg";
    image.image = [UIImage imageNamed: @"residence_fake.jpg"];
    image.position = 1;
    [residence.images addObject: image];
  }
  return residence;
}

#pragma mark Instance Methods

- (void) addImage: (UIImage *) image atPosition: (int) position 
withString: (NSString *) string
{
  // Check to see if an image with string already exists
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %@", @"absoluteString", string];
  NSArray *array = [_images filteredArrayUsingPredicate: predicate];
  if ([array count] == 0) {
    OMBResidenceImage *residenceImage = [[OMBResidenceImage alloc] init];
    residenceImage.absoluteString     = string;
    residenceImage.image              = image;
    residenceImage.position           = position;
    [_images addObject: residenceImage];
  }
}

- (void) addOffer: (OMBOffer *) offer
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"uid", offer.uid];
  if ([[_offers filteredArrayUsingPredicate: predicate] count] == 0)
    [_offers addObject: offer];
}

- (void) addOpenHouse: (OMBOpenHouse *) openHouse
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
    @"uid", openHouse.uid];
  if ([[_openHouseDates filteredArrayUsingPredicate: predicate] count] == 0)
    [_openHouseDates addObject: openHouse];
}

- (void) addResidenceImage: (OMBResidenceImage *) residenceImage
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"uid", residenceImage.uid];
  if ([[_images filteredArrayUsingPredicate: predicate] count] == 0) {
    [_images addObject: residenceImage];
  }
}

- (NSArray *) availableAmenities
{
  NSMutableArray *array = [NSMutableArray array];
  for (NSString *string in [_amenities allKeys]) {
    NSNumber *number = [_amenities objectForKey: string];
    if ([number intValue])
      [array addObject: string];
  }
  // keys = [keys sortedArrayUsingComparator: ^(id obj1, id obj2) {
  //   int key1 = [(NSString *) obj1 intValue];
  //   int key2 = [(NSString *) obj2 intValue];
  //   if (key1 > key2)
  //     return (NSComparisonResult) NSOrderedDescending;
  //   if (key1 < key2)
  //     return (NSComparisonResult) NSOrderedAscending;
  //   return (NSComparisonResult) NSOrderedSame;
  // }];
  // NSMutableArray *array = [NSMutableArray array];
  // for (NSString *key in keys) {
  //   [array addObject: [_images objectForKey: key]];
  // }
  // return array;

  return (NSArray *) [array sortedArrayUsingComparator: ^(id obj1, id obj2) {
    if (obj1 > obj2)
      return (NSComparisonResult) NSOrderedDescending;
    if (obj1 < obj2)
      return (NSComparisonResult) NSOrderedAscending;
    return (NSComparisonResult) NSOrderedSame;
  }];
}

- (NSString *) availableOnString
{
  if (_availableOn) {
    if (_availableOn > [[NSDate date] timeIntervalSince1970]) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.dateFormat       = @"MMMM d, yyyy";
      return [dateFormatter stringFromDate: 
        [NSDate dateWithTimeIntervalSince1970: _availableOn]];
    }
    else
      return @"Immediately";
  }
  return @"Soon";
}

- (UIImage *) coverPhoto
{
  if ([_images count] > 0) {
    OMBResidenceImage *residenceImage = [[self imagesArray] objectAtIndex: 0];
    return residenceImage.image;
  }
  return nil;
}

- (UIImage *) coverPhotoWithSize: (CGSize) size
{
  UIImage *img = [self coverPhoto];
  CGFloat newHeight = size.height;
  CGFloat newWidth  = img.size.width * (size.height / img.size.height);
  if (newWidth < size.width) {
    newHeight = newHeight * (size.width / newWidth);
    newWidth  = size.width;
  }
  CGPoint point = CGPointZero;
  // Center it vertically
  if (newHeight > size.height) {
    point.y = (newHeight - size.height) * -0.5;
  }
  // Center it horizontally
  if (newWidth > size.width) {
    point.x = (newWidth - size.width) * -0.5;
  }
  return [UIImage image: img size: CGSizeMake(newWidth, newHeight)
    point: point];
}

- (UIImage *) coverPhotoWithSize1: (CGSize) size
{
  UIImage *img = [self coverPhoto];
  float newHeight, newWidth;
  if (img.size.width < img.size.height) {
    newHeight = size.height;
    newWidth  = (newHeight / img.size.height) * img.size.width;
  }
  else {
    newWidth  = size.width;
    newHeight = (newWidth / img.size.width) * img.size.height;
  }
  CGPoint point = CGPointMake(0, 0);
  // Center it horizontally
  if (newWidth > size.width)
    point.x = (newWidth - size.width) / -2.0;
  // Center it vertically
  if (newHeight > size.height)
    point.y = (newHeight - size.height) / -2.0;
  return [UIImage image: img size: CGSizeMake(newWidth, newHeight) 
    point: point];
}

- (NSString *) defaultContactMessage
{
  if ([OMBUser currentUser].accessToken)
    return [NSString stringWithFormat: @"Hello\n\nI found your listing for %@ using OnMyBlock.\nI am interested in this place and would love to schedule a viewing.\nYou can reach me at %@\n\nThank you.", 
      _address, [OMBUser currentUser].email];
  else
    return [NSString stringWithFormat: @"Hello\n\nI found your listing for %@ using OnMyBlock.\nI am interested in this place and would love to schedule a viewing.\nYou can reach me at ...\n\nThank you.", _address];
}

- (NSString *) dictionaryKey
{
  return [NSString stringWithFormat: @"%f,%f-%@", _latitude, _longitude,
    _address];
}

- (NSURL *) googleStaticMapImageURL
{
  NSString *base = @"https://maps.googleapis.com/maps/api/staticmap?";
  NSString *center = [NSString stringWithFormat: 
    @"%f,%f", _latitude, _longitude];
  NSString *markers = [NSString stringWithFormat:
    @"size:mid%%7Ccolor:0x1174d2%%7C%@", center];
  NSString *zoom = @"14";
  NSString *size = @"640x320";
  NSString *sensor = @"false";
  NSString *visualRefresh = @"true";
  NSDictionary *params = @{
    @"center":         center,
    @"markers":        markers,
    @"sensor":         sensor,
    @"size":           size,
    @"visual_refresh": visualRefresh,
    @"zoom":           zoom
  };
  NSString *paramsString = @"";
  for (NSString *key in [params allKeys]) {
    paramsString = [paramsString stringByAppendingString: 
      [NSString stringWithFormat: @"%@=%@&", key, [params objectForKey: key]]];
  }
  return [NSURL URLWithString: 
    [NSString stringWithFormat: @"%@%@", base, paramsString]];
}

- (NSURL *) googleStaticStreetViewImageURL
{
  NSString *base = @"http://maps.googleapis.com/maps/api/streetview?";
  NSString *location = [NSString stringWithFormat: 
    @"%f,%f", _latitude, _longitude];
  NSString *size = @"640x320";
  NSString *sensor = @"false";
  NSDictionary *params = @{
    @"location": location,
    @"sensor":   sensor,
    @"size":     size
  };
  NSString *paramsString = @"";
  for (NSString *key in [params allKeys]) {
    paramsString = [paramsString stringByAppendingString: 
      [NSString stringWithFormat: @"%@=%@&", key, [params objectForKey: key]]];
  }
  return [NSURL URLWithString: 
    [NSString stringWithFormat: @"%@%@", base, paramsString]];
}

- (NSArray *) imagesArray
{
  // keys are based on image position; e.g. 1-12
  // NSArray *keys = [_images allKeys];
  // keys = [keys sortedArrayUsingComparator: ^(id obj1, id obj2) {
  //   int key1 = [(NSString *) obj1 intValue];
  //   int key2 = [(NSString *) obj2 intValue];
  //   if (key1 > key2)
  //     return (NSComparisonResult) NSOrderedDescending;
  //   if (key1 < key2)
  //     return (NSComparisonResult) NSOrderedAscending;
  //   return (NSComparisonResult) NSOrderedSame;
  // }];
  // NSMutableArray *array = [NSMutableArray array];
  // for (NSString *key in keys) {
  //   [array addObject: [_images objectForKey: key]];
  // }
  // return array;

  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"position" 
    ascending: YES];
  return [_images sortedArrayUsingDescriptors: @[sort]];
}

- (UIImage *) imageAtPosition: (int) position
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"position", position];
  NSArray *array = [_images filteredArrayUsingPredicate: predicate];
  if ([array count] > 0) {
    OMBResidenceImage *residenceImage = [array objectAtIndex: 0];
    return residenceImage.image;
  }
  return nil;
}

- (UIImage *) imageForSize: (CGFloat) size
{
  NSNumber *key = [NSNumber numberWithFloat: size];
  UIImage *img = [_imageSizeDictionary objectForKey: key];
  if (!img) {
    if ([self coverPhoto]) {
      img = [UIImage image: [self coverPhoto] size: CGSizeMake(size, size)];
      return img;
    }
  }
  return nil;
}

- (void) readFromOffersDictionary: (NSDictionary *) dictionary
{
  NSArray *array = [dictionary objectForKey: @"objects"];
  for (NSDictionary *dict in array) {
    OMBOffer *offer = [[OMBOffer alloc] init];
    [offer readFromDictionary: dict];
    [self addOffer: offer];
  }
}

- (void) readFromOpenHouseDictionary: (NSDictionary *) dictionary
{
  NSArray *array = [dictionary objectForKey: @"objects"];
  for (NSDictionary *dict in array) {
    OMBOpenHouse *openHouse = [[OMBOpenHouse alloc] init];
    [openHouse readFromDictionary: dict];
    [self addOpenHouse: openHouse];
  }
}

- (void) readFromPropertyDictionary: (NSDictionary *) dictionary
{
  // Sample JSON
  //   {
  //     ad: 8550 fun street,  // Address
  //     available_on: "Soon", // Available on
  //     ba: 0,                // Bathrooms
  //     bd: 0,                // Bedrooms
  //     id: 10,               // ID
  //     lat: 32.79383,        // Latitude
  //     lease_months: null,   // Lease months
  //     lng: -117.07943,      // Longitude
  //     rt: 0                 // Rent
  //   }
  if ([dictionary objectForKey: @"ad"] == [NSNull null])
    _address = @"Address currently unavailable";
  else
    _address = [dictionary objectForKey: @"ad"];
  // Available on example value: October 23, 2013
  NSString *dateString        = [dictionary objectForKey: @"available_on"];
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat: @"MMMM d, yyyy"];
  if ([dateString isEqualToString: @"Immediately"] || 
    [dateString isEqualToString: @"Soon"]) {
    _availableOn = [[NSDate date] timeIntervalSince1970];
  }
  else {
    _availableOn = [[dateFormat dateFromString: 
      dateString] timeIntervalSince1970];
  }
  _bathrooms = [[dictionary objectForKey: @"ba"] floatValue];
  _bedrooms  = [[dictionary objectForKey: @"bd"] floatValue];
  _latitude  = [[dictionary objectForKey: @"lat"] floatValue];
  if ([dictionary objectForKey: @"lease_months"] == [NSNull null]) {
    _leaseMonths = 0;
  }
  else {
    _leaseMonths = [[dictionary objectForKey: @"lease_months"] intValue];
  }
  _longitude = [[dictionary objectForKey: @"lng"] floatValue];
  _minRent   = [[dictionary objectForKey: @"rt"] floatValue];
  if ([dictionary objectForKey: @"title"] != [NSNull null])
    _title = [dictionary objectForKey: @"title"];
  else
    _title = @"";
  _uid       = [[dictionary objectForKey: @"id"] intValue];
}

- (void) readFromResidenceDictionary: (NSDictionary *) dictionary
{
  // Sample JSON
  // {
  //   address: "3915 Broadlawn Street ",
  //   available_on: "2013-11-14 00:00:00 +0000",
  //   bathrooms: "2.0",
  //   bedrooms: "4.0",
  //   city: "San Diego",
  //   created_at: "2013-10-11 17:34:06 -0700",
  //   description: "Address of Available Listing",
  //   email: null,
  //   id: 3415,
  //   landlord_name: null,
  //   latitude: 32.815313,
  //   lease_months: null,
  //   longitude: -117.168185,
  //   phone: "(858) 695-9400",
  //   rent: 2505,
  //   sqft: 1466,
  //   state: "CA",
  //   title: "Best place ever",
  //   updated_at: "2013-10-11 17:34:06 -0700",
  //   zip: "92111"
  // }

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat       = @"yyyy-MM-dd HH:mm:ss ZZZ";

  // Address
  if ([dictionary objectForKey: @"address"] != [NSNull null])
    _address = [dictionary objectForKey: @"address"];
  // Amenities
  if ([dictionary objectForKey: @"amenities"] != [NSNull null]) {
    NSArray *amenitiesArray = [[dictionary objectForKey: 
      @"amenities"] componentsSeparatedByString: @","];
    for (NSString *amenitiesString in amenitiesArray) {
      if ([amenitiesString length])
        [_amenities setObject: [NSNumber numberWithInt: 1] forKey:
          [[amenitiesString stripWhiteSpace] lowercaseString]];
    }
  }
  // Auction Duration
  if ([dictionary objectForKey: @"auction_duration"] != [NSNull null])
    _auctionDuration = [[dictionary objectForKey: 
      @"auction_duration"] intValue];
  // Auction Start Date
  if ([dictionary objectForKey: @"auction_start_date"] != [NSNull null])
    _auctionStartDate = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"auction_start_date"]] timeIntervalSince1970];
  // Available on
  if ([dictionary objectForKey: @"available_on"] != [NSNull null])
    _availableOn = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"available_on"]] timeIntervalSince1970];
  // Bathrooms
  if ([dictionary objectForKey: @"bathrooms"] != [NSNull null])
    _bathrooms = [[dictionary objectForKey: @"bathrooms"] floatValue];
  if ([dictionary objectForKey: @"min_bathrooms"] != [NSNull null]) {
    _bathrooms = [[dictionary objectForKey: @"min_bathrooms"] floatValue];
  }
  // Bedrooms
  if ([dictionary objectForKey: @"bedrooms"] != [NSNull null])
    _bedrooms = [[dictionary objectForKey: @"bedrooms"] floatValue];
  if ([dictionary objectForKey: @"min_bedrooms"] != [NSNull null]) {
    _bedrooms = [[dictionary objectForKey: @"min_bedrooms"] floatValue];
  }
  // Cats
  if ([dictionary objectForKey: @"cats"] != [NSNull null]) {
    if ([[dictionary objectForKey: @"cats"] intValue])
      _cats = YES;
    else
      _cats = NO;
  }
  // City
  if ([dictionary objectForKey: @"city"] != [NSNull null])
    _city = [dictionary objectForKey: @"city"];
  // Created at
  if ([dictionary objectForKey: @"created_at"] != [NSNull null])
    _createdAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];
  // Description
  if ([dictionary objectForKey: @"description"] != [NSNull null])
    _description = [dictionary objectForKey: @"description"];
  // Dogs
  if ([dictionary objectForKey: @"dogs"] != [NSNull null]) {
    if ([[dictionary objectForKey: @"dogs"] intValue])
      _dogs = YES;
    else
      _dogs = NO;
  }
  // Email
  if ([dictionary objectForKey: @"email"] != [NSNull null])
    _email = [dictionary objectForKey: @"email"];
  // ID
  if ([dictionary objectForKey: @"id"] != [NSNull null])
    _uid = [[dictionary objectForKey: @"id"] intValue];
  // Is Auction
  if ([dictionary objectForKey: @"is_auction"] != [NSNull null]) {
    if ([[dictionary objectForKey: @"is_auction"] intValue] == 1) {
      _isAuction = YES;
    }
    else {
      _isAuction = NO;
    }
  }
  // Landlord name
  if ([dictionary objectForKey: @"landlord_name"] != [NSNull null])
    _landlordName = [dictionary objectForKey: @"landlord_name"];
  // Latitude
  if ([dictionary objectForKey: @"latitude"] != [NSNull null])
    _latitude = [[dictionary objectForKey: @"latitude"] floatValue];
  // Lease months
  if ([dictionary objectForKey: @"lease_months"] == [NSNull null]) {
    _leaseMonths = 0;
  }
  else {
    _leaseMonths = [[dictionary objectForKey: @"lease_months"] intValue];
  }
  // Lease Type
  if ([dictionary objectForKey: @"lease_type"] != [NSNull null])
    _leaseType = [dictionary objectForKey: @"lease_type"];
  // Longitude
  if ([dictionary objectForKey: @"longitude"] != [NSNull null])
    _longitude = [[dictionary objectForKey: @"longitude"] floatValue];
  // Min Rent
  if ([dictionary objectForKey: @"min_rent"] != [NSNull null])
    _minRent = [[dictionary objectForKey: @"min_rent"] floatValue];
  // Move-in Date
  if ([dictionary objectForKey: @"move_in_date"] != [NSNull null])
    _moveInDate = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"move_in_date"]] timeIntervalSince1970];
  // Phone
  if ([dictionary objectForKey: @"phone"] != [NSNull null])
    _phone = [dictionary objectForKey: @"phone"];
  // Property Type
  if ([dictionary objectForKey: @"property_type"] != [NSNull null]) {
    _propertyType = [dictionary objectForKey: @"property_type"];
  }
  // Rent it Now Price
  if ([dictionary objectForKey: @"rent_it_now_price"] != [NSNull null])
    _rentItNowPrice = [[dictionary objectForKey: 
      @"rent_it_now_price"] floatValue];
  // Square feet
  if ([dictionary objectForKey: @"sqft"] != [NSNull null])
    _squareFeet = [[dictionary objectForKey: @"sqft"] intValue];
  if ([dictionary objectForKey: @"min_sqft"] != [NSNull null])
    _squareFeet = [[dictionary objectForKey: @"min_sqft"] intValue];
  // State
  if ([dictionary objectForKey: @"state"] != [NSNull null])
    _state = [dictionary objectForKey: @"state"];
  // Title
  if ([dictionary objectForKey: @"title"] != [NSNull null])
    _title = [dictionary objectForKey: @"title"];
  // Unit
  if ([dictionary objectForKey: @"unit"] != [NSNull null])
    _unit = [dictionary objectForKey: @"unit"];
  // Updated at
  if ([dictionary objectForKey: @"updated_at"] != [NSNull null])
    _updatedAt = [[dateFormatter dateFromString:
      [dictionary objectForKey: @"updated_at"]] timeIntervalSince1970];
  // User
  if ([dictionary objectForKey: @"user"] != [NSNull null]) {
    NSDictionary *userDict = [dictionary objectForKey: @"user"];
    int userUID = [[userDict objectForKey: @"id"] intValue];
    OMBUser *user = [[OMBUserStore sharedStore] userWithUID: userUID];
    if (!user) {
      user = [[OMBUser alloc] init];
    }
    [user readFromDictionary: userDict];
    _user = user;
  }
  // Zip
  if ([dictionary objectForKey: @"zip"] != [NSNull null])
    _zip = [dictionary objectForKey: @"zip"];
}

- (void) removeResidenceImage: (OMBResidenceImage *) residenceImage
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i",
    @"position", residenceImage.position];
  NSArray *array = [_images filteredArrayUsingPredicate: predicate];
  if ([array count]) {
    [_images removeObject: [array firstObject]];
  }
}

- (NSString *) rentToCurrencyString
{
  return [NSString numberToCurrencyString: (int) _minRent];
}

- (NSArray *) sortedOffers
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"createdAt"
    ascending: YES];
  return [_offers sortedArrayUsingDescriptors: @[sort]];
}

- (NSArray *) sortedOpenHouseDates
{
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey: @"startDate"
    ascending: YES];
  return [_openHouseDates sortedArrayUsingDescriptors: @[sort]];
}

@end
