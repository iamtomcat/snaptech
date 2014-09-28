//
//  ImagePickerController.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-07.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "ImagePickerController.h"
#import "StyleTableController.h"
#import "OverlayView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ImagePickerController () {
id controllingView;
}
@end

@implementation ImagePickerController
//Bring up camera overlay
- (BOOL) initCamera: (id) view {
  NSLog(@"%d",[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] );
  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || (view == nil)) {
    return NO;
  }
  
  UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
  imageController.sourceType = UIImagePickerControllerSourceTypeCamera;
  imageController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
  imageController.allowsEditing = NO;
  imageController.delegate = self;
  [view presentViewController:imageController animated:YES completion:^{
    controllingView = view;
  }];
  
  return YES;
}

//Handle closing camera controls.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
  if ([controllingView respondsToSelector:@selector(showButtons)]) {
    [controllingView showButtons];
  }
  [controllingView dismissViewControllerAnimated:YES completion:^{
    if ([controllingView respondsToSelector:@selector(startVideo)]) {
      [controllingView startVideo];
    }
  }];
}

//Handle Saving image
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
  NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
  UIImage *originalImage, *editedImage, *imageToSave;
  
  if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
    editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
      imageToSave = editedImage;
    } else {
      imageToSave = originalImage;
    }
    UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
  }
  
  if ([controllingView respondsToSelector:@selector(showButtons)]) {
    [controllingView showButtons];
  }
  [controllingView dismissViewControllerAnimated:YES completion:nil];
}
@end
