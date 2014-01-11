//
//  EXWebViewController.h
//  NewsCatalog
//
//  Created by Alex Aleshkov on 4/26/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface EXWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *url;

@end
