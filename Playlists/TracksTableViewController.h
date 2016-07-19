//
//  TracksTableViewController.h
//  Playlists
//
//  Created by Marsel Xhaxho on 18/07/16.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CoreDataManager.h"
#import "SyncManager.h"
#import "UIAlertManager.h"
#import "UITableViewController+Additions.h"


@interface TracksTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSString *playlistId;

@property (nonatomic, strong) NSString *playlistName;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
