//
//  OMBIntroBidView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBPaddleView;

@interface OMBIntroBidView : UIView

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) OMBPaddleView *paddleView1;
@property (nonatomic, strong) OMBPaddleView *paddleView2;
@property (nonatomic, strong) OMBPaddleView *paddleView3;

@end
