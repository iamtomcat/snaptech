//
//  OverlayView.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-26.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "OverlayView.h"
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"
#import "DiagView.h"

@interface OverlayView () {
  GPUImageVideoCamera *camera;
  GPUImageBuffer *_videoBuffer;
  CGSize screenSize;
}
@end

@implementation OverlayView

- (void)viewDidLoad {
  [super viewDidLoad];
  screenSize = [[UIScreen mainScreen] bounds].size;
  [self initVideoView];
  [self initBottomHalf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initVideoView {
  camera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPresetMedium cameraPosition:AVCaptureDevicePositionBack];
  camera.outputImageOrientation = UIInterfaceOrientationPortrait;
  
  GPUImageFilter *gaussFilter = [[GPUImageiOSBlurFilter alloc] init];
  
  self.filteredVideoView.fillMode = kGPUImageFillModeStretch;
  
  _videoBuffer = [[GPUImageBuffer alloc] init];
  [_videoBuffer setBufferSize:1];
  
  [camera addTarget:_videoBuffer];
  [camera addTarget:gaussFilter];
  [gaussFilter addTarget:self.filteredVideoView];
  
  [camera startCameraCapture];
}

- (void) initBottomHalf {
  self.bottomView.backgroundColor = [UIColor clearColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
