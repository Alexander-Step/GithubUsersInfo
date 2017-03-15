//
//  UserRepositoriesTableViewController.h
//  GithubUsersInfo
//
//  Created by Alexander on 14.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GithubSessionManager.h"
#import "GithubUser.h"
#import "GithubRepository.h"
#import "AFNetworking.h"
#import "INSDefaultPullToRefresh.h"
#import "INSAnimatable.h"
#import "INSDefaultInfiniteIndicator.h"

@interface UserRepositoriesTableViewController : UITableViewController <GithubSessionManagerDelegate>

@property (weak, nonatomic) GithubUser *user;

@end
