//
//  MovieCollectionCell.m
//  flix
//
//  Created by dkaviani on 6/24/20.
//  Copyright © 2020 dkaviani. All rights reserved.
//

#import "MovieCollectionCell.h"
#import <UIImageView+AFNetworking.h>

@implementation MovieCollectionCell

- (void)setMovie:(Movie *)movie {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
    _movie = movie;

    [self.posterView setImageWithURL:self.movie.posterUrl];
    self.posterView.image = nil;
    if (self.movie.posterUrl != nil) {
        [self.posterView setImageWithURL:self.movie.posterUrl];
    }
    
    UIImage *img = [UIImage imageNamed:@"loading.png"];
    [self.posterView setImage:img];
    NSURLRequest *request = [NSURLRequest requestWithURL:movie.posterUrl];
    __weak MovieCollectionCell *weakSelf = self;
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
}

@end
