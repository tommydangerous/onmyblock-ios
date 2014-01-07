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

@interface OMBFinishListingPhotosViewController : OMBViewController
<ELCImagePickerControllerDelegate, UIActionSheetDelegate, 
UINavigationControllerDelegate, UIImagePickerControllerDelegate, 
UIScrollViewDelegate>
{
  UIActionSheet *addPhotoActionSheet;
  UIButton *addPhotoButton;
  AMBlurView *addPhotoButtonView;
  int currentImageViewIndexSelected;
  UIBarButtonItem *doneBarButtonItem;
  UIBarButtonItem *editBarButtonItem;
  NSMutableArray *images;
  NSMutableArray *imageViews;
  BOOL isEditing;
  OMBResidence *residence;
  UIScrollView *scroll;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

#pragma mark - Methods

#pragma mark - Instance Methods

@end
