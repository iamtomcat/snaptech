//
//  ImagePickerController.h
//  snapfashion
//
//  Created by Tom Clark on 2014-09-07.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagePickerController : NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (BOOL) initCamera: (id) delegate;
@end
