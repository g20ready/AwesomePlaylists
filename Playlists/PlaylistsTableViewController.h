//
//  PlaylistsTableViewController.h
//  Playlists
//
//  Created by Marsel Xhaxho on 18/07/16.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#import "TracksTableViewController.h"
#import "UIAlertManager.h"
#import "UITableViewController+Additions.h"

@interface PlaylistsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSString *selectedPlaylistId;
@property (nonatomic, strong) NSString * selectedPlaylistName;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
