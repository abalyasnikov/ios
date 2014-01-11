//
//  EXWebViewController.m
//  NewsCatalog
//
//  Created by Alex Aleshkov on 4/26/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import "EXWebViewController.h"


@interface EXWebViewController ()

@end


@implementation EXWebViewController

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

    self.webView.scalesPageToFit = YES;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [self.webView loadRequest:request];
}

@end
