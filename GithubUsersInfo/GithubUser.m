//
//  GithubUser.m
//  GithubUsersInfo
//
//  Created by Alexander on 14.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import "GithubUser.h"

@implementation GithubUser

+ (NSDictionary*)JSONKeyPathsByPropertyKey{
    return @{
             @"avatarUrl" : @"avatar_url",
             @"eventsUrlString" : @"events_url",
             @"followersUrl" : @"followers_url",
             @"followingUrlString" : @"following_url",
             @"gistsUrlString" : @"gists_url",
             @"gravatarId" : @"gravatar_id",
             @"htmlUrl" : @"html_url",
             @"userID" : @"id",
             @"login" : @"login",
             @"organizationsUrl" : @"organizations_url",
             @"receivedEventsUrl" : @"received_events_url",
             @"reposUrl" : @"repos_url",
             @"siteAdmin" : @"site_admin",
             @"starredUrlString" : @"starred_url",
             @"subscriptionsUrl" : @"subscriptions_url",
             @"userType" : @"type",
             @"urlToUserPage" : @"url"
             };
}

+ (NSValueTransformer *)URLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)HTMLURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    return self;
}

@end

