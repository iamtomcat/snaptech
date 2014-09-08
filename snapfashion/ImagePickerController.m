//
//  ImagePickerController.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-07.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "ImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ImagePickerController () {
id controllingView;
}
@end

@implementation ImagePickerController
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

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
  [controllingView dismissViewControllerAnimated:YES completion:nil];
}

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
  
  [controllingView dismissViewControllerAnimated:YES completion:nil];
}
@end
