//
//  UserDescriptionViewController.m
//  GithubUsersInfo
//
//  Created by Alexander on 14.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import "UserDescriptionViewController.h"

@interface UserDescriptionViewController ()

- (void)setUpAllOutlets;

@end

@implementation UserDescriptionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self setUpAllOutlets];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setUpAllOutlets{
  [self.avatarImageView setImageWithURL:self.user.avatarUrl placeholderImage:[UIImage imageNamed:@"gray_square"]];
  self.loginTextField.enabled = NO;
  self.userTypeTextField.enabled = NO;
  self.userIDTextField.enabled = NO;
  self.siteAdminTextField.enabled = NO;
  self.loginTextField.text = self.user.login;
  self.userTypeTextField.text = self.user.userType;
  self.userIDTextField.text = [NSString stringWithFormat:@"%@", self.user.userID];
  BOOL userIsAdmin = [self.user.siteAdmin boolValue];
  if (userIsAdmin){
      self.siteAdminTextField.text = [NSString stringWithFormat:@"YES"];
  } else {
      self.siteAdminTextField.text = [NSString stringWithFormat:@"NO"];
  }
}


 #pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([segue.destinationViewController isKindOfClass:[UserRepositoriesTableViewController class]]){
     UserRepositoriesTableViewController *userRepositoriesTVC = (UserRepositoriesTableViewController*)[segue destinationViewController];
     userRepositoriesTVC.user = self.user;
 }
}


@end
