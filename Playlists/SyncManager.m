//
//  SyncManager.m
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import "SyncManager.h"

@implementation SyncManager

+ (SyncManager *)sharedManager {
    static SyncManager *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[SyncManager alloc] init];
    });
    return sharedEngine;
}

- (void) syncPlaylists:(syncedCallback) callback {
    [[NetworkManager sharedManager] fetchPlaylists:^(NSArray *playlists, NSError *error) {
        if (error) {
            callback(error);
            return;
        }
        [[CoreDataManager sharedManager] savePlaylists:playlists savedBlock:^(NSError *error) {
            callback(error);
        }];
    }];
}

- (void) syncTrakcsForPlaylist:(NSString *) playlistId withCallback: (syncedCallback) callback {
    [[NetworkManager sharedManager] fetchTracksForPlaylist:playlistId withCallback:^(NSArray *tracks, NSError *error) {
        if (error) {
            callback(error);
            return;
        }
        [[CoreDataManager sharedManager] saveTracks:tracks forPlaylist:playlistId withCallback:^(NSError *error) {
            callback(error);
        }];
    }];
}

@end
