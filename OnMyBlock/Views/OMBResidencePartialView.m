//
//  OMBResidencePartialView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/14/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidencePartialView.h"

#import "NSString+Extensions.h"
#import "OMBAppDelegate.h"
#import "OMBFavoriteResidence.h"
#import "OMBFavoriteResidenceConnection.h"
#import "OMBGradientView.h"
#import "OMBMapViewController.h"
#import "OMBResidence.h"
#import "OMBResidenceCoverPhotoURLConnection.h"
#import "OMBResidenceImagesConnection.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"
#import "OMBFilmstripImageCell.h"
#import "OMBResidenceImage.h"
#import "UIImageView+WebCache.h"

NSString *const OMBEmptyResidencePartialViewCell = 
  @"OMBEmptyResidencePartialViewCell";

@implementation OMBResidencePartialView

@synthesize residence = _residence;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;

  float imageHeight = 
    screen.size.height * PropertyInfoViewImageHeightPercentage;
  self.backgroundColor = [UIColor colorWithRed: (0/255.0) green: (0/255.0)
    blue: (0/255.0) alpha: 1.0];
  self.frame = CGRectMake(0, 0, screen.size.width, imageHeight);

	[self resetFilmstrip];

  // Add to favorites button
  float buttonDimension = 40;
  float buttonMargin    = 5;
  addToFavoritesButtonView = [[OMBGradientView alloc] init];
  addToFavoritesButtonView.colors = @[
    [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5],
      [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.0]];
  addToFavoritesButtonView.frame = CGRectMake(0, 0, 
    screen.size.width, (buttonDimension + (buttonMargin * 2)));
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
  rentLabel.textAlignment = NSTextAlignmentRight;
  rentLabel.textColor = [UIColor whiteColor];
  [infoView addSubview: rentLabel];

  // Bedrooms / Bathrooms
  bedBathLabel = [[UILabel alloc] init];
  bedBathLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  bedBathLabel.frame = CGRectMake(10.0f, marginTop * 2, 
    screenWidth - (10 * 2), bedBathLabelHeight);
  bedBathLabel.textColor = rentLabel.textColor;
  [infoView addSubview: bedBathLabel];

  // Address
  addressLabel = [[UILabel alloc] init];
  addressLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
  // addressLabel.frame = CGRectMake(bedBathLabel.frame.origin.x, 
  //   bedBathLabel.frame.origin.y + bedBathLabel.frame.size.height, 
  //     (screen.size.width - (bedBathLabel.frame.origin.x * 3)) * 0.5, 
  //       bedBathLabelHeight);
  addressLabel.frame = CGRectMake(bedBathLabel.frame.origin.x, 
    bedBathLabel.frame.origin.y + bedBathLabel.frame.size.height, 
      bedBathLabel.frame.size.width, bedBathLabelHeight);
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
  // [infoView addSubview: offersAndTimeLabel];

  // Rent frame
  CGFloat rentLabelWidth = screenWidth - (bedBathLabel.frame.origin.x * 2);
  rentLabel.frame = CGRectMake(bedBathLabel.frame.origin.x, 
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
  activityFrame.origin.y = (imageHeight -
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

#pragma mark - Protocol

#pragma mark - Protocol UICollectionViewDataDelegate

- (NSInteger) collectionView: (UICollectionView *) collectionView 
numberOfItemsInSection: (NSInteger) section
{
  if ([_residence imagesArray].count)
    return [_residence imagesArray].count;
  return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *) collectionView 
cellForItemAtIndexPath: (NSIndexPath *) indexPath
{
  if ([_residence imagesArray].count) {
    OMBFilmstripImageCell *cell = 
      [collectionView dequeueReusableCellWithReuseIdentifier:
        [OMBFilmstripImageCell reuseID] forIndexPath: indexPath];
    // Don't resize images or else it hurts performance
    OMBResidenceImage *residenceImage = 
      [[_residence imagesArray] objectAtIndex: indexPath.row];
    
    cell.imageView.image = [OMBResidence placeholderImage];
    __weak typeof(cell) weakCell = cell;
    
    //if(!weakCell.shown || !weakCell.imageView.image)
      //weakCell.imageView.alpha = 0.0f;
      
    [weakCell.imageView setImageWithURL: residenceImage.imageURL
      placeholderImage: nil 
        options: (SDWebImageRetryFailed | 
          SDWebImageDownloaderProgressiveDownload)
        completed:
          ^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error) {
              NSLog(@"Error: %@, for: %@", error, residenceImage.imageURL);
            }
            
            cell.alpha = 0.0f;
            [UIView animateWithDuration:1.0 animations:^{
              cell.alpha = 1.0f;
            }];
          }
        ];
    return cell;
  }
  return [collectionView dequeueReusableCellWithReuseIdentifier:
    OMBEmptyResidencePartialViewCell forIndexPath: indexPath];

  // #warning UIImage resize is hurting performance
  // UIImage *image = [_residence imageForSize: cell.imageView.bounds.size
  //   forResidenceImage: residenceImage];
  // if (image) {
  //   cell.imageView.image = image;
  // }
  // else {
  //   [_residence addImageWithResidenceImage: residenceImage
  //     toImageSizeDictionaryWithSize: cell.imageView.bounds.size];
  // }
}

#pragma mark - Protocol UICollectionViewDelegate

