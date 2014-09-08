//
//  InstagramHandler.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-06.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "InstagramHandler.h"

UIImageView *tempView;

@interface InstagramHandler ()
@end

@implementation InstagramHandler

-(void) getTagData:(NSString *) tag{
  //Simplify the resolution sizes instead of having to remember the formatting
  NSDictionary *resolutions = @{@"thumb":@"thumbnail",@"reg":@"standard_resolution",@"low":@"low_resolution"};
  //The urlstring to grab the tag information.
  NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=0dfe851fbea94d90b3e8ba76f71ddb6a",tag];
  
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLSessionConfiguration *urlConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:urlConfig];
  [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSError *theError = nil;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&theError];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *dict in jsonData[@"data"]) {
      NSString *imageUrl = dict[@"images"][resolutions[@"low"]][@"url"];
      NSLog(@"%@",imageUrl);
      [imageArray addObject:imageUrl];
    }
    [self getImages:imageArray];
  }] resume];
}

-(void) getImages:(NSArray *) imageUrls{
  NSURLSession *imageSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  
  [[self delegate] prepareForData:[imageUrls count]];
  
  for (NSString *imageUrl in imageUrls) {
    NSLog(@"urls are %@",imageUrl);
    [[imageSession downloadTaskWithURL:[NSURL URLWithString:imageUrl] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
      UIImage *temp = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
      [[self delegate] updateImageData:temp];
    }] resume];
  }
}

@end
