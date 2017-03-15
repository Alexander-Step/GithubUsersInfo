//
//  UsersSearchTableViewController.h
//  GithubUsersInfo
//
//  Created by Alexander on 15.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GithubUser.h"
#import "UserTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@class UsersTableViewController;

@interface UsersSearchTableViewController : UITableViewController 

@property (nonatomic, weak) UsersTableViewController *usersTVC;
@property (nonatomic, strong) NSArray *searchResults;

@end
