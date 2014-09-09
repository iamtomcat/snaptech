//
//  InstagramHandler.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-06.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "InstagramHandler.h"
#define APIKEY @"0dfe851fbea94d90b3e8ba76f71ddb6a"

UIImageView *tempView;

@interface InstagramHandler ()
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation InstagramHandler
@synthesize session;

//First call to grab the json for the image links
-(void) getTagData:(NSString *) tag{
  //Simplify the resolution sizes instead of having to remember the formatting
  NSDictionary *resolutions = @{@"thumb":@"thumbnail",@"reg":@"standard_resolution",@"low":@"low_resolution"};
  //The urlstring to grab the tag information.
  NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@",tag,APIKEY];
  
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLSessionConfiguration *urlConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
  session = [NSURLSession sessionWithConfiguration:urlConfig];
  //Call to grab json data
  [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSError *theError = nil;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&theError];
    
    //Pull out URLs for grabbing images
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *dict in jsonData[@"data"]) {
      NSString *imageUrl = dict[@"images"][resolutions[@"low"]][@"url"];
      [imageArray addObject:imageUrl];
    }
    //Call to grab images
    [self getImages:imageArray];
  }] resume];
}

-(void) getImages:(NSArray *) imageUrls{
  //Call the delegate to create uitableviewcells before the images are loaded.
  [[self delegate] prepareForData:(int)[imageUrls count]];
  
  //Make calls to grab images.
  for (NSString *imageUrl in imageUrls) {
    [[session downloadTaskWithURL:[NSURL URLWithString:imageUrl] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
      UIImage *temp = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
      //Call back to delegate with image
      [[self delegate] updateImageData:temp];
    }] resume];
  }
}

@end
