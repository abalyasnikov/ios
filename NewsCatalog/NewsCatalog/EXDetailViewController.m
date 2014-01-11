//
//  EXDetailViewController.m
//  NewsCatalog
//
//  Created by Alex Aleshkov on 3/29/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import "EXDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "EXWebViewController.h"
#import "EXConsts.h"
#import "AddThis.h"


@interface EXDetailViewController () <UIActionSheetDelegate>

@end


@implementation EXDetailViewController

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

    self.navigationItem.title = @"Новость";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [userDefaults objectForKey:EXSettingFontName];
    NSNumber *fontSize = [userDefaults objectForKey:EXSettingFontSize];
    self.textView.font = [UIFont fontWithName:fontName size:[fontSize floatValue]];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDetail:(RssManagedItem *)detail
{
    _detail = detail;
    NSLog(@"setDetail %@", _detail.title);
}

- (void)reloadData
{
    if (!_detail) {
        return;
    }
    
    self.titleLabel.text = _detail.title;
    self.textView.text = _detail.itemDescription;
    NSArray *images = [_detail imagesFromContent];
    NSString *imageURLString = [images objectAtIndex:0];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    [self.imageView setImageWithURL:imageURL];
    
    CGRect contentViewFrame = _contentView.frame;
    contentViewFrame.size.height += _textView.contentSize.height - _textView.frame.size.height;
    _contentView.frame = contentViewFrame;
    _scrollView.contentSize = _contentView.frame.size;
}

- (IBAction)openBarButtonAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Действия" delegate:self cancelButtonTitle:@"Отменить" destructiveButtonTitle:nil otherButtonTitles:@"Открыть", @"Открыть в Safari", @"Поделиться в Facebook", @"Поделиться в Twitter", nil];
    [actionSheet showInView:self.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EXWebViewController *controller = segue.destinationViewController;
    controller.url = [NSURL URLWithString:_detail.link];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"OpenURL" sender:self];
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_detail.link]];
            break;
        case 2:
            [AddThisSDK shareURL:_detail.link withService:@"facebook" title:_detail.title description:_detail.itemDescription];
            break;
        case 3:
            [AddThisSDK shareURL:_detail.link withService:@"twitter" title:_detail.title description:_detail.itemDescription];
            break;
            
        default:
            break;
    }
}

@end
