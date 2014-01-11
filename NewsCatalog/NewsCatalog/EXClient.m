//
//  EXClient.m
//  NewsCatalog
//
//  Created by Alex Aleshkov on 6/24/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import "EXClient.h"
#import "RSSItem.h"
#import "RSSParser.h"


@interface EXClient ()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@end


@implementation EXClient

+ (EXClient *)sharedInstance
{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSError *error = nil;
    
    NSString *const kDatabaseFileName = @"RssManaged.sqlite";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:kDatabaseFileName];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:databasePath] options:nil error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    self.managedObjectContext = managedObjectContext;
    
    return self;
}

- (BOOL)hasCachedRssFeed
{
    NSUInteger rowsCount = 0;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"RssManagedItem" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entityDescription;
    
    NSError *error = nil;
    rowsCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    
    return rowsCount != 0;
}

- (NSArray *)fetchCachedRssFeed
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"RssManagedItem" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entityDescription;
    fetchRequest.sortDescriptors = @[ sortDescriptor ];

    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    return results;
}

- (void)fetchRssFeedCachedBlock:(EXClientSuccessBlock)cachedBlock successBlock:(EXClientSuccessBlock)successBlock failureBlock:(EXClientFailureBlock)failureBlock
{
    if (cachedBlock) {
        NSArray *cachedFeed = [self fetchCachedRssFeed];
        cachedBlock(cachedFeed);
    }
    
    NSURL *url = [NSURL URLWithString:@"http://itdox.ru/feed/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems) {
        for (RSSItem *item in feedItems) {
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"RssManagedItem" inManagedObjectContext:self.managedObjectContext];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid == %@", item.guid];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            fetchRequest.entity = entityDescription;
            fetchRequest.predicate = predicate;
            
            NSError *error = nil;
            NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
                continue;
            }
            
            RssManagedItem *managedItem = nil;
            if ([results count]) {
                managedItem = [results objectAtIndex:0];
            } else {
                managedItem = [NSEntityDescription insertNewObjectForEntityForName:@"RssManagedItem" inManagedObjectContext:self.managedObjectContext];
            }
            
            managedItem.title = item.title;
            managedItem.itemDescription = item.itemDescription;
            managedItem.content = item.content;
            managedItem.link = [item.link absoluteString];
            managedItem.commentsLink = [item.commentsLink absoluteString];
            managedItem.commentsFeed = [item.commentsFeed absoluteString];
            managedItem.commentsCount = item.commentsCount;
            managedItem.pubDate = item.pubDate;
            managedItem.author = item.author;
            managedItem.guid = item.guid;
            
            [self.managedObjectContext save:&error];
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }
        
        if (successBlock) {
            NSArray *cachedFeed = [self fetchCachedRssFeed];
            successBlock(cachedFeed);
        }
    } failure:failureBlock];
}

@end
