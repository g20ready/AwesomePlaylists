//
//  ViewController.h
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import <UIKit/UIKit.h>
#import "Playlist.h"
#import "Playlist+CoreDataProperties.h"
#import "AppDelegate.h"
#import "NetworkManager.h"
#import "SyncManager.h"
#import "CoreDataManager.h"
#import "Playlist.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

