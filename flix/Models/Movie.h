//
//  Movie.h
//  flix
//
//  Created by dkaviani on 7/1/20.
//  Copyright © 2020 dkaviani. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSURL *posterUrl;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *backdropPath;
@property (nonatomic, strong) NSURL *smallBackdropUrl;
@property (nonatomic, strong) NSURL *largeBackdropUrl;
@property (nonatomic, strong) NSString *popularity;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *idNum;
- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
