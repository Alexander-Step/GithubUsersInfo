//
//  GithubRepository.h
//  GithubUsersInfo
//
//  Created by Alexander on 14.03.17.
//  Copyright © 2017 AlexanderStepanishin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GithubRepository : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly)  NSString *nameOfRepository;
@property (nonatomic, copy, readonly)  NSString *descriptionOfRepository;
@property (nonatomic, copy, readonly)  NSNumber *idOfRepository;
@property (nonatomic, copy, readonly)  NSDictionary *ownerDictionary;

@end
