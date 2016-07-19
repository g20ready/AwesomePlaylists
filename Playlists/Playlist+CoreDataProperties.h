//
//  Playlist+CoreDataProperties.h
//  Playlists
//
//  Created by Marsel Xhaxho on 18/07/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Playlist.h"

NS_ASSUME_NONNULL_BEGIN

@interface Playlist (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *playlistId;
@property (nullable, nonatomic, retain) NSNumber *itemCount;
@property (nullable, nonatomic, retain) NSString *playlistName;
@property (nullable, nonatomic, retain) NSSet<Track *> *tracks;

@end

@interface Playlist (CoreDataGeneratedAccessors)

- (void)addTracksObject:(Track *)value;
- (void)removeTracksObject:(Track *)value;
- (void)addTracks:(NSSet<Track *> *)values;
- (void)removeTracks:(NSSet<Track *> *)values;

@end

NS_ASSUME_NONNULL_END
