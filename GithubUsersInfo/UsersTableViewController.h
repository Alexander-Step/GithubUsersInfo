//
//  UsersTableViewController.h
//  GithubUsersInfo
//
//  Created by Alexander on 13.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+INSPullToRefresh.h"
#import "INSDefaultPullToRefresh.h"
#import "INSAnimatable.h"
#import "INSDefaultInfiniteIndicator.h"
#import "GithubSessionManager.h"
#import "GithubUser.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UserTableViewCell.h"
#import "UserDescriptionViewController.h"
#import "UsersSearchTableViewController.h"

@interface UsersTableViewController : UITableViewController <GithubSessionManagerDelegate, UISearchResultsUpdating>

@property (nonatomic, copy) NSMutableArray *allUsersInfo;

- (void)performSegueToUserDescriptionWithCellAtIndexPath: (NSIndexPath*) indexPath;
- (void)adjustContentInsets;

@end
