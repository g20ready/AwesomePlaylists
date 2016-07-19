//
//  NetworkManager.h
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ResponseDTO.h"
#import "PlaylistDTO.h"
#import "TrackDTO.h"

static NSString * const PLAYLISTS_URL = @"http://akazoo.com/services/Test/TestMobileService.svc/playlists";

static NSString * const TRACKS_URL = @"http://akazoo.com/services/Test/TestMobileService.svc/playlist?playlistid=PLAYLIST_ID";

@interface NetworkManager : AFHTTPSessionManager

+ (NetworkManager *)sharedManager;

#pragma mark GET

typedef void (^fetchedPlaylists)(NSArray* playlists, NSError* error);

- (void) fetchPlaylists: (fetchedPlaylists) fetchedBlock;

typedef void (^fetchedTracks)(NSArray* tracks, NSError* error);

- (void) fetchTracksForPlaylist:(NSString*) playlistId withCallback:(fetchedTracks) callback;

@end