- (void) collectionView: (UICollectionView *) collectionView 
didSelectItemAtIndexPath: (NSIndexPath *) indexPath
{
  if (self.selected)
    self.selected(self.residence, indexPath.row);
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

- (void) cancelResidenceCoverPhotoDownload
{
  if (_residence)
    [_residence cancelCoverPhotoDownload];
}

- (void) downloadResidenceImages
{
  // return;
  if (isDownloadingResidenceImages)
    return;
  NSLog(@"DOWNLOAD RESIDENCE IMAGES");
  [_residence downloadImagesWithCompletion: ^(NSError *error) {
    [_imagesFilmstrip reloadData];
    isDownloadingResidenceImages = NO;
    NSLog(@"DOWNLOAD RESIDENCE IMAGES COMPLETION");
  }];
  isDownloadingResidenceImages = YES;
  // NSLog(@"DOWNLOAD IMAGES: %i", _residence.uid);

  // if ([[_residence imagesArray] count] <= 1) {
  //   [_residence downloadImagesWithCompletion: ^(NSError *error) {
  //     [_imagesFilmstrip reloadData];
  //   }];
  // }
}

//- (void) loadImageAnimated: (BOOL) animated
//{
//  if (animated) {
//    _imageView.alpha = 0.0f;
//    [UIView animateWithDuration: 0.15f animations: ^{
//      _imageView.image = _residence.coverPhotoForCell;
//      _imageView.alpha = 1.0f;
//    }];
//  }
//  else {
//    _imageView.image = _residence.coverPhotoForCell;
//  }
//}

- (void) loadResidenceData: (OMBResidence *) object
{
  [_imagesFilmstrip reloadData];
  
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

  // Images
    [_imagesFilmstrip reloadData];
  // Cover photo
  if ([_residence coverPhoto]) {
    [_imagesFilmstrip reloadData];
    // [self downloadResidenceImages];
    if (_completionBlock)
      _completionBlock(nil);
  }
  else {
    // Download cover photo
    [_residence downloadCoverPhotoWithCompletion: ^(NSError *error) {
      [_imagesFilmstrip reloadData];
      // [self downloadResidenceImages];
      // [activityIndicatorView stopAnimating];
      if (_completionBlock)
        _completionBlock(nil);
    }];
    // [activityIndicatorView startAnimating];
  }

	// Rent
  rentLabel.text = [NSString stringWithFormat: @"%@", 
    [_residence rentToCurrencyString]];

  // CGRect rentLabelFrame = rentLabel.frame;
  // CGRect rentRect = [rentLabel.text boundingRectWithSize:
  //   CGSizeMake(((screen.size.width / 2.0) - 30), rentLabel.frame.size.height)
  //     options: NSStringDrawingUsesLineFragmentOrigin 
  //       attributes: @{NSFontAttributeName: rentLabel.font} 
  //         context: nil];
  // rentLabelFrame.origin.x = screen.size.width - (rentRect.size.width + 10);
  // rentLabelFrame.size.width = rentRect.size.width;
  // rentLabel.frame = rentLabelFrame;

  // Bed bath
  // CGRect bedBathLabelFrame = bedBathLabel.frame;
  // CGRect bedBathRect = [bedBathLabel.text boundingRectWithSize:
  //     CGSizeMake((screen.size.width - 
  //       (20 + rentLabel.frame.size.width + 20 + 10 + 
  //         arrowImageView.frame.size.width + 10)), 
  //       bedBathLabel.frame.size.height)
  //         options: NSStringDrawingUsesLineFragmentOrigin 
  //           attributes: @{NSFontAttributeName: bedBathLabel.font} 
  //             context: nil];
  // bedBathLabelFrame.size.width = bedBathRect.size.width;
  // bedBathLabel.frame = bedBathLabelFrame;

  // Title or address
  if ([_residence validTitle])
    addressLabel.text = _residence.title;
  else
    addressLabel.text = [_residence.address capitalizedString];

  // Add to favorites button image
  [self adjustFavoriteButton];
}

- (void) loadResidenceDataForPropertyInfoView: (OMBResidence *) object
{
  _residence = object;
  __weak typeof(self) weakSelf = self;
  _completionBlock = ^(NSError *error) {
    [weakSelf downloadResidenceImages];
  };
  [self loadResidenceData: object];
}

- (void) resetFilmstrip
{
  [_imagesFilmstrip removeFromSuperview];

  UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
  layout.itemSize = self.bounds.size;
  layout.minimumLineSpacing = 0.0f;
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

  _imagesFilmstrip = [[UICollectionView alloc] initWithFrame: self.bounds 
    collectionViewLayout: layout];
  [_imagesFilmstrip registerClass: 
    [OMBFilmstripImageCell class] forCellWithReuseIdentifier:
      [OMBFilmstripImageCell reuseID]];
  [_imagesFilmstrip registerClass:
    [UICollectionViewCell class] forCellWithReuseIdentifier:
      OMBEmptyResidencePartialViewCell];
  _imagesFilmstrip.alwaysBounceHorizontal = YES;
  _imagesFilmstrip.bounces = YES;
  _imagesFilmstrip.dataSource = self;
  _imagesFilmstrip.delegate = self;
  _imagesFilmstrip.pagingEnabled = YES;
  _imagesFilmstrip.showsHorizontalScrollIndicator = NO;

  [self insertSubview: _imagesFilmstrip atIndex: 0];
}

@end
