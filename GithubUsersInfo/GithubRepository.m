//
//  GithubRepository.m
//  GithubUsersInfo
//
//  Created by Alexander on 14.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import "GithubRepository.h"

@implementation GithubRepository

+ (NSDictionary*)JSONKeyPathsByPropertyKey{
    return @{
             @"nameOfRepository" : @"name",
             @"descriptionOfRepository" : @"description",
             @"idOfRepository" : @"id",
             @"ownerDictionary" : @"owner"
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    return self;
}

@end
