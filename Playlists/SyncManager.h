//
//  SyncManager.h
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "CoreDataManager.h"
#import "PlaylistDTO.h"
#import "Playlist.h"

@interface SyncManager : NSObject

+ (SyncManager *)sharedManager;

typedef void (^syncedCallback)(NSError* error);

- (void) syncPlaylists:(syncedCallback) callback;

- (void) syncTrakcsForPlaylist:(NSString *) playlistId withCallback: (syncedCallback) callback;

@end
