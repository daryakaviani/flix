//
//  MovieApiManager.h
//  flix
//
//  Created by dkaviani on 7/1/20.
//  Copyright © 2020 dkaviani. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieApiManager : NSObject
- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
