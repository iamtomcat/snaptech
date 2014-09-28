//
//  DiagView.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-27.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "DiagView.h"

@implementation DiagView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  // Drawing code
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGContextBeginPath(ctx);

  CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect)); //Bottom left
  CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect)); //Bottom Right
  CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect)); //Top Right
  CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMidY(rect)); //Mid Left
  
  CGContextClosePath(ctx);
  
  CGContextClip(ctx);
  
  CGRect cropRect = CGRectMake(50.0f, 60.0f, rect.size.width*1.8, rect.size.height*1.8);
  UIImage *temp = [UIImage imageNamed:@"style.png"];
  CGImageRef imageRef = CGImageCreateWithImageInRect([temp CGImage], cropRect);

  UIImage *outImage = [UIImage imageWithCGImage:imageRef];
  [outImage drawInRect:rect];
}


@end
