//
//  StyleTableController.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-07.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "StyleTableController.h"
#import "InstagramHandler.h"
#import "ImagePickerController.h"

@interface StyleTableController () {
  ImagePickerController *camera;
  NSMutableArray *Images;
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section==0 || section==2) {
    return 1;
  }
  
  // Return the number of rows in the section.
  return [Images count];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (true) {
    return [[UIScreen mainScreen] bounds].size.height/2.0f;
  }
  return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section==0) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNAP" forIndexPath:indexPath];
    return cell;
  } else if (indexPath.section==2) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HASH" forIndexPath:indexPath];
    return cell;
  }
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
  
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
    InstagramHandler *igHandler = [InstagramHandler alloc];
    [igHandler getTagData:@"streetstyle"];
    //[igHandler setViewImages:self.imageView];
  }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
