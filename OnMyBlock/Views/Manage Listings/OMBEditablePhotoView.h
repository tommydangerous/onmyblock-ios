//
//  OMBEditablePhotoView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/28/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCenteredImageView.h"

@interface OMBEditablePhotoView : OMBCenteredImageView
{
  UIView *backSlash;
  UIView *forwardSlash;
}

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *deleteButtonView;

@end
