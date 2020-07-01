#import "MovieApiManager.h"
#import "Movie.h"

@interface MovieApiManager()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation MovieApiManager

- (id)init {
    self = [super init];

    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    return self;
}

- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);

            // The network request has completed, but failed.
            // Invoke the completion block with an error.
            // Think of invoking a block like calling a function with parameters
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            NSArray *dictionaries = dataDictionary[@"results"];
            NSArray *movies = [Movie moviesWithDictionaries:dictionaries];
            // The network request has completed, and succeeded.
            // Invoke the completion block with the movies array.
            // Think of invoking a block like calling a function with parameters
            completion(movies, nil);
        }
    }];
    [task resume];
}

@end
