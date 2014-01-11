//
//  EXViewController.m
//  NewsCatalog
//
//  Created by Alex Aleshkov on 3/15/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import "EXViewController.h"
#import "EXImageCell.h"
#import "EXDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVPullToRefresh.h"
#import "EXClient.h"


@interface EXViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end


@implementation EXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"ITDox";
    
    NSManagedObjectContext *managedObjectContext = [EXClient sharedInstance].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"RssManagedItem" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entityDescription;
    fetchRequest.sortDescriptors = @[ sortDescriptor ];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    fetchedResultsController.delegate = self;
    self.fetchedResultsController = fetchedResultsController;
    [self.fetchedResultsController performFetch:nil];
    
    [self.tableView reloadData];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self refreshData];
    } position:SVPullToRefreshPositionTop];
    [self.tableView triggerPullToRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const ImageCellId = @"ImageCell";
    
    EXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageCellId];
    
    RssManagedItem *item = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    cell.cellTextLabel.text = item.title;
    NSArray *images = [item imagesFromContent];
    NSString *imageURLString = [images objectAtIndex:0];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    [cell.cellImageView setImageWithURL:imageURL];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        RssManagedItem *item = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        [segue.destinationViewController setDetail:item];
    }
}

- (void)refreshData
{
    [[EXClient sharedInstance] fetchRssFeedCachedBlock:^(NSArray *result) {
        [self.tableView reloadData];
    } successBlock:^(NSArray *result) {
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;

        default:
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
