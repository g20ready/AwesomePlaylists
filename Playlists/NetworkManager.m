//
//  NetworkManager.m
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (NetworkManager *)sharedManager {
    static NetworkManager *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[NetworkManager alloc] init];
    });
    return sharedEngine;
}

- (void) fetchPlaylists: (fetchedPlaylists) fetchedBlock{
    [self GET:PLAYLISTS_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError* err = nil;
        
        PlaylistResponseDTO *response = [[PlaylistResponseDTO alloc] initWithDictionary:responseObject error:&err];
        
        fetchedBlock(response.Result, err);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fetchedBlock(nil, error);
    }];
}

- (void) fetchTracksForPlaylist:(NSString*) playlistId withCallback:(fetchedTracks) callback{
    NSString *url = [TRACKS_URL stringByReplacingOccurrencesOfString:@"PLAYLIST_ID" withString:playlistId];
    [self GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError* err = nil;
        TracksResponseDTO *response = [[TracksResponseDTO alloc] initWithDictionary:responseObject error:&err];
        
        callback(response.Result.Items, err);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(nil, error);
    }];
}

@end
