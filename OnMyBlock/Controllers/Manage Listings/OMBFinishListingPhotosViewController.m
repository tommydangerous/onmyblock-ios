//
//  OMBFinishListingPhotosViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingPhotosViewController.h"

#import "AMBlurView.h"
#import "CustomLoading.h"
#import "OMBEditablePhotoView.h"
#import "OMBResidence.h"
#import "OMBResidenceImage.h"
#import "OMBResidenceImageDeleteConnection.h"
#import "OMBResidenceImageUpdateConnection.h"
#import "OMBResidenceImagesConnection.h"
#import "OMBResidenceUploadImageConnection.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"
#import "UIImage+Resize.h"
#import "UIImageView+WebCache.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBFinishListingPhotosViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(progressConnection:) name:@"progressConnection" object:nil];
    
  residence  = object;

  self.screenName = @"Photos";
  self.title      = @"Photos";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIResponder

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
  NSLog(@"TOUCHES BEGAN");
  if ([touches count] == 1) {
    // One finger
    CGPoint touchPoint = [[touches anyObject] locationInView: scroll];
    for (OMBEditablePhotoView *photoView in scroll.subviews) {
      if ([photoView isKindOfClass: [OMBEditablePhotoView class]]) {
        if (touchPoint.x > photoView.frame.origin.x &&
          touchPoint.x < photoView.frame.origin.x + 
          photoView.frame.size.width && 
          touchPoint.y > photoView.frame.origin.y && 
          touchPoint.y < photoView.frame.origin.y + 
          photoView.frame.size.height) {

          _dragObject = photoView;
          _touchOffset = CGPointMake(touchPoint.x - photoView.frame.origin.x,
            touchPoint.y - photoView.frame.origin.y);
          _homePosition = CGPointMake(photoView.frame.origin.x,
            photoView.frame.origin.y);
          [scroll bringSubviewToFront: _dragObject];
        }
      }
    }
  }
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
  CGPoint touchPoint = [[touches anyObject] locationInView: scroll];
  if (touchPoint.x > _dropTarget.frame.origin.x &&
    touchPoint.x < _dropTarget.frame.origin.x + _dropTarget.frame.size.width &&
    touchPoint.y > _dropTarget.frame.origin.y &&
    touchPoint.y < _dropTarget.frame.origin.y + _dropTarget.frame.size.height) {

    _dropTarget.backgroundColor = _dragObject.backgroundColor;
  } 
  _dragObject.frame = CGRectMake(_homePosition.x, _homePosition.y,
    _dragObject.frame.size.width, _dragObject.frame.size.height);
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
  CGPoint touchPoint = [[touches anyObject] locationInView: scroll];
  CGRect newDragObjectFrame = CGRectMake(touchPoint.x - _touchOffset.x,
    touchPoint.y - _touchOffset.y, _dragObject.frame.size.width,
      _dragObject.frame.size.height);
  _dragObject.frame = newDragObjectFrame;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
    
  // reload CustomLoading
  [[CustomLoading getInstance] clearInstance];
    
  UIFont *boldFont = [UIFont boldSystemFontOfSize: 17];
  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Save"
    style: UIBarButtonItemStylePlain target: self action: @selector(save)];
  [doneBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Edit"
    style: UIBarButtonItemStylePlain target: self action: @selector(edit)];
  [editBarButtonItem setTitleTextAttributes: @{
    NSFontAttributeName: boldFont
  } forState: UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = editBarButtonItem;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view = [[UIView alloc] initWithFrame: screen];

  scroll = [UIScrollView new];
  scroll.alwaysBounceVertical = YES;
  scroll.delegate = self;
  scroll.frame = screen;
  scroll.showsVerticalScrollIndicator = NO;
  [self.view addSubview: scroll];

  CGFloat buttonHeight = 44.0f;
  CGFloat buttonWidth  = screen.size.width * 0.5f;
  addPhotoButtonView = [[AMBlurView alloc] init];
  addPhotoButtonView.backgroundColor = [UIColor colorWithWhite: 1.0f 
    alpha: 0.8f];
  addPhotoButtonView.frame = CGRectMake(
    (screen.size.width - buttonWidth) * 0.5f, 
      screen.size.height - (buttonHeight + 20.0f), buttonWidth, buttonHeight);
  addPhotoButtonView.layer.borderColor = [UIColor blue].CGColor;
  addPhotoButtonView.layer.borderWidth = 1.0f;
  addPhotoButtonView.layer.cornerRadius = buttonHeight * 0.5f;
  // addPhotoButtonView.blurTintColor = [UIColor blue];
  [self.view addSubview: addPhotoButtonView];

  addPhotoButton = [UIButton new];
  addPhotoButton.frame = CGRectMake(0.0f, 0.0f, 
    addPhotoButtonView.frame.size.width, addPhotoButtonView.frame.size.height);
  addPhotoButton.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
    size: 15];
  [addPhotoButton addTarget: self action: @selector(addPhoto)
    forControlEvents: UIControlEventTouchUpInside];
  [addPhotoButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueAlpha: 0.8f]]
      forState: UIControlStateHighlighted];
  [addPhotoButton setTitle: @"Add Photo" forState: UIControlStateNormal];
  [addPhotoButton setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  [addPhotoButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateHighlighted];
  [addPhotoButtonView addSubview: addPhotoButton];

  // Action sheet
  addPhotoActionSheet = [[UIActionSheet alloc] initWithTitle: nil 
    delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil 
      otherButtonTitles: @"Take Photo", @"Choose Existing", nil];
  [self.view addSubview: addPhotoActionSheet];
    
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [self reloadPhotosAnimated: NO];
    
  [self updateTitle];
    
}

