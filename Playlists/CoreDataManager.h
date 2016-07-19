//
//  CoreDataManager.h
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#import "AppDelegate.h"

#import "Playlist.h"
#import "PlaylistDTO.h"

#import "Track.h"
#import "TrackDTO.h"

@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedManager;

typedef void (^savedCallback)(NSError* error);

- (void) savePlaylists:(NSArray *) playlists savedBlock:(savedCallback) savedBlock;

- (void) saveTracks:(NSArray *) tracks forPlaylist:(NSString *) playlistId withCallback:(savedCallback) callback;

- (NSError *) saveContext;

#pragma mark fetch

- (BOOL) hasPlaylists;

- (Playlist *) fetchPlaylistWithId:(NSString *) playlistId;

- (NSArray *) fetchTracksInPlaylistWithId: (NSString *) playlistId;

- (NSFetchedResultsController *) allTracksWithPlaylistIdResultsController:(NSString *) playlistId;

- (NSFetchedResultsController *) allPlaylistsResultsController;

- (NSArray *) fetchAllPlaylists;

- (NSArray *) fetchAllTracks;

@end
