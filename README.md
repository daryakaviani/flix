# Project 2 - *Flix*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **25** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User sees an app icon on the home screen and a styled launch screen.
- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.
- [x] User sees an error message when there's a networking error.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [x] User can tap a poster in the collection view to see a detail screen of that movie
- [x] User can search for a movie.
- [x] In the detail view, when the user taps the poster, a new screen is presented modally where they can view the trailer.
- [x] All images fade in as they are loading.
- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the selection effect of the cell.
- [x] Customize the navigation bar.
- [x] While poster is being fetched, user see's a placeholder image.
- [x] Customize the UI.

The following **additional** features are implemented:

- [x] Displays the popularity rating of each movie by fetching the float from the Now Playing endpoint, converting it to a string, and selecting the first two characters.
- [x] Displays the release date of each movie.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I noticed there was a lot of overlapping code in my project. Tutorials also often copy and pasted aspects of previously implemented features as opposed to creating a publicly accessible method and calling them from various locations in the project. I am wondering if this is the norm in iOS development or if adding widely used methods to the *.h* files instead of the *.m* files could help us avoid repetitive code.
2. Before I decided on popularity and release date, I was planning on adding reviews using the Reviews endpoint of the Movies Database API to obtain a number from 1-5 and subsequently display that particular number of star icons. Unfortunately, the API did not include the reviews for newly released Now Playing movies, but it would be interesting to look into other APIs to implement this functionality in the future.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/CYx9aPRnMj.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with RecordIt.

## Notes

Describe any challenges encountered while building the app.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Flaticon] (https://flaticon.com) - icons
- [MBProgressHUD] (https://github.com/matej/MBProgressHUD) - loading icon animation

## License

    Copyright 2020 Darya Kaviani

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
