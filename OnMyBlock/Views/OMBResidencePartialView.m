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
#import "OMBGradientView.h"
#import "OMBMapViewController.h"
#import "OMBResidence.h"
#import "OMBResidenceCoverPhotoURLConnection.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@implementation OMBResidencePartialView

@synthesize imageView = _imageView;
@synthesize residence = _residence;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen     = [[UIScreen mainScreen] bounds];
  float imageHeight = 
    screen.size.height * PropertyInfoViewImageHeightPercentage;
  self.backgroundColor = [UIColor colorWithRed: (0/255.0) green: (0/255.0)
    blue: (0/255.0) alpha: 1.0];
  self.frame = CGRectMake(0, 0, screen.size.width, imageHeight);

  // Image view
  _imageView                 = [[UIImageView alloc] init];
  _imageView.backgroundColor = [UIColor clearColor];
  _imageView.clipsToBounds   = YES;
  _imageView.contentMode     = UIViewContentModeTopLeft;
  _imageView.frame = CGRectMake(0, 0, screen.size.width, imageHeight);
  [self addSubview: _imageView];

  // Add to favorites button
  float buttonDimension = 40;
  float buttonMargin    = 5;
  addToFavoritesButtonView = [[OMBGradientView alloc] init];
  addToFavoritesButtonView.colors = @[
    [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5],
      [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.0]];
  addToFavoritesButtonView.frame = CGRectMake(0, 0, 
    _imageView.frame.size.width, (buttonDimension + (buttonMargin * 2)));
  [self addSubview: addToFavoritesButtonView];

  addToFavoritesButton                 = [[UIButton alloc] init];
  addToFavoritesButton.backgroundColor = [UIColor clearColor];
  addToFavoritesButton.frame = CGRectMake(buttonMargin, buttonMargin,
    buttonDimension, buttonDimension);
  minusFavoriteImage = [UIImage image: 
    [UIImage imageNamed: @"favorite_filled_white.png"] 
      size: addToFavoritesButton.frame.size];
  plusFavoriteImage = [UIImage image: 
    [UIImage imageNamed: @"favorite_outline_white.png"] 
      size: addToFavoritesButton.frame.size];
  [addToFavoritesButton addTarget: self 
    action: @selector(addToFavoritesButtonSelected) 
      forControlEvents: UIControlEventTouchUpInside];
  [addToFavoritesButtonView addSubview: addToFavoritesButton];

  // Info view; this is where the rent, bed, bath, and arrow go
  float marginBottom       = 5;
  float marginTop          = 20;
  float bedBathLabelHeight = 25;
  float rentLabelHeight    = 40;
  float rentLabelWidth = (screen.size.width - 30) / 2.0;
  float infoViewHeight = marginTop + marginTop + (bedBathLabelHeight * 2) +
    marginBottom;
  infoView = [[OMBGradientView alloc] init];
  infoView.colors = @[
    [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.0],
      [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.8]];
  infoView.frame = CGRectMake(0.0f,  
    (self.frame.size.height - infoViewHeight), screen.size.width, 
      infoViewHeight);
  [self addSubview: infoView];

  // Rent
  rentLabel = [[UILabel alloc] init];
  rentLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 27];
  rentLabel.textColor = [UIColor whiteColor];
  [infoView addSubview: rentLabel];

  // Bedrooms / Bathrooms
  bedBathLabel = [[UILabel alloc] init];
  bedBathLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  bedBathLabel.frame = CGRectMake(10, marginTop * 2, 
    rentLabelHeight, bedBathLabelHeight);
  bedBathLabel.textColor = rentLabel.textColor;
  [infoView addSubview: bedBathLabel];

  // Address
  addressLabel = [[UILabel alloc] init];
  addressLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  addressLabel.frame = CGRectMake(bedBathLabel.frame.origin.x, 
    bedBathLabel.frame.origin.y + bedBathLabel.frame.size.height, 
      (screen.size.width - (bedBathLabel.frame.origin.x * 3)) * 0.5, 
        bedBathLabelHeight);
  addressLabel.textColor = rentLabel.textColor;
  [infoView addSubview: addressLabel];

  // Offers and time
  offersAndTimeLabel = [[UILabel alloc] init];
  offersAndTimeLabel.font = addressLabel.font;
  offersAndTimeLabel.frame = CGRectMake(
    infoView.frame.size.width - 
    (addressLabel.frame.origin.x + addressLabel.frame.size.width),
      addressLabel.frame.origin.y,
        addressLabel.frame.size.width, addressLabel.frame.size.height);
  offersAndTimeLabel.text = @"2 offers 13d 2h";
  offersAndTimeLabel.textAlignment = NSTextAlignmentRight;
  offersAndTimeLabel.textColor = addressLabel.textColor;
  [infoView addSubview: offersAndTimeLabel];

  // Rent frame
  rentLabel.frame = CGRectMake((screen.size.width - rentLabelWidth), 
    offersAndTimeLabel.frame.origin.y - rentLabelHeight, 
      rentLabelWidth, rentLabelHeight);

  // Activity indicator
  activityIndicatorView = 
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
      UIActivityIndicatorViewStyleWhite];
  activityIndicatorView.color = [UIColor whiteColor];
  CGRect activityFrame = activityIndicatorView.frame;
  activityFrame.origin.x = (screen.size.width - 
    activityFrame.size.width) / 2.0;
  activityFrame.origin.y = (_imageView.frame.size.height - 
    activityFrame.size.height) / 2.0;
  activityIndicatorView.frame = activityFrame;
  [self addSubview: activityIndicatorView];

  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(adjustFavoriteButton)
      name: OMBCurrentUserChangedFavorite object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(adjustFavoriteButton)
      name: OMBUserLoggedOutNotification object: nil];

  return self;
}

