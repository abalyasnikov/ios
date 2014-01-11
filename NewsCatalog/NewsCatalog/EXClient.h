//
//  EXClient.h
//  NewsCatalog
//
//  Created by Alex Aleshkov on 6/24/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RssManagedItem+Images.h"


typedef void(^EXClientSuccessBlock)(NSArray *result);
typedef void(^EXClientFailureBlock)(NSError *error);


@interface EXClient : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

+ (EXClient *)sharedInstance;

- (BOOL)hasCachedRssFeed;

- (void)fetchRssFeedCachedBlock:(EXClientSuccessBlock)cachedBlock successBlock:(EXClientSuccessBlock)successBlock failureBlock:(EXClientFailureBlock)failureBlock;

@end
