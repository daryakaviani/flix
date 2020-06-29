//
//  MoviesViewController.m
//  flix
//
//  Created by dkaviani on 6/24/20.
//  Copyright © 2020 dkaviani. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "MBProgressHUD.h"

// Established that the data source and delegate as expected interfaces.
@interface MoviesViewController () <UITableViewDataSource, UIGestureRecognizerDelegate, UISearchBarDelegate>

// Created an outlet from Table View to View Controller so that we can refer to the Table View.
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;


// Created getter and setter methods, usually going to stick with (nonatomic, strong)
// Movies is now a class property
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the view controller and data source to this view controller object.
    self.searchBar.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    hud.animationType = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Fetching Your Films";
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchMovies];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    // Initialize the refresher.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl];
    
    // Customization for Nav Bar
    self.navigationItem.title = @"now playing";
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundColor:[UIColor colorWithRed:0.98 green:0.77 blue:0.73 alpha:1]];
    navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:30],
                                          NSForegroundColorAttributeName : [UIColor colorWithRed:0.98 green:0.77 blue:0.73 alpha:1]};
}

- (void)networkError {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The Internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self fetchMovies];
    }];
    [alert addAction:tryAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               [self networkError];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);
               
               self.movies = dataDictionary[@"results"];
               self.filteredData = self.movies;
               for (NSDictionary *movie in self.movies) {
                   NSLog(@"%@", movie[@"title"]);
               }
               
               [self.tableView reloadData];
           }
        [self.refreshControl endRefreshing];
       }];
    
    [task resume];
}

// Tells us how many rows we need.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

// Creating and configured a cell.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Reuses old objects to preserve memory. Use MovieCell Template.
    // To conserve memory, Table Views discard of the memory of a row when it is not in view.
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.filteredData[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    // Blank out image before downloading the new replacement.
    cell.posterView.image = nil;
    
    UIImage *img = [UIImage imageNamed:@"loading.png"];
    [cell.posterView setImage:img];
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    __weak MovieCell *weakSelf = cell;
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil
                 success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
    if (imageResponse) {
        [UIView transitionWithView:cell.posterView
                          duration:0.3f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                          cell.posterView.image = image;
        } completion:nil];
    }
    else {
        NSLog(@"Image was cached so just update the image");
        weakSelf.posterView.image = image;
    }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        [self networkError];
    }];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.98 green:0.77 blue:0.73 alpha:0.5];
    cell.selectedBackgroundView = backgroundView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            NSDictionary *movieDictionary = evaluatedObject;
            NSString *movieTitle = movieDictionary[@"title"];
            return [movieTitle containsString:searchText];
        }];
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredData = self.movies;
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self fetchMovies];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredData[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


@end
