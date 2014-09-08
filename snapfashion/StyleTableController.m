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

@interface StyleTableController () {
  ImagePickerController *camera;
  InstagramHandler *igHandler;
  NSMutableArray *Images;
  BOOL clicked;
  int addCount;
  int numImages;
  CGPoint startPoint;
}
@end

@implementation StyleTableController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  Images = [NSMutableArray array];
  clicked = NO;
  addCount = 0;
  numImages = 0;
  startPoint = CGPointZero;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForData:(int)numOfImages {
  numImages = numOfImages;
  
//  [self.tableView beginUpdates];
//  NSMutableArray *indexPaths = [NSMutableArray array];
//  for (int x=0; x<numImages; x++) {
//    [indexPaths addObject:[NSIndexPath indexPathForRow:x inSection:1]];
//  }
//  [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
//
//  [self.tableView endUpdates];
  [self.tableView reloadData];
  //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void) updateImageData:(UIImage *)image {
  NSLog(@"Image updated");
  [Images addObject:image];

  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      //Reload a cell off screen to keep flash from being visible
      [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    });
  });
  
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  startPoint = scrollView.contentOffset;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView.contentOffset.y<startPoint.y) {
    NSLog(@"down");
    NSArray *visIndexes = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *index in visIndexes) {
      if (index.row == 0 && index.section==0) {
        [[self.tableView.superview viewWithTag:20] removeFromSuperview];
      }
    }
    
  } else if (scrollView.contentOffset.y>startPoint.y) {
    NSLog(@"up");
    NSArray *visIndexes = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *index in visIndexes) {
      if (!(index.row == 0 && index.section==0)) {
        UIView *stickyViewSnap = [[UIView alloc] initWithFrame:[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] frame]];
        stickyViewSnap.tag = 20;
        stickyViewSnap.backgroundColor = [UIColor purpleColor];
        
        [self.tableView.superview addSubview:stickyViewSnap];
      }
    }
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
  if (clicked && numImages==0) {
    return 5;
  }
  NSLog(@"cheese %d", [Images count]);
  // Return the number of rows in the section.
  return numImages;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([Images count]==0 && clicked==NO) {
    return [[UIScreen mainScreen] bounds].size.height/2.0f;
  }
  if (indexPath.section==1) {
    return 144.0f;
  }
  return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section==0) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNAP" forIndexPath:indexPath];
    return cell;
  } else if (indexPath.section==2) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HASH" forIndexPath:indexPath];
    return cell;
  }
  NSLog(@"Called %d %d %d", indexPath.section, indexPath.row,[Images count]);
  ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
  if (indexPath.row<[Images count]) {
    NSLog(@"image %@",[Images objectAtIndex:indexPath.row]);
    
      dispatch_async(dispatch_get_main_queue(), ^{
        ImageCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
        //if (updateCell)
        cell.instagramImage.image = [Images objectAtIndex:indexPath.row];
        [UIView animateWithDuration:0.8f animations:^{
          cell.instagramImage.alpha = 1.0f;
        }];
      });
  }
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]]) {
    NSLog(@"Open Camera Button Pressed");
    if (camera==nil) {
      camera = [ImagePickerController alloc];
    }
    [camera initCamera:self];
  } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:2]]) {
    NSLog(@"Instagram Button Pressed");
    if (igHandler==nil) {
      igHandler = [InstagramHandler alloc];
      igHandler.delegate = self;
    }
    clicked=YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
    [igHandler getTagData:@"streetstyle"];
  }
}

@end