- (void) dealloc
{
  // Must dealloc or notifications get sent to zombies
  [[NSNotificationCenter defaultCenter] removeObserver: self];
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
      favoriteResidence.user      = [OMBUser currentUser];
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

- (void) loadImageAnimated: (BOOL) animated
{
  _imageView.image = _residence.coverPhotoForCell;
  if (animated) {
    _imageView.alpha = 0.0f;
    [UIView animateWithDuration: 0.25f animations: ^{
      _imageView.alpha = 1.0f;
    }];
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
  if (_residence.coverPhotoForCell) {
    [self loadImageAnimated: NO];
  }
  else {
    // Get _residence cover photo url
    OMBResidenceCoverPhotoURLConnection *connection = 
      [[OMBResidenceCoverPhotoURLConnection alloc] initWithResidence: 
        _residence];
    connection.completionBlock = ^(NSError *error) {
      _residence.coverPhotoForCell = [_residence coverPhotoWithSize: 
        CGSizeMake(screen.size.width, imageHeight)];
      [self loadImageAnimated: YES];
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
  rentLabelFrame.origin.x = screen.size.width - (rentRect.size.width + 10);
  rentLabelFrame.size.width = rentRect.size.width;
  rentLabel.frame = rentLabelFrame;

  // Bed bath
  CGRect bedBathLabelFrame = bedBathLabel.frame;
  CGRect bedBathRect = [bedBathLabel.text boundingRectWithSize:
      CGSizeMake((screen.size.width - 
        (20 + rentLabel.frame.size.width + 20 + 10 + 
          arrowImageView.frame.size.width + 10)), 
        bedBathLabel.frame.size.height)
          options: NSStringDrawingUsesLineFragmentOrigin 
            attributes: @{NSFontAttributeName: bedBathLabel.font} 
              context: nil];
  bedBathLabelFrame.size.width = bedBathRect.size.width;
  bedBathLabel.frame = bedBathLabelFrame;

  // Address
  addressLabel.text = [_residence.address capitalizedString];

  // Add to favorites button image
  [self adjustFavoriteButton];
}
@end
