//
//  UserTableViewCell.h
//  GithubUsersInfo
//
//  Created by Alexander on 14.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@end
