//
//  OMBResidencePartialView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/14/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidencePartialView.h"

#import "OMBAppDelegate.h"
#import "OMBFavoriteResidence.h"
#import "OMBFavoriteResidenceConnection.h"
#import "OMBMapViewController.h"
#import "OMBResidence.h"
#import "OMBResidenceCoverPhotoURLConnection.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

const float kBorderTopHeight               = 0.0;
const float kPropertyInfoViewAddressHeight = 28;

@implementation OMBResidencePartialView

@synthesize imageView = _imageView;
@synthesize residence = _residence;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    CGRect screen     = [[UIScreen mainScreen] bounds];
    float imageHeight = 
      screen.size.height * PropertyInfoViewImageHeightPercentage;
    self.backgroundColor = [UIColor colorWithRed: (245/255.0) green: (245/255.0)
      blue: (245/255.0) alpha: 0.8];
    self.frame = CGRectMake(0, 0, screen.size.width, 
      (kBorderTopHeight + imageHeight));

    // Image view
    _imageView                 = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.clipsToBounds   = YES;
    _imageView.contentMode     = UIViewContentModeTopLeft;
    _imageView.frame           = CGRectMake(0, kBorderTopHeight, 
      screen.size.width, imageHeight);
    [self addSubview: _imageView];

    // Info view; this is where the rent, bed, bath, and arrow go
    float rentLabelHeight    = 36;
    float rentLabelMarginTop = 0;
    float infoViewHeight     = rentLabelMarginTop + rentLabelHeight + 
      kPropertyInfoViewAddressHeight;
    infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor whiteAlpha: 0.9];
    infoView.frame = CGRectMake(0,  
      (self.frame.size.height - infoViewHeight), screen.size.width, 
        infoViewHeight);
    [self addSubview: infoView];

    // Activity indicator
    activityIndicatorView = 
      [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
        UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.color = [UIColor grayDark];
    activityIndicatorView.frame = CGRectMake(((screen.size.width - 40) / 2.0),
      ((_imageView.frame.size.height - (infoViewHeight + 40)) / 2.0), 40, 40);
    [self addSubview: activityIndicatorView];

    // Rent
    rentLabel = [[UILabel alloc] init];
    rentLabel.backgroundColor = [UIColor clearColor];
    rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 27];
    rentLabel.frame = CGRectMake(20, rentLabelMarginTop, 
      ((screen.size.width / 2.0) - 30), rentLabelHeight);
    rentLabel.textColor = [UIColor textColor];
    [infoView addSubview: rentLabel];

    // Bedrooms / Bathrooms
    bedBathLabel = [[UILabel alloc] init];
    bedBathLabel.backgroundColor = [UIColor clearColor];
    bedBathLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
    bedBathLabel.frame = CGRectMake((20 + rentLabel.frame.size.width + 10),
      rentLabel.frame.origin.y, ((screen.size.width / 2.0) - 30), 
        rentLabel.frame.size.height);
    bedBathLabel.textColor = rentLabel.textColor;
    [infoView addSubview: bedBathLabel];

    float buttonDimension = infoView.frame.size.height * 0.8;
    addToFavoritesButton = [[UIButton alloc] init];
    addToFavoritesButton.backgroundColor = [UIColor clearColor];
    CGSize favoriteButtonSize = CGSizeMake(buttonDimension, buttonDimension);
    addToFavoritesButton.frame = CGRectMake(
      (self.frame.size.width - (favoriteButtonSize.width)), 
        (self.frame.size.height - (favoriteButtonSize.height)), 
          favoriteButtonSize.width, favoriteButtonSize.height);
    minusFavoriteImage = [UIImage image: 
      [UIImage imageNamed: @"favorite_pink.png"] 
        size: addToFavoritesButton.frame.size];
    plusFavoriteImage = [UIImage image: 
      [UIImage imageNamed: @"favorite_outline.png"] 
        size: addToFavoritesButton.frame.size];
    [addToFavoritesButton addTarget: self 
      action: @selector(addToFavoritesButtonSelected) 
        forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: addToFavoritesButton];

    addressLabel = [[UILabel alloc] init];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
    addressLabel.frame = CGRectMake(rentLabel.frame.origin.x, 
      (rentLabel.frame.origin.y + rentLabel.frame.size.height), 
        (infoView.frame.size.width - ((rentLabel.frame.origin.x * 2) + 
        addToFavoritesButton.frame.size.width)),
          kPropertyInfoViewAddressHeight);
    addressLabel.textColor = rentLabel.textColor;
    [infoView addSubview: addressLabel];

    [[NSNotificationCenter defaultCenter] addObserver: self
      selector: @selector(adjustFavoriteButton)
        name: OMBCurrentUserChangedFavorite object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
      selector: @selector(adjustFavoriteButton)
        name: OMBUserLoggedOutNotification object: nil];
  }
  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addToFavoritesButtonSelected
{
  if ([[OMBUser currentUser] loggedIn]) {
    if ([[OMBUser currentUser] alreadyFavoritedResidence: _residence]) {
      [[OMBUser currentUser] removeResidenceFromFavorite: _residence];
      [UIView animateWithDuration: 0.5 animations: ^{
        [addToFavoritesButton setImage: plusFavoriteImage
          forState: UIControlStateNormal];
      }];
    }
    else {
      OMBFavoriteResidence *favoriteResidence = 
        [[OMBFavoriteResidence alloc] init];
      favoriteResidence.createdAt = [[NSDate date] timeIntervalSince1970];
      favoriteResidence.residence = _residence;
      [[OMBUser currentUser] addFavoriteResidence: favoriteResidence];
      UIImageView *imageView = addToFavoritesButton.imageView;
      [UIView animateWithDuration: 0.5 delay:0
        options: UIViewAnimationOptionBeginFromCurrentState
          animations: ^{
            imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            [addToFavoritesButton setImage: minusFavoriteImage
              forState: UIControlStateNormal];
          }
          completion: ^(BOOL finished){
            imageView.transform = CGAffineTransformIdentity;
          }
        ];
    }
    OMBFavoriteResidenceConnection *connection = 
      [[OMBFavoriteResidenceConnection alloc] initWithResidence: _residence];
    [connection start];
  }
  else {
    OMBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate showLogin];
  }
}

