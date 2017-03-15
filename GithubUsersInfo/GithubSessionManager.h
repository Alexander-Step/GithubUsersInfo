//
//  GithubSessionManager.h
//  GithubUsersInfo
//
//  Created by Alexander on 13.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>
#import "GithubUser.h"

@class GithubSessionManager;

@protocol GithubSessionManagerDelegate <NSObject>

@optional
//UsersTableViewController method
- (void)githubSessionManager: (nullable GithubSessionManager*)manager didUpdateWithUsersInfo: (nullable id) usersInfo;
//UserRepositoriesTableViewController method
- (void)githubSessionManager:(nullable GithubSessionManager*)manager didUpdateWithRepositoriesObject:(nullable id)repositoriesObject forUser:(nullable GithubUser*)user toPage:(NSInteger)toPage;
- (void)githubSessionManagerDidFailWithError: (nullable NSError*) error;

@end

@interface GithubSessionManager : AFHTTPSessionManager

@property (nonatomic, weak, nullable) id <GithubSessionManagerDelegate> delegate;

NS_ASSUME_NONNULL_BEGIN
+ (GithubSessionManager*)sharedGithubSessionManager;
- (instancetype)initWithBaseURL:(nullable NSURL*) url;

- (void)updateUsersListFromID:(NSInteger)fromID;
- (void)updateRepositoriesListForUser:(GithubUser*)user forPage:(NSInteger)forPage repositoriesPerPage:(NSInteger) perPage;
NS_ASSUME_NONNULL_END

@end
