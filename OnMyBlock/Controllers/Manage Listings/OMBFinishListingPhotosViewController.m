//
//  OMBFinishListingPhotosViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBFinishListingPhotosViewController.h"

#import "AMBlurView.h"
#import "OMBEditablePhotoView.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@implementation OMBFinishListingPhotosViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  images     = [NSMutableArray array];
  imageViews = [NSMutableArray array];
  residence  = object;

  [self createFakeImages];

  self.screenName = @"Photos";
  self.title      = @"Photos";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Done"
    style: UIBarButtonItemStylePlain target: self action: @selector(done)];
  editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Edit"
    style: UIBarButtonItemStylePlain target: self action: @selector(edit)];
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

  [self updateTitle];

  imageViews = [NSMutableArray array];
  [scroll.subviews enumerateObjectsUsingBlock: 
    ^(id obj, NSUInteger idx, BOOL *stop) {
      if ([obj isKindOfClass: [OMBEditablePhotoView class]]) {
        [(OMBEditablePhotoView *) obj removeFromSuperview];
      }
    }
  ];
  [self createViewsFromImages];
  for (OMBEditablePhotoView *imageView in imageViews) {
    [self positionImageView: imageView animated: NO];
  }
}

#pragma mark - Protocol

#pragma mark - Protocol ELCImagePickerControllerDelegate

- (void) elcImagePickerController: (ELCImagePickerController *) picker
didFinishPickingMediaWithInfo: (NSArray *) info
{
  for (NSDictionary *dict in info) {
    [images addObject: 
      [dict objectForKey: UIImagePickerControllerOriginalImage]];
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
  [images addObject: [info objectForKey: UIImagePickerControllerOriginalImage]];
  [picker dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addPhoto
{
  [self done];
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
    [images addObject: [UIImage imageNamed: string]];
  }
}

- (void) createViewsFromImages
{
  for (UIImage *image in images) {
    OMBEditablePhotoView *imageView = [[OMBEditablePhotoView alloc] init];
    imageView.image = image;
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
    // Remove the view from the scroll view
    [imageView removeFromSuperview];
    // Remove the view from the image views array
    [imageViews removeObjectAtIndex: index];
    // Remove the image from the images array
    [images removeObjectAtIndex: index];
    [self updateTitle];
    for (int i = index; i < [imageViews count]; i++) {
      OMBEditablePhotoView *imageV = [imageViews objectAtIndex: i];
      [self positionImageView: imageV animated: YES];
    }
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

- (void) done
{
  [self.navigationItem setRightBarButtonItem: editBarButtonItem animated: YES];
  // Stop wobble
  CGFloat duration = 0.25f;
  for (OMBEditablePhotoView *itemView in imageViews) {
    // Hide the delete button
    [UIView animateWithDuration: duration animations: ^{
      itemView.deleteButtonView.alpha = 0.0f;
    }];
    [UIView animateWithDuration: duration delay: 0.0
      options: (UIViewAnimationOptionAllowUserInteraction | 
        UIViewAnimationOptionBeginFromCurrentState | 
          UIViewAnimationOptionCurveLinear)
        animations: ^{
          itemView.transform = CGAffineTransformIdentity;
        }
      completion: nil];
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
}

- (void) edit
{
  [self.navigationItem setRightBarButtonItem: doneBarButtonItem animated: YES];
  // Start wobble
  for (OMBEditablePhotoView *itemView in imageViews) {
    [self startWobblingView: itemView];
  }
}

- (void) positionImageView: (OMBEditablePhotoView *) imageView 
animated: (BOOL) animated
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat maxColumns   = 3.0f;
  CGFloat coverPhotoHeight = screenHeight * 0.4f;
  CGFloat spacing      = 3.0f;
  CGFloat imageHeight  = screenHeight * 0.15f;
  CGFloat imageWidth   = (screenWidth / maxColumns) - 
    ((spacing * 2) / maxColumns);
  int index = [imageViews indexOfObject: imageView];
  CGRect rect = CGRectZero;
  // Cover photo
  if (index == 0) {
    rect = CGRectMake(0.0f, 0.0f, screenWidth, coverPhotoHeight);
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
        imageWidth, imageHeight);
  }
  imageView.deleteButton.tag = index;
  imageView.image = imageView.image;
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
      ([imageViews count] + 1) / maxColumns));
  if (newScrollContentSize.height > scroll.contentSize.height)
    scroll.contentSize = newScrollContentSize;
}

- (void) startWobblingView: (OMBEditablePhotoView *) itemView
{
  int index = [scroll.subviews indexOfObject: itemView];
  CGFloat duration = 0.25f;
  // Show the delete button
  [UIView animateWithDuration: duration animations: ^{
    itemView.deleteButtonView.alpha = 1.0f;
  }];
  // Tilt it counter-clockwise
  itemView.transform = CGAffineTransformRotate(
    CGAffineTransformIdentity, DEGREES_TO_RADIANS(-2.5));
  CGFloat delay = 0.0f;
  if (index % 2)
    delay = 0.1f;
  // Animate the wobbling
  [UIView animateWithDuration: duration delay: delay
    options: (UIViewAnimationOptionAllowUserInteraction | 
      UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
      animations: ^{
        // Swing it clockwise, back the other direction
        itemView.transform = CGAffineTransformRotate(
          CGAffineTransformIdentity, DEGREES_TO_RADIANS(2.5));
      }
      completion: nil];
}

- (void) updateTitle
{
  NSString *photosTitleString = @"Photos";
  if ([images count] == 1)
    photosTitleString = @"Photo";
  if ([images count] > 0)
    self.title = [NSString stringWithFormat: @"%i %@", [images count],
      photosTitleString];
  else
    self.title = @"Photos";
}

@end
