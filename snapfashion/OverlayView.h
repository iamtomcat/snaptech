//
//  OverlayView.h
//  snapfashion
//
//  Created by Tom Clark on 2014-09-26.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPUImageView,DiagView;

@interface OverlayView : UIViewController
@property (nonatomic,weak) IBOutlet GPUImageView *filteredVideoView;
@property (nonatomic,weak) IBOutlet DiagView *bottomView;
@end
