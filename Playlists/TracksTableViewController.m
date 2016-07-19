//
//  TracksTableViewController.m
//  Playlists
//
//  Created by Marsel Xhaxho on 18/07/16.
//
//

#import "TracksTableViewController.h"

@interface TracksTableViewController ()

@end

@implementation TracksTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
    [self initializeTableView];
    [self initializeRefreshControl];
    [self initializeFetchResultsViewController];
    [self initializeReachability];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self hasCachedTracks]) {
        NSLog(@"Refresh Control Height is %f", self.refreshControl.frame.size.height);
        [self showRefreshControl];
        [self syncTracks];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Custom

- (void) initializeUI {
    self.title = self.playlistName;
}

- (void) initializeTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) initializeRefreshControl {
    [self.refreshControl addTarget:self action:@selector(syncTracks) forControlEvents:UIControlEventValueChanged];
}

- (void) initializeFetchResultsViewController {
    self.fetchedResultsController = [[CoreDataManager sharedManager] allTracksWithPlaylistIdResultsController:self.playlistId];
    self.fetchedResultsController.delegate = self;
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error  userInfo]);
        return;
    }
}

- (void) syncTracks {
    [[SyncManager sharedManager] syncTrakcsForPlaylist:self.playlistId withCallback:^(NSError *error) {
        [self.refreshControl endRefreshing];
        if (error) {
            [UIAlertManager presentAlert:self
                               withTitle:@"An unexpected error occurred"
                                 message:[error localizedDescription]
                             actionTitle:@"Ok"];
            return;
        }
    }];
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Track *track = [_fetchedResultsController objectAtIndexPath:indexPath];
    [(UIImageView *)[cell viewWithTag:100] sd_setImageWithURL:[NSURL URLWithString:track.imageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    [(UILabel *)[cell viewWithTag:101] setText:track.trackName];
    [(UILabel *)[cell viewWithTag:102] setText:track.artist];
}

- (void) initializeReachability {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                if (![self hasCachedTracks]) {
                    [self showRefreshControl];
                    [self syncTracks];
                }
                break;
            }
            default:
                break;
        }
    }];
}

- (BOOL) hasCachedTracks {
    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects] > 0;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}



@end
