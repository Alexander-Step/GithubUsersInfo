//
//  GithubUser.h
//  GithubUsersInfo
//
//  Created by Alexander on 14.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GithubUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly)  NSURL *avatarUrl;
@property (nonatomic, copy, readonly)  NSString *eventsUrlString;
@property (nonatomic, copy, readonly)  NSURL *followersUrl;
@property (nonatomic, copy, readonly)  NSString *followingUrlString;
@property (nonatomic, copy, readonly)  NSString *gistsUrlString;
@property (nonatomic, copy, readonly)  NSURL *gravatarId;
@property (nonatomic, copy, readonly)  NSURL *htmlUrl;
@property (nonatomic, copy, readonly)  NSNumber *userID;
@property (nonatomic, copy, readonly)  NSString *login;
@property (nonatomic, copy, readonly)  NSURL *organizationsUrl;
@property (nonatomic, copy, readonly)  NSURL *receivedEventsUrl;
@property (nonatomic, copy, readonly)  NSURL *reposUrl;
@property (nonatomic, copy, readonly)  NSNumber *siteAdmin;
@property (nonatomic, copy, readonly)  NSString *starredUrlString;
@property (nonatomic, copy, readonly)  NSURL *subscriptionsUrl;
@property (nonatomic, copy, readonly)  NSString *userType;
@property (nonatomic, copy, readonly)  NSURL *urlToUserPage;

@end
