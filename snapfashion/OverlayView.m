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
#import "ImagePickerController.h"
#import "StyleTableController.h"

@interface OverlayView () {
  GPUImageVideoCamera *videoCamera;
  GPUImageBuffer *_videoBuffer;
  CGSize screenSize;
  ImagePickerController *camera;
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
  videoCamera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPresetMedium cameraPosition:AVCaptureDevicePositionBack];
  videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
  
  GPUImageFilter *gaussFilter = [[GPUImageiOSBlurFilter alloc] init];
  
  self.filteredVideoView.fillMode = kGPUImageFillModeStretch;
  
  _videoBuffer = [[GPUImageBuffer alloc] init];
  [_videoBuffer setBufferSize:1];
  
  [videoCamera addTarget:_videoBuffer];
  [videoCamera addTarget:gaussFilter];
  [gaussFilter addTarget:self.filteredVideoView];
  
  [videoCamera startCameraCapture];
}

- (void) initBottomHalf {
  self.bottomView.backgroundColor = [UIColor clearColor];
}

- (void) startVideo {
  [self initVideoView];
}

- (IBAction) handleSnapButton:(id)sender {
  if (camera==nil) {
    camera = [ImagePickerController alloc];
  }
  [videoCamera stopCameraCapture];
  [camera initCamera:self];
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