#pragma mark - Protocol

#pragma mark - Protocol ELCImagePickerControllerDelegate

- (void) elcImagePickerController: (ELCImagePickerController *) picker
didFinishPickingMediaWithInfo: (NSArray *) info
{
  CustomLoading *custom = [CustomLoading getInstance];
  custom.numImages = 0;
  for (NSDictionary *dict in info) {
    custom.numImages++;
    [self createResidenceImageWithDictionary: dict];
  }
  [picker dismissViewControllerAnimated: YES completion: nil];
}

- (void) elcImagePickerControllerDidCancel: (ELCImagePickerController *) picker
{
  [picker dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Protocol UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  UIImagePickerController *cameraImagePicker =
    [[UIImagePickerController alloc] init];
  cameraImagePicker.allowsEditing = YES;
  cameraImagePicker.delegate = self;

  // Select multiple images
  ELCImagePickerController *libraryImagePicker = 
    [[ELCImagePickerController alloc] initImagePicker];
  libraryImagePicker.imagePickerDelegate = self;
  // Set the maximum number of images to select, defaults to 4
  libraryImagePicker.maximumImagesCount = 4;
  // Only return the fullScreenImage, not the fullResolutionImage
  libraryImagePicker.returnsOriginalImage = NO;

  // Take Photo
  if (buttonIndex == 0) {
    // Show camera
    if ([UIImagePickerController isSourceTypeAvailable:
      UIImagePickerControllerSourceTypeCamera]) {
      
      cameraImagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
      [self presentViewController: cameraImagePicker animated: YES 
        completion: nil];
    }
    // Default to the library
    else {
      [self presentViewController: libraryImagePicker animated: YES
        completion: nil];
    }
  }
  // Choose existing
  else if (buttonIndex == 1) {
    [self presentViewController: libraryImagePicker animated: YES
        completion: nil];
  }
}

#pragma mark - UIAlertViewDelegate Protocol

- (void) alertView: (UIAlertView *) alertView 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 1)
    [self deleteImageView];
}

#pragma mark - Protocol UIImagePickerControllerDelegate

