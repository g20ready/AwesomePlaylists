//
//  ResponseDTO.h
//  Playlists
//
//  Created by Marsel Xhaxho on 18/07/16.
//
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ResponseDTO : JSONModel

@property (strong, nonatomic) NSString* ErrorData;
@property (assign, nonatomic) int ErrorId;
@property (assign, nonatomic) BOOL IsError;

@end
