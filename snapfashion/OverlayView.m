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
  self.bottomView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Initialize video playback
- (void) initVideoView {
  videoCamera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPresetMedium cameraPosition:AVCaptureDevicePositionBack];
  videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
  
  //Setup Gaussian filter
  GPUImageFilter *gaussFilter = [[GPUImageGaussianBlurFilter alloc]init];
  [(GPUImageGaussianBlurFilter *)gaussFilter setBlurRadiusInPixels:10.0f];
  
  self.filteredVideoView.fillMode = kGPUImageFillModeStretch;
  
  _videoBuffer = [[GPUImageBuffer alloc] init];
  [_videoBuffer setBufferSize:1];
  
  [videoCamera addTarget:_videoBuffer];
  [videoCamera addTarget:gaussFilter];
  [gaussFilter addTarget:self.filteredVideoView];
  
  [videoCamera startCameraCapture];
}

//Function for starting the video again when coming back from the camera.
- (void) startVideo {
  [self initVideoView];
}

//Open camera view
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
