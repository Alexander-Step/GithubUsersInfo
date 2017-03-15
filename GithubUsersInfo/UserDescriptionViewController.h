//
//  UserDescriptionViewController.h
//  GithubUsersInfo
//
//  Created by Alexander on 14.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GithubSessionManager.h"
#import "GithubUser.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UserRepositoriesTableViewController.h"

@interface UserDescriptionViewController : UIViewController

@property (strong, nonatomic) GithubUser *user;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *siteAdminTextField;

@end
