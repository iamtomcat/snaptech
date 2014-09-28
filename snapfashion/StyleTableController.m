//
//  StyleTableController.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-07.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "StyleTableController.h"
#import "ImagePickerController.h"
#import "ImageCell.h"

#define SMALLBUTTON_HEIGHT 60.0f

@interface StyleTableController () {
  ImagePickerController *camera;
  InstagramHandler *igHandler;
  NSMutableArray *Images;
  BOOL clicked;
  int addCount;
  int numImages;
  CGPoint startPoint;
  UIView *SnapButton, *HashButton;
  BOOL SnapButtonVisible,HashButtonVisible;
}
@end

@implementation StyleTableController

- (void)viewDidLoad {
  [super viewDidLoad];
  Images = [NSMutableArray array];
  clicked = NO;
  addCount = 0;
  numImages = 0;
  startPoint = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Update number of images that are to be loaded
- (void) prepareForData:(int)numOfImages {
  numImages += numOfImages;
  [self.tableView reloadData];
}

//Load image into array and reload the section
- (void) updateImageData:(UIImage *)image {
  NSLog(@"Image updated");
  [Images addObject:image];

  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      //Reload a cell off screen to keep flash from being visible
      [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    });
  });
}

//Helper function for creating the floating buttons at the top and bottom of screen.
- (UILabel *)createButtonLabel:(NSString *)text {
  CGRect newFrame = CGRectMake(91.0f, 16.0f, 138.0f, 32.0f);
  UIFont *newFont = [UIFont boldSystemFontOfSize:35.0f];
  if ([text isEqualToString:@"#"]) {
    newFrame = CGRectMake(147.0f, 10.0f, 26.0f, 44.0f);
    newFont = [UIFont boldSystemFontOfSize:40.0f];
  }
  
  UILabel *temp = [[UILabel alloc] initWithFrame:newFrame];
  temp.text = text;
  temp.font = newFont;
  return temp;
}

//Helper function to make code more readable.
- (BOOL) hashLabelVisible {
  return [HashButton isDescendantOfView:self.tableView.superview];
}

//Handler for hash button
- (void)hashTap:(id)sender {
  [igHandler getTagData:@"streetstyle"];
}

//Add hash button function
- (void)addHashButton {
  if (HashButton==nil) {
    CGRect buttonFrame = [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] frame];
    buttonFrame.size.height = SMALLBUTTON_HEIGHT;
    buttonFrame.origin.y = [[UIScreen mainScreen] bounds].size.height - SMALLBUTTON_HEIGHT;
    NSLog(@"%f",buttonFrame.size.height);
    HashButton = [[UIView alloc] initWithFrame:buttonFrame];
    HashButton.backgroundColor = [UIColor whiteColor];
    
    //Tap recognizer for button
    UITapGestureRecognizer *hashTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hashTap:)];
    [HashButton addGestureRecognizer:hashTap];
    
    UILabel *hashLabel = [self createButtonLabel:@"#"];
    [HashButton addSubview:hashLabel];
  }
  if (![HashButton isDescendantOfView:self.tableView.superview]) {
    [self.tableView.superview addSubview:HashButton];
  }
}

//Used to remove hash button if the related cell is visible on the screen
- (void)removeHashButton {
  NSArray *visIndexes = [self.tableView indexPathsForVisibleRows];
  for (NSIndexPath *index in visIndexes) {
    if (index.row == 0 && index.section==2) {
      if ([HashButton isDescendantOfView:self.tableView.superview]) {
        [HashButton removeFromSuperview];
        break;
      }
    }
  }
}

//Helper function to make code more readable.
- (BOOL) snapLabelVisible {
  return [SnapButton isDescendantOfView:self.tableView.superview];
}

- (void)showButtons {
  if (SnapButtonVisible) {
    [UIView animateWithDuration:0.5f animations:^{
      SnapButton.alpha = 1.0f;
    }];
  }
  if (HashButtonVisible) {
    [UIView animateWithDuration:0.5f animations:^{
      HashButton.alpha = 1.0f;
    }];
  }
}

