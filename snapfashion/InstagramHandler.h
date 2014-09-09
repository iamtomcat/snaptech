//
//  InstagramHandler.h
//  snapfashion
//
//  Created by Tom Clark on 2014-09-06.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import <Foundation/Foundation.h>
//Protocol for passing data between tableview and instgramhandler
@protocol ImagePassProtocol <NSObject>
- (void) updateImageData:(UIImage *)image;
- (void) prepareForData:(int)numOfImages;
@end

@interface InstagramHandler : NSObject
-(void) getTagData:(NSString *)tag;

@property (nonatomic,weak) id <ImagePassProtocol> delegate;
@end
