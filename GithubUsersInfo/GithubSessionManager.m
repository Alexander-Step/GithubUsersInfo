//
//  GithubSessionManager.m
//  GithubUsersInfo
//
//  Created by Alexander on 13.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import "GithubSessionManager.h"

static NSString * const GithubBaseURLString = @"https://api.github.com/";

@implementation GithubSessionManager

+ (GithubSessionManager*)sharedGithubSessionManager{
  static GithubSessionManager* _sharedGithubSessionManager = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
      _sharedGithubSessionManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:GithubBaseURLString]];
  });
  
  return _sharedGithubSessionManager;
}

- (instancetype)initWithBaseURL:(nullable NSURL*) url{
  self = [super initWithBaseURL:url];
  if (self){
      self.responseSerializer = [AFJSONResponseSerializer serializer];
      self.requestSerializer = [AFJSONRequestSerializer serializer];
  }
  return self;
}

- (void)updateUsersListFromID:(NSInteger)fromID{
  //build parameters and attributes for fetch
  __weak GithubSessionManager *weakSessionManager = self;
  NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
  parameters[@"since"] = [NSNumber numberWithInteger:fromID];
  
  //make a fetch
  [self GET:@"users" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      if ([self.delegate respondsToSelector:@selector(githubSessionManager:didUpdateWithUsersInfo:)]){
          [self.delegate githubSessionManager:weakSessionManager didUpdateWithUsersInfo:responseObject];
      }
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if ([self.delegate respondsToSelector:@selector(githubSessionManagerDidFailWithError:)]){
          [self.delegate githubSessionManagerDidFailWithError:error];
      }
  }];
}

- (void)updateRepositoriesListForUser:(GithubUser*)user forPage:(NSInteger)forPage repositoriesPerPage:(NSInteger) perPage{
  //build parameters and attributes for fetch
  NSString *userName = user.login;
  NSString *stringForURL = [NSString stringWithFormat:@"users/%@/repos", userName];
  __weak GithubSessionManager *weakSessionManager = self;
  __weak GithubUser *weakUser = user;
  NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
  parameters[@"page"] = [NSNumber numberWithInteger:forPage];
  parameters[@"per_page"] = [NSNumber numberWithInteger:perPage];
  
  //make a fetch
  [self GET:stringForURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      if ([self.delegate respondsToSelector:@selector(githubSessionManager:didUpdateWithRepositoriesObject:forUser:toPage:)]){
          [self.delegate githubSessionManager:weakSessionManager didUpdateWithRepositoriesObject: responseObject forUser:weakUser toPage:forPage];
      }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if ([self.delegate respondsToSelector:@selector(githubSessionManagerDidFailWithError:)]){
          [self.delegate githubSessionManagerDidFailWithError:error];
      }
  }];
}

@end
