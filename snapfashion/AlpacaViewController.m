//
//  AlpacaViewController.m
//  snapfashion
//
//  Created by Tom Clark on 2014-09-28.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

#import "AlpacaViewController.h"

@interface AlpacaViewController ()

@end

@implementation AlpacaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressImage:(id)sender {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
