//
//  CoreDataManager.m
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import "CoreDataManager.h"

@implementation CoreDataManager

+ (CoreDataManager *)sharedManager {
    static CoreDataManager *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[CoreDataManager alloc] init];
    });
    return sharedEngine;
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectModel *)managedObjectModel {
    return [[self appDelegate] managedObjectModel];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    return [[self appDelegate] persistentStoreCoordinator];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [[self appDelegate] managedObjectContext];
}

- (NSError *) saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges]) {
            [managedObjectContext save:&error];
        }
    }
    return error;
}

- (void) savePlaylists:(NSArray *) playlists savedBlock:(savedCallback) callback{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Playlist" inManagedObjectContext:context];
    [playlists enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PlaylistDTO *playlistDTO = (PlaylistDTO *) obj;
        Playlist *playlist = [self fetchPlaylistWithId:playlistDTO.PlaylistId];
        if (!playlist) {
            playlist = [[Playlist alloc] initWithEntity:description insertIntoManagedObjectContext:context];
            playlist.playlistId = playlistDTO.PlaylistId;
        }
        playlist.playlistName = playlistDTO.Name;
        playlist.itemCount = playlistDTO.ItemCount;
    }];
    callback([self saveContext]);
}

- (void) saveTracks:(NSArray *) tracks forPlaylist:(NSString *) playlistId withCallback:(savedCallback) callback {
    NSManagedObjectContext *context = [self managedObjectContext];
    Playlist *playlist = [self fetchPlaylistWithId:playlistId];
    if (!playlist) {
        callback ([NSError errorWithDomain:@"domain" code:999 userInfo:nil]);
        return;
    }
    NSMutableSet *set = [NSMutableSet set];
    [tracks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrackDTO *trackDTO = (TrackDTO *)obj;
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:context];
        Track *track = [[Track alloc] initWithEntity:description insertIntoManagedObjectContext:context];
        track.trackId = trackDTO.TrackId;
        track.trackName = trackDTO.TrackName;
        track.artist = trackDTO.ArtistName;
        track.imageUrl = trackDTO.ImageUrl;
        [set addObject:track];
    }];
    [self removeTracksInPlaylist:playlist];
    [playlist addTracks:set];
    callback([self saveContext]);
}

- (void) removeTracksInPlaylist:(Playlist *) playlist {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSSet *playlistTracks = playlist.tracks;
    [playlistTracks enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [context deleteObject:obj];
    }];
    [playlist removeTracks:playlistTracks];
}

- (BOOL) hasPlaylists {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Playlist"];
    NSError *error;
    NSInteger count = [[self managedObjectContext] countForFetchRequest:request error:&error];
    return !error && count > 0;
}

- (Playlist *) fetchPlaylistWithId:(NSString *) playlistId {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Playlist"];
    request.predicate = [NSPredicate predicateWithFormat:@"playlistId == %@", playlistId];
    NSError *error;
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if ([result count] > 0) {
        return [result objectAtIndex:0];
    }
    return nil;
}

- (NSArray *) fetchTracksInPlaylistWithId: (NSString *) playlistId {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    request.predicate = [NSPredicate predicateWithFormat:@"playlist.playlistId == %@", playlistId];
    NSError *error;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    return results;
}

- (NSFetchedResultsController *) allTracksWithPlaylistIdResultsController:(NSString *) playlistId {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    request.predicate = [NSPredicate predicateWithFormat:@"playlist.playlistId == %@", playlistId];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"trackName" ascending:YES]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}

- (NSFetchedResultsController *) allPlaylistsResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Playlist"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"playlistName" ascending:YES]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}

- (NSArray *) fetchAllPlaylists {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Playlist"];
    NSError *error;
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (error) {
        return nil;
    }
    return result;
}

- (NSArray *) fetchAllTracks {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    NSError *error;
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (error) {
        return nil;
    }
    return result;
}

@end
