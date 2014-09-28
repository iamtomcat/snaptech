//
//  DiagView.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-27.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "DiagView.h"

@implementation DiagView

//Add the custom shape for the bottom half
//Also add the image for the bottom half in the graphics context
- (void)drawRect:(CGRect)rect {
  // Drawing code
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextBeginPath(ctx);

  //Draw the shape
  CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect)); //Bottom left
  CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect)); //Bottom Right
  CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect)); //Top Right
  CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMidY(rect)); //Mid Left
  
  //Close the shape
  CGContextClosePath(ctx);
  
  CGContextClip(ctx);
  
  CGRect cropRect = CGRectMake(30.0f, 60.0f, rect.size.width*1.9f, rect.size.height*1.9f);
  UIImage *temp = [UIImage imageNamed:@"style.png"];
  CGImageRef imageRef = CGImageCreateWithImageInRect([temp CGImage], cropRect);

  UIImage *outImage = [UIImage imageWithCGImage:imageRef];
  [outImage drawInRect:rect];
}


@end
