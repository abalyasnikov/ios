//
//  EXSplashScreenViewController.m
//  NewsCatalog
//
//  Created by Alex Aleshkov on 5/13/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import "EXSplashScreenViewController.h"
#import "UIImage+ImageNamed568.h"


@implementation EXSplashScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *image = [UIImage imageNamed568:@"Default"];
    self.imageView.image = image;
}

@end
