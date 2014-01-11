//
//  RssManagedItem.h
//  NewsCatalog
//
//  Created by Alex Aleshkov on 7/29/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RssManagedItem : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * commentsLink;
@property (nonatomic, retain) NSString * commentsFeed;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * guid;

@end