- (void) imagePickerController: (UIImagePickerController *) picker 
didFinishPickingMediaWithInfo: (NSDictionary *) info
{
  [[CustomLoading getInstance] setNumImages: 1];
  [self createResidenceImageWithDictionary: info];

  [picker dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Methods

#pragma mark - Instance Methods

// receive notification
- (void)progressConnection:(NSNotification *)notification{
    
    //NSLog(@"progressConnection : %@", [notification object]);
    float value = ([[notification object] floatValue]);
    
    CustomLoading *custom = [CustomLoading getInstance];
    editBarButtonItem.enabled = NO;
    
    if(value == 1.0){
        //NSLog(@"equal...");
      custom.numImages--;
      if(custom.numImages <= 0){
        [custom stopAnimatingWithView:self.view];
        editBarButtonItem.enabled = YES;
      }
    }else{
        //NSLog(@"less...");
        [custom startAnimatingWithProgress:(int)(value * 25) withView:self.view];
    }
    
}

- (void) addPhoto
{
  [self doneAndSave: NO];
  [addPhotoActionSheet showInView: self.view];
}

- (void) createFakeImages
{
  NSArray *imageNames = @[
    @"intro_still_image_slide_1_background.jpg",
    @"intro_still_image_slide_2_background.jpg",
    @"intro_still_image_slide_3_background.jpg",
    @"intro_still_image_slide_4_background.jpg",
    @"tommy_d.png",
    @"edward_d.jpg",
    @"intro_contact_view_background.jpg",
    @"intro_favorites_view_background.jpg",
    @"map_background.png", 
    @"stopwatch_image.png",
    @"favorite_pink.png"
  ];
  for (NSString *string in imageNames) {
    // Used for fake photos
    // [residenceImages addObject: [UIImage imageNamed: string]];
  }
}

- (void) createResidenceImageWithDictionary: (NSDictionary *) dictionary
{
    
  NSString *absoluteString = [NSString stringWithFormat: @"%f",
    [[NSDate date] timeIntervalSince1970]];
  UIImage *image = [dictionary objectForKey: 
    UIImagePickerControllerOriginalImage];

  int position = 0;
  NSArray *array = [residence imagesArray];
  if ([array count]) {
    OMBResidenceImage *previousResidenceImage = [array objectAtIndex:
      [array count] - 1];
    position = previousResidenceImage.position + 1;
  }

  CGSize newSize = CGSizeMake(640.0f, 320.0f);
  image = [UIImage image: image proportionatelySized: newSize];

  OMBResidenceImage *residenceImage = [[OMBResidenceImage alloc] init];
  residenceImage.absoluteString = absoluteString;
  residenceImage.image    = image;
  residenceImage.position = position;
  residenceImage.uid      = -999 + arc4random_uniform(100);

  [residence addResidenceImage: residenceImage];

  // Upload image
  OMBResidenceUploadImageConnection *conn = 
    [[OMBResidenceUploadImageConnection alloc] initWithResidence: residence 
      residenceImage: residenceImage];
  [conn start];
}

- (void) createViewsFromImages
{
  for (OMBResidenceImage *residenceImage in [residence imagesArray]) {
    OMBEditablePhotoView *imageView = [[OMBEditablePhotoView alloc] init];
    if (residenceImage.imageURL) {
      __weak typeof(imageView) weakImageView = imageView;
      [imageView.imageView setImageWithURL: residenceImage.imageURL 
        placeholderImage: nil options: SDWebImageRetryFailed completed:
          ^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image)
              weakImageView.image = image;
            else
              weakImageView.image = residenceImage.image;
          }
        ];
    }
    else {
      imageView.image = residenceImage.image;
    }
    imageView.residenceImage = residenceImage;
    [imageView.deleteButton addTarget: self action: @selector(deleteImageView:)
      forControlEvents: UIControlEventTouchUpInside];
    [imageViews addObject: imageView];
  }
}

- (void) deleteImageView
{
  int index = currentImageViewIndexSelected;
  OMBEditablePhotoView *imageView = [imageViews objectAtIndex: index];
  [UIView animateWithDuration: 0.25f animations: ^{
    imageView.alpha = 0.0f;
    imageView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
  } completion: ^(BOOL finished) {

    OMBResidenceImage *residenceImage = [[residence imagesArray] objectAtIndex: 
      index];
    // Delete it from the web server
    OMBResidenceImageDeleteConnection *conn = 
      [[OMBResidenceImageDeleteConnection alloc] initWithResidenceImage: 
        residenceImage];
    [conn start];
    // Remove the residence image from the residences' images
    [residence removeResidenceImage: residenceImage];
    // Remove the view from the scroll view
    [imageView removeFromSuperview];
    // Remove the view from the image views array
    [imageViews removeObjectAtIndex: index];

    [self updateTitle];

    [self repositionImageViewsFromIndex: index toIndex: [imageViews count] - 1];
  }];
  currentImageViewIndexSelected = 0;
}

- (void) deleteImageView: (UIButton *) button
{
  currentImageViewIndexSelected = button.tag;
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: 
    @"Delete photo" message: @"Are you sure?" delegate: self
      cancelButtonTitle: @"No" otherButtonTitles: @"Yes", nil];
  [alertView show];
}

