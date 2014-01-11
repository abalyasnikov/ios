//
//  EXImageCell.h
//  NewsCatalog
//
//  Created by Alex Aleshkov on 3/15/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface EXImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTextLabel;

@end
