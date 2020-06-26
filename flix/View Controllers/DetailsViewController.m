//
//  DetailsViewController.m
//  flix
//
//  Created by dkaviani on 6/24/20.
//  Copyright © 2020 dkaviani. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Here we use the method didPan(sender:), which we defined in the previous step, as the action.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    
    // Optionally set the number of required taps
    tapGestureRecognizer.numberOfTapsRequired = 1;
    
    // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
    [self.posterView setUserInteractionEnabled:YES];
    [self.posterView addGestureRecognizer:tapGestureRecognizer];
    
    NSString *highBaseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *lowBaseURLString = @"https://image.tmdb.org/t/p/w200";
    
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [highBaseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *highBackdropURLString = [highBaseURLString stringByAppendingString:backdropURLString];
    NSURL *urlLarge = [NSURL URLWithString:highBackdropURLString];
    NSString *lowBackdropURLString = [lowBaseURLString stringByAppendingString:backdropURLString];
    NSURL *urlSmall = [NSURL URLWithString:lowBackdropURLString];

    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];

    __weak DetailsViewController *weakSelf = self;

    [self.backdropView setImageWithURLRequest:requestSmall
      placeholderImage:nil
       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
           
           // smallImageResponse will be nil if the smallImage is already available
           // in cache (might want to do something smarter in that case).
           weakSelf.backdropView.alpha = 0.0;
           weakSelf.backdropView.image = smallImage;
           
           [UIView animateWithDuration:0.3
                            animations:^{
                                
                                weakSelf.backdropView.alpha = 1.0;
                                
                            } completion:^(BOOL finished) {
                                // The AFNetworking ImageView Category only allows one request to be sent at a time
                                // per ImageView. This code must be in the completion block.
                                [weakSelf.backdropView setImageWithURLRequest:requestLarge
                                                      placeholderImage:smallImage
                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                    weakSelf.backdropView.image = largeImage;
                                                      }
                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                   // do something for the failure condition of the large image request
                                                                   // possibly setting the ImageView's image to a default image
                                                               }];
                            }];
               }
               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                   // do something for the failure condition
                   // possibly try to get the large image
               }];
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}
 
 #pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *fullAPIURLString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed", self.movie[@"id"]];
    TrailerViewController *trailerViewController = segue.destinationViewController;
    trailerViewController.urlString = fullAPIURLString;
}

/* TRAILER FEATURE */

- (IBAction)didTap:(UITapGestureRecognizer *)sender {
//    CGPoint location = [sender locationInView:self.view];
    [self performSegueWithIdentifier:@"segue" sender:nil];
}
@end
