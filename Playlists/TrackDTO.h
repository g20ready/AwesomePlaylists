//
//  TrackDTO.h
//  Playlists
//
//  Created by Marsel Xhaxho on 18/07/16.
//
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ResponseDTO.h"

@protocol TrackDTO

@end

@interface TrackDTO : JSONModel

@property (strong, nonatomic) NSNumber* TrackId;
@property (strong, nonatomic) NSString* TrackName;
@property (strong, nonatomic) NSString* ImageUrl;
@property (strong, nonatomic) NSString* ArtistName;

@end

@protocol TracksResult

@end

@interface TracksResult : JSONModel

@property (strong, nonatomic) NSArray<TrackDTO>* Items;

@end

@interface TracksResponseDTO : ResponseDTO

@property (strong, nonatomic) TracksResult* Result;

@end
