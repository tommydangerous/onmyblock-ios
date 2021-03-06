//
//  OMBFinishListingPhotosViewController.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBViewController.h"

#import "ELCImagePickerController.h"

@class AMBlurView;
@class OMBEditablePhotoView;

@interface OMBFinishListingPhotosViewController : OMBViewController
<ELCImagePickerControllerDelegate, UIActionSheetDelegate, 
UINavigationControllerDelegate, UIImagePickerControllerDelegate, 
UIScrollViewDelegate>
{
  UIActionSheet *addPhotoActionSheet;
  UIButton *addPhotoButton;
  AMBlurView *addPhotoButtonView;
  int currentImageViewIndexSelected;
  UIBarButtonItem *editBarButtonItem;
  NSMutableArray *imageViews;
  BOOL isEditing;
  OMBResidence *residence;
  // Used for fake photos
  // NSMutableArray *residenceImages;
  UIScrollView *scroll;
}

@property (nonatomic, strong) OMBEditablePhotoView *dragObject;
@property (nonatomic, strong) IBOutlet UIView *dropTarget;
@property (nonatomic, assign) CGPoint homePosition;
@property (nonatomic, assign) CGPoint touchOffset;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

- (NSInteger) numberOfImageViews;
- (void) rearrangeImageViewsWithImageView: (OMBEditablePhotoView *) imageView;
- (void) repositionImageViewsFromIndex: (int) startingIndex
toIndex: (int) endingIndex;

@end
