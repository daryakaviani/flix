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
#import "Movie.h"
#import "MovieApiManager.h"

// Established that the data source and delegate as expected interfaces.
@interface MoviesViewController () <UITableViewDataSource, UIGestureRecognizerDelegate, UISearchBarDelegate, UITableViewDelegate>

// Created an outlet from Table View to View Controller so that we can refer to the Table View.
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *filteredData;


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
        // new is an alternative syntax to calling alloc init.
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
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        self.movies = movies;
        self.filteredData = self.movies;
        [self.tableView reloadData];
    }];
}

// Tells us how many rows we need.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

// Creating and configured a cell.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    cell.movie = self.filteredData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            Movie *movie = evaluatedObject;
            NSString *movieTitle = movie.title;
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
    Movie *movie = self.filteredData[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


@end
