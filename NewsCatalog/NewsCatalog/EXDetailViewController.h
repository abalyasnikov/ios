//
//  EXDetailViewController.h
//  NewsCatalog
//
//  Created by Alex Aleshkov on 3/29/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EXClient.h"


@interface EXDetailViewController : UIViewController

@property (nonatomic, strong) RssManagedItem *detail;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)openBarButtonAction:(id)sender;

@end
