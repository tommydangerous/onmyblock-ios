//
//  CustomLoading.m
//  CustomActivityAnimation
//
//  Created by Paul Aguilar on 1/17/14.
//  Copyright (c) 2014 teclalabs. All rights reserved.
//

#import "CustomLoading.h"
#import "DRNRealTimeBlurView.h"

@implementation CustomLoading

static CustomLoading *customLoading =nil;

+(id)getInstance
{
    @synchronized(self)
    {
        if(customLoading==nil)
        {
            customLoading= [CustomLoading new];
        }
    }
    return customLoading;
}

- (void)clearInstance{
    customLoading = nil;
}

- (void)startAnimatingWithProgress:(int)progress withView:(UIView *)view{
    
    if(!self.imageView){
        NSLog(@"first");
        CGSize size = view.frame.size;
        
        // gray background
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [self.imageView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
        
        // Blur
        /*DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] init];
        [blurView setFrame:CGRectMake(0, 0, size.widt	h, size.height)];
        blurView.renderStatic = YES;
        [self.imageView addSubview: blurView];*/
        
        // white view
        UIImageView *whiteBackground= [[UIImageView alloc] initWithFrame:CGRectMake((size.width - 497/2)/2, size.height * 0.3, 497/2, 489/2)];
        [whiteBackground setBackgroundColor:[UIColor clearColor]];
        [whiteBackground setImage:[UIImage imageNamed:@"backgroundLoading.png"]];
        [self.imageView addSubview:whiteBackground];
        
        // loading's Animation
        UIImageView *loading = [[UIImageView alloc] init];
        loading.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"1" ofType:@"png"]];
        [loading  setBackgroundColor:[UIColor clearColor]];
        CGFloat sizeWidthLoading = 105;
        CGFloat sizeHeightLoading = 149.5;
        [loading  setFrame:CGRectMake((self.imageView.bounds.size.width - sizeWidthLoading)/2, (self.imageView.bounds.size.height - sizeHeightLoading)/2, sizeWidthLoading, sizeHeightLoading)];
        loading.tag = 11;
        [self.imageView addSubview:loading];
        
        // label : Loading...
        UIImageView *loadingLabel = [[UIImageView alloc] initWithFrame:CGRectMake((size.width - 150/2)/2, self.imageView.bounds.size.height * 0.66, 150/2, 33/2)];
        [loadingLabel setBackgroundColor:[UIColor clearColor]];
        [loadingLabel setImage:[UIImage imageNamed:@"loadingLabel.png"]];
        loadingLabel.tag = 22;
        [self.imageView addSubview:loadingLabel];
        
        // show view
        [view addSubview:self.imageView];
        
    }
    
    if(progress < 25 && progress > 0){
        /*self.imageView = nil;
         [self.imageView removeFromSuperview];*/
        
        if(self.imageView){
            
            UIImageView *progressImage = (UIImageView *)[self.imageView viewWithTag:11];
            [progressImage removeFromSuperview];
            
            // loading's Animation
            UIImageView *loading = [[UIImageView alloc] init];
            loading.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:
                                                              [NSString stringWithFormat:@"%i",progress] ofType:@"png"]];
            [loading  setBackgroundColor:[UIColor clearColor]];
            CGFloat sizeWidthLoading = 105;
            CGFloat sizeHeightLoading = 149.5;
            [loading  setFrame:CGRectMake((self.imageView.bounds.size.width - sizeWidthLoading)/2, (self.imageView.bounds.size.height - sizeHeightLoading)/2, sizeWidthLoading, sizeHeightLoading)];
            loading.tag = 11;
            [self.imageView addSubview:loading];
            
        }
    }
}

- (void)stopAnimatingWithView:(UIView *)view
{
	if(self.imageView)
	{
        NSLog(@"stop....");
        
        UIImageView *viewShouldRemove = (UIImageView *)[self.imageView viewWithTag:11];
        [viewShouldRemove removeFromSuperview];
        viewShouldRemove = (UIImageView *)[self.imageView viewWithTag:22];
        [viewShouldRemove removeFromSuperview];
        
        // remove animation
		/*[self.imageView removeFromSuperview];
		self.imageView = nil;*/
        
        // changing view to complete
       /* self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screen.size.width - 497/2)/2, screen.size.height * 0.3, 497/2, 489/2)];
        [self.imageView setBackgroundColor:[UIColor clearColor]];
        [self.imageView setImage:[UIImage imageNamed:@"backgroundLoading.png"]];*/
        
        // label : Complete!
        UIImageView *completeLabel = [[UIImageView alloc] initWithFrame:CGRectMake((self.imageView.bounds.size.width - 156/2)/2,  self.imageView.bounds.size.height * 0.62, 156/2, 33/2)];
        [completeLabel setBackgroundColor:[UIColor clearColor]];
        [completeLabel setImage:[UIImage imageNamed:@"completeLabel.png"]];
        [self.imageView addSubview:completeLabel];
        
        // add image check
        UIImageView *completeImage = [[UIImageView alloc] init];
        [completeImage  setBackgroundColor:[UIColor clearColor]];
        completeImage.image = [UIImage imageNamed:@"completeLoading"];
        CGFloat sizeWidthLoading = 167/2;
        [completeImage  setFrame:CGRectMake((self.imageView.bounds.size.width - sizeWidthLoading)/2, (self.imageView.bounds.size.height - sizeWidthLoading+0.5)/2, sizeWidthLoading, sizeWidthLoading+0.5)];
        [self.imageView addSubview:completeImage];
        
        //[view addSubview:self.imageView];
        
        // fades it away after 1.5 seconds
        [UIView animateWithDuration:0.2 delay:1.0 options:0 animations:^{
            self.imageView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
            self.imageView = nil;
            [self.imageView removeFromSuperview];
        }];
    }
}

@end