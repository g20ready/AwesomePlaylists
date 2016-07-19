//
//  Track+CoreDataProperties.h
//  Playlists
//
//  Created by Marsel Xhaxho on 18/07/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Track.h"

NS_ASSUME_NONNULL_BEGIN

@interface Track (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *trackId;
@property (nullable, nonatomic, retain) NSString *trackName;
@property (nullable, nonatomic, retain) NSString *artist;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) Playlist *playlist;

@end

NS_ASSUME_NONNULL_END
