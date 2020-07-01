//
//  Movie.m
//  flix
//
//  Created by dkaviani on 7/1/20.
//  Copyright © 2020 dkaviani. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
self = [super init];
    self.title = dictionary[@"title"];
    self.posterPath = dictionary[@"poster_path"];
    self.overview = dictionary[@"overview"];
    self.backdropPath = dictionary[@"backdrop_path"];
    self.releaseDate = dictionary[@"release_date"];
    self.idNum = dictionary[@"id"];
    self.popularity = [NSString stringWithFormat:@"%@", dictionary[@"popularity"]];
// Set the other properties from the dictionary
    
    NSString *highBaseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *lowBaseURLString = @"https://image.tmdb.org/t/p/w200";
    
    NSString *posterPath = dictionary[@"poster_path"];
    NSString *fullPosterURLString = [highBaseURLString stringByAppendingString:posterPath];
    self.posterUrl = [NSURL URLWithString:fullPosterURLString];
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *highBackdropURLString = [highBaseURLString stringByAppendingString:backdropURLString];
    NSURL *urlLarge = [NSURL URLWithString:highBackdropURLString];
    NSString *lowBackdropURLString = [lowBaseURLString stringByAppendingString:backdropURLString];
    NSURL *urlSmall = [NSURL URLWithString:lowBackdropURLString];
    self.largeBackdropUrl = urlLarge;
    self.smallBackdropUrl = urlSmall;
    
    return self;
}

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *movies = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    return movies;
}

@end