- (void) doneAndSave: (BOOL) save
{
  [self.navigationItem setRightBarButtonItem: editBarButtonItem animated: YES];
  // Stop wobble
  CGFloat duration = 0.25f;
  for (OMBEditablePhotoView *itemView in imageViews) {
    [[itemView layer] removeAnimationForKey: @"transformRotationAnimation"];
    // Hide the delete button
    [UIView animateWithDuration: duration animations: ^{
      itemView.deleteButton.hidden = YES;
      itemView.deleteButtonView.alpha = 0.0f;
      itemView.isEditing = NO;
      [self positionImageView: itemView animated: YES];
      // itemView.transform = CGAffineTransformIdentity;
    }];
    itemView.residenceImage.position = [imageViews indexOfObject: itemView];

    if (save) {
      // Save the positions of the images
      [[[OMBResidenceImageUpdateConnection alloc] initWithResidenceImage:
        itemView.residenceImage] start];
    }

    // [UIView animateWithDuration: duration delay: 0.0
    //   options: (UIViewAnimationOptionAllowUserInteraction | 
    //     UIViewAnimationOptionBeginFromCurrentState | 
    //       UIViewAnimationOptionCurveLinear)
    //     animations: ^{
    //       itemView.transform = CGAffineTransformIdentity;
    //     }
    //   completion: nil];
  }
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat maxColumns   = 3.0f;
  CGFloat coverPhotoHeight = screenHeight * 0.4f;
  CGFloat spacing      = 3.0f;
  CGFloat imageHeight  = screenHeight * 0.15f;
  [UIView animateWithDuration: duration animations: ^{
    scroll.contentSize = CGSizeMake(scroll.frame.size.width,
      coverPhotoHeight + ((spacing + imageHeight) * 
        ([imageViews count] + 1) / maxColumns));
  }];

  // Clear the residences coverPhotoSizeDictionary
  [residence.coverPhotoSizeDictionary removeAllObjects];
  [residence updateCoverPhotoURL];
}

- (void) edit
{
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];
  // Start wobble
  for (OMBEditablePhotoView *itemView in imageViews) {
    [self startWobblingView: itemView];
  }
}

- (NSInteger) numberOfImageViews
{
  return [imageViews count];
}

- (void) positionImageView: (OMBEditablePhotoView *) imageView 
animated: (BOOL) animated
{
  int index = [imageViews indexOfObject: imageView];

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat maxColumns   = 3.0f;
  CGFloat coverPhotoHeight = screenHeight * 0.4f;
  CGFloat spacing      = 3.0f;
  CGFloat imageHeight  = screenHeight * 0.15f;
  CGFloat imageWidth   = (screenWidth / maxColumns) - 
    ((spacing * 2) / maxColumns);

  CGSize largeSize = CGSizeMake(screenWidth, coverPhotoHeight);
  CGSize smallSize = CGSizeMake(imageWidth, imageHeight);
  CGRect rect = CGRectZero;
  // Cover photo
  if (index == 0) {
    rect = CGRectMake(0.0f, 0.0f, largeSize.width, largeSize.height);
  }
  // Every other photo
  else {
    // Example: first image that is not the cover photo (index = 1)
    // row = 0
    // column = 0
    int row = (index - 1) / 3;
    int column = (index - 1) % 3;
    rect = CGRectMake((spacing + imageWidth) * column, 
      coverPhotoHeight + spacing + ((spacing + imageHeight) * row), 
        smallSize.width, smallSize.height);
  }
  imageView.currentIndex = index;
  imageView.delegate = self;
  imageView.deleteButton.tag = index;
  imageView.image = imageView.image;
  // Needs to know these sizes for repositioning
  imageView.largeSize = largeSize;
  imageView.smallSize = smallSize;
  // Add to the scroll view
  [scroll addSubview: imageView];
  CGFloat duration = 0.0f;
  if (animated)
    duration = 0.25f;
  [UIView animateWithDuration: duration animations: ^{
    // imageView.transform = CGAffineTransformIdentity;
    // Changing the frame to reposition it
    // but need to change the bounds to put its size back to normal
    imageView.frame = rect;
    imageView.bounds = CGRectMake(imageView.bounds.origin.x,
      imageView.bounds.origin.y, rect.size.width, rect.size.height);
  }];
  // If there are 4 photos, there is only 1 row
  // If there are 5 photos, there are 2 rows
  // The adding 1 to images count is for the cover photo
  CGSize newScrollContentSize = CGSizeMake(scroll.frame.size.width,
    coverPhotoHeight + ((spacing + imageHeight) * 
      ([imageViews count] + 1) / maxColumns) + 
      20.0f + addPhotoButtonView.frame.size.height + 20.0f);
  if (newScrollContentSize.height > scroll.contentSize.height)
    scroll.contentSize = newScrollContentSize;
}