- (void) adjustFavoriteButton
{
  if ([[OMBUser currentUser] loggedIn]) {
    if ([[OMBUser currentUser] alreadyFavoritedResidence: _residence])
      [addToFavoritesButton setImage: minusFavoriteImage
        forState: UIControlStateNormal];
    else
      [addToFavoritesButton setImage: plusFavoriteImage
        forState: UIControlStateNormal];
  }
  else {
    [addToFavoritesButton setImage: plusFavoriteImage
      forState: UIControlStateNormal];
  }
}

- (void) loadResidenceData: (OMBResidence *) object
{
  CGRect screen     = [[UIScreen mainScreen] bounds];
  float imageHeight = 
    screen.size.height * PropertyInfoViewImageHeightPercentage;

  _residence = object;

  // Bedrooms
  NSString *bedsString = @"bd";
  // if (_residence.bedrooms == 1)
  //   bedsString = @"bed";
  NSString *bedsNumberString;
  if (_residence.bedrooms == (int) _residence.bedrooms)
    bedsNumberString = [NSString stringWithFormat: @"%i", 
      (int) _residence.bedrooms];
  else
    bedsNumberString = [NSString stringWithFormat: @"%.01f",
      _residence.bedrooms];
  NSString *beds = [NSString stringWithFormat: @"%@ %@", 
    bedsNumberString, bedsString];
  // Bathrooms
  NSString *bathsString = @"ba";
  // if (_residence.bathrooms == 1)
  //   bathsString = @"bath";
  NSString *bathsNumberString;
  if (_residence.bathrooms == (int) _residence.bathrooms)
    bathsNumberString = [NSString stringWithFormat: @"%i",
      (int) _residence.bathrooms];
  else
    bathsNumberString = [NSString stringWithFormat: @"%.01f",
      _residence.bathrooms];
  NSString *baths = [NSString stringWithFormat: @"%@ %@",
    bathsNumberString, bathsString];
  // Bedrooms / Bathrooms
  bedBathLabel.text = [NSString stringWithFormat: @"%@ / %@", beds, baths];

  // Image
  if (_residence.coverPhotoForCell)
    _imageView.image = _residence.coverPhotoForCell;
  else {
    // Get _residence cover photo url
    OMBResidenceCoverPhotoURLConnection *connection = 
      [[OMBResidenceCoverPhotoURLConnection alloc] initWithResidence: 
        _residence];
    connection.completionBlock = ^(NSError *error) {
      _residence.coverPhotoForCell = [_residence coverPhotoWithSize: 
        CGSizeMake(screen.size.width, imageHeight)];
      _imageView.image = _residence.coverPhotoForCell;
      [activityIndicatorView stopAnimating];
    };
    [connection start];
    [activityIndicatorView startAnimating];
  }

  // Rent
  rentLabel.text = [NSString stringWithFormat: @"%@", 
    [_residence rentToCurrencyString]];

  CGRect rentLabelFrame = rentLabel.frame;
  CGRect rentRect = [rentLabel.text boundingRectWithSize:
      CGSizeMake(((screen.size.width / 2.0) - 30), rentLabel.frame.size.height)
        options: NSStringDrawingUsesLineFragmentOrigin 
          attributes: @{NSFontAttributeName: rentLabel.font} 
            context: nil];
  rentLabelFrame.size.width = rentRect.size.width;
  rentLabel.frame = rentLabelFrame;

  CGRect bedBathLabelFrame = bedBathLabel.frame;
  CGRect bedBathRect = [bedBathLabel.text boundingRectWithSize:
      CGSizeMake((screen.size.width - 
        (20 + rentLabel.frame.size.width + 20 + 10 + 
          arrowImageView.frame.size.width + 10)), 
        bedBathLabel.frame.size.height)
          options: NSStringDrawingUsesLineFragmentOrigin 
            attributes: @{NSFontAttributeName: bedBathLabel.font} 
              context: nil];
  bedBathLabelFrame.origin.x = 
    rentLabel.frame.origin.x + rentLabel.frame.size.width + 20;
  bedBathLabelFrame.size.width = bedBathRect.size.width;
  bedBathLabel.frame = bedBathLabelFrame;

  // Address
  addressLabel.text = [_residence.address capitalizedString];

  // Add to favorites button image
  [self adjustFavoriteButton];
}

@end
