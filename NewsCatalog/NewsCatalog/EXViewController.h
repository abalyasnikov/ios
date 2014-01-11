//
//  EXViewController.h
//  NewsCatalog
//
//  Created by Alex Aleshkov on 3/15/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface EXViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