//open the camera if the floating button is pressed
//check which buttons are actually visible before removing them.
- (void)snapTap:(id)sender {
  if (camera==nil) {
    camera = [ImagePickerController alloc];
  }
  
  SnapButtonVisible = [self snapLabelVisible];
  if (SnapButtonVisible) {
    [UIView animateWithDuration:0.5f animations:^{
      SnapButton.alpha = 0.0f;
    }];
  }
  HashButtonVisible = [self hashLabelVisible];
  if (HashButtonVisible) {
    [UIView animateWithDuration:0.5f animations:^{
      HashButton.alpha = 0.0f;
    }];
  }
  
  [camera initCamera:self];
}


//Add floating button for snap
- (void)addSnapLabel {
  if (SnapButton==nil) {
    SnapButton = [[UIView alloc] initWithFrame:[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] frame]];
    SnapButton.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *snapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(snapTap:)];
    [SnapButton addGestureRecognizer:snapTap];
    
    UILabel *snapLabel = [self createButtonLabel:@"SNAP IT"];
    [SnapButton addSubview:snapLabel];
  }
  
  if (![self snapLabelVisible]) {
    [self.tableView.superview addSubview:SnapButton];
  }
}

//For removing the snap button when scrolling
- (void)removeSnapLabel {
  NSArray *visIndexes = [self.tableView indexPathsForVisibleRows];
  for (NSIndexPath *index in visIndexes) {
    if (index.row == 0 && index.section==0) {
      if ([self snapLabelVisible]) {
        [SnapButton removeFromSuperview];
        break;
      }
    }
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  startPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView.contentOffset.y<startPoint.y && clicked) {
    NSLog(@"down %@",[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]]);
    [self removeSnapLabel];
    [self addHashButton];
  } else if (scrollView.contentOffset.y>startPoint.y && clicked) {
    NSLog(@"up");
    [self addSnapLabel];
    [self removeHashButton];
  }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section==0 || section==2) {
    return 1;
  }
  //Pre create some cells on click
  if (clicked && numImages==0) {
    return 5;
  }
  // Return the number of rows in the section.
  return numImages;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //Initial height of image cells
  if ([Images count]==0 && clicked==NO) {
    return [[UIScreen mainScreen] bounds].size.height/2.0f;
  }
  //Image cell size
  if (indexPath.section==1) {
    return 144.0f;
  }
  //Other cell size
  return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //Load the 3 different cells
  if (indexPath.section==0) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNAP" forIndexPath:indexPath];
    return cell;
  } else if (indexPath.section==2) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HASH" forIndexPath:indexPath];
    return cell;
  }
  ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
  if (indexPath.row<[Images count]) {
    NSLog(@"image %@",[Images objectAtIndex:indexPath.row]);
    
    //Load image into cell
    dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *img = [Images objectAtIndex:indexPath.row];
        
      // Make a trivial (1x1) graphics context, and draw the image into it
      //speed up uiimage loading
      UIGraphicsBeginImageContext(CGSizeMake(1,1));
      CGContextRef context = UIGraphicsGetCurrentContext();
      CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), [img CGImage]);
      UIGraphicsEndImageContext();

      cell.instagramImage.image = img;
      //fade the image in
      [UIView animateWithDuration:0.8f animations:^{
        cell.instagramImage.alpha = 1.0f;
      }];
    });
  }
  return cell;
}

//Handle clicks of the 2 cells for camera and loading of instagram images.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]]) {//Camera
    NSLog(@"Open Camera Button Pressed");
    if (camera==nil) {
      camera = [ImagePickerController alloc];
    }
    [camera initCamera:self];
  } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:2]]) {//Instagram
    NSLog(@"Instagram Button Pressed");
    if (igHandler==nil) {
      igHandler = [InstagramHandler alloc];
      igHandler.delegate = self;
    }
    [self addHashButton];
    clicked=YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
    [igHandler getTagData:@"streetstyle"];
  }
}

@end
