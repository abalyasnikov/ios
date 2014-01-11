//
//  RssManagedItem+Images.h
//  NewsCatalog
//
//  Created by Alex Aleshkov on 7/29/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import "RssManagedItem.h"


@interface RssManagedItem (Images)

- (NSArray *)imagesFromItemDescription;
- (NSArray *)imagesFromContent;

@end