- (void) rearrangeImageViewsWithImageView: (OMBEditablePhotoView *) imageView
{
  int oldIndex = [imageViews indexOfObject: imageView];
  int newIndex = imageView.currentIndex;
  
  [imageViews removeObject: imageView];
  [imageViews insertObject: imageView atIndex: newIndex];

  // Moved lower on the screen, higher position numerically
  if (newIndex > oldIndex) {
    NSLog(@"%i > %i", newIndex, oldIndex);
    [self repositionImageViewsFromIndex: oldIndex toIndex: newIndex - 1];
  }
  // Moved higher up on the screen, lower position numerically
  else if (newIndex < oldIndex) {
    NSLog(@"%i < %i", newIndex, oldIndex);
    [self repositionImageViewsFromIndex: newIndex + 1 toIndex: oldIndex];
  }
  // Didn't move at all
  else {

  }
}

- (void) reloadPhotosAnimated: (BOOL) animated
{
  // Reset the image views array
  imageViews = [NSMutableArray array];

  // Remove all editable photo views from the scroll view
  [scroll.subviews enumerateObjectsUsingBlock: 
    ^(id obj, NSUInteger idx, BOOL *stop) {
      if ([obj isKindOfClass: [OMBEditablePhotoView class]]) {
        [(OMBEditablePhotoView *) obj removeFromSuperview];
      }
    }
  ];
  // Create editable photo view from the images array
  [self createViewsFromImages];

  // Add the editable photo view to the scroll view
  // and position them
  for (OMBEditablePhotoView *imageView in imageViews) {
    [self positionImageView: imageView animated: animated];
  }

  if ([[residence imagesArray] count])
    editBarButtonItem.enabled = YES;
  else
    editBarButtonItem.enabled = NO;
}

- (void) repositionImageViewsFromIndex: (int) startingIndex
toIndex: (int) endingIndex
{
  for (int i = startingIndex; i < endingIndex + 1; i++) {
    OMBEditablePhotoView *imageV = [imageViews objectAtIndex: i];
    imageV.currentIndex = i;
    [self positionImageView: imageV animated: YES];
  }
}

- (void) save
{
  [self doneAndSave: YES];
}

- (void) startWobblingView: (OMBEditablePhotoView *) itemView
{
  int index = [scroll.subviews indexOfObject: itemView];
  CGFloat duration = 0.25f;
  // Show the delete button
  [UIView animateWithDuration: duration animations: ^{
    itemView.deleteButton.hidden = NO;
    itemView.deleteButtonView.alpha = 1.0f;
    itemView.isEditing = YES;
  }];

  CGFloat delay = 0.0f;
  if (index % 2)
    delay = 0.1f;
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:
    @"transform.rotation"];
  animation.autoreverses = YES;
  animation.beginTime    = delay;
  animation.duration     = duration;
  animation.fromValue = [NSNumber numberWithFloat: DEGREES_TO_RADIANS(1.0)];
  animation.toValue = [NSNumber numberWithFloat: DEGREES_TO_RADIANS(-1.0)];
  animation.repeatCount  = HUGE_VALF;

  [[itemView layer] addAnimation: animation 
    forKey: @"transformRotationAnimation"];

  // // Tilt it counter-clockwise
  // itemView.transform = CGAffineTransformRotate(
  //   CGAffineTransformIdentity, DEGREES_TO_RADIANS(-2.5));
  // // itemView.transform = CGAffineTransformRotate(
  // //   itemView.transform, DEGREES_TO_RADIANS(-2.5));
  // CGFloat delay = 0.0f;
  // if (index % 2)
  //   delay = 0.1f;
  // // Animate the wobbling
  // [UIView animateWithDuration: duration delay: delay
  //   options: (UIViewAnimationOptionAllowUserInteraction | 
  //     UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
  //     animations: ^{
  //       // Swing it clockwise, back the other direction
  //       itemView.transform = CGAffineTransformRotate(
  //         CGAffineTransformIdentity, DEGREES_TO_RADIANS(2.5));
  //       // itemView.transform = CGAffineTransformRotate(itemView.transform,
  //       //   DEGREES_TO_RADIANS(2.5));
  //     }
  //     completion: nil];
}

- (void) updateTitle
{
  int count = [[residence imagesArray] count];
  NSString *photosTitleString = @"Photos";
  if (count == 1)
    photosTitleString = @"Photo";
  if (count > 0)
    self.title = [NSString stringWithFormat: @"%i %@", count, 
      photosTitleString];
  else
    self.title = @"Photos";
}

@end
