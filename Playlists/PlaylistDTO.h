//
//  PlaylistDTO.h
//  Playlists
//
//  Created by Marsel Xhaxho on 17/07/16.
//
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ResponseDTO.h"

@protocol PlaylistDTO

@end

@interface PlaylistDTO : JSONModel

@property (strong, nonatomic) NSString* PlaylistId;
@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSNumber* ItemCount;

@end

@interface PlaylistResponseDTO : ResponseDTO

@property (strong, nonatomic) NSArray<PlaylistDTO>* Result;

@end
