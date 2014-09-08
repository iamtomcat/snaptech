//
//  ImageCell.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-08.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell
@synthesize instagramImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
  //NSLog(@"blah blah");
  self.backgroundColor = [UIColor blueColor];
  self.instagramImage.alpha = 0.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
