//
//  PlaylistsTableViewController.m
//  Playlists
//
//  Created by Marsel Xhaxho on 18/07/16.
//
//

#import "PlaylistsTableViewController.h"

@interface PlaylistsTableViewController ()

@end

@implementation PlaylistsTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
    [self initializeTableView];
    [self initializeRefreshControl];
    [self initializeFetchResultsViewController];
    [self initializeReachability];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self hasCachedPlaylists]) {
        [self showRefreshControl];
        [self syncPlaylists];
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playlistCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Playlist *playlist = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"Selected playlist with name : %@", playlist.playlistName);
    self.selectedPlaylistId = playlist.playlistId;
    self.selectedPlaylistName = playlist.playlistName;
    [self performSegueWithIdentifier:@"showTracks" sender:tableView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TracksTableViewController *ttvc = (TracksTableViewController *) [segue destinationViewController];
    ttvc.playlistName = self.selectedPlaylistName;
    ttvc.playlistId = self.selectedPlaylistId;
}

#pragma mark - Custom

- (void) initializeUI {
    self.title = @"Playlists";
}

- (void) initializeTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) initializeRefreshControl {
    [self.refreshControl addTarget:self action:@selector(syncPlaylists) forControlEvents:UIControlEventValueChanged];
}

- (void) syncPlaylists {
    [[SyncManager sharedManager] syncPlaylists:^(NSError *error) {
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

- (void) initializeFetchResultsViewController {
    self.fetchedResultsController = [[CoreDataManager sharedManager] allPlaylistsResultsController];
    self.fetchedResultsController.delegate = self;
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error  userInfo]);
        return;
    }
}

- (void) initializeReachability {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                if (![self hasCachedPlaylists]) {
                    [self showRefreshControl];
                    [self syncPlaylists];
                }
                break;
            }
            default:
                break;
        }
    }];
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Playlist *playlist = [_fetchedResultsController objectAtIndexPath:indexPath];
    [(UILabel *)[cell viewWithTag:100] setText:playlist.playlistName];
    [(UILabel *)[cell viewWithTag:101] setText:[NSString stringWithFormat:@"%@ items", playlist.itemCount]];
}

- (BOOL) hasCachedPlaylists {
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
