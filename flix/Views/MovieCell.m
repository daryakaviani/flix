//
//  MovieCell.m
//  flix
//
//  Created by dkaviani on 6/24/20.
//  Copyright © 2020 dkaviani. All rights reserved.
//

#import "MovieCell.h"
#import <UIImageView+AFNetworking.h>

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovie:(Movie *)movie {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
    _movie = movie;

    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.overview;
    [self.posterView setImageWithURL:self.movie.posterUrl];
    self.posterView.image = nil;
    if (self.movie.posterUrl != nil) {
        [self.posterView setImageWithURL:self.movie.posterUrl];
    }
    
    UIImage *img = [UIImage imageNamed:@"loading.png"];
    [self.posterView setImage:img];
    NSURLRequest *request = [NSURLRequest requestWithURL:movie.posterUrl];
    __weak MovieCell *weakSelf = self;
    [self.posterView setImageWithURLRequest:request placeholderImage:nil
                 success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {

    if (imageResponse) {
        [UIView transitionWithView:self.posterView
                          duration:0.3f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                          self.posterView.image = image;
        } completion:nil];
    }
    else {
        NSLog(@"Image was cached so just update the image");
        weakSelf.posterView.image = image;
    }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        
    }];

    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.98 green:0.77 blue:0.73 alpha:0.5];
    self.selectedBackgroundView = backgroundView;
}

@end
