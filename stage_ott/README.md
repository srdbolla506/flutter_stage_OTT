# stage_ott

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application for technical assessment.

Technical Assessment

The following are the implementation details of the flutter app. The main changes are in /lib folder

Movie List a) Contains grid of movies with each movie card containing movie image, title, genres, favorite icon, based on selection, this icon, upon click, adds/removes the movie as favorite. b) Movie list screen has favorite icon at the top right right corner which displays the list of favorite movies. c) Movie lis also has a search icon at the top right corner with which we will be able to search for movie titles both in movies list and favorite list. d) On tapo of movie card in the list takes to detail page.

Movie Detail screen a) It contains movie bannerUrl image as the background. b) It contains the movie image, release date and voting in the form of rating. c) Below there is a synopsis which is shown as overview. d) There is a trailers section which is shown at the bottom if any of them have youtube ids. The trailer can be played on tap of it which shows an alert dialog and plays using YoutubeController and tap on outside of it will dismiss the dialog.

The favorite icon is present in both list and detail pages and they both are in sync and can be added or removed from favorites from any screen.

MVVM architecture has been implemented for easy readibility and for code modularization and handling of complex logic.

User experience has been made smooth to make sure the UI images and movie cards load smoothly.

UI refresh. In case the user is in offline mode, and it shows No internet, a retry button has been to refresh the UI once the user comes online.

Error handling has been done to print the errors to console for now. For user experience, either the user will be shown with cached data or No movies found or no internet if no data. There is an option to refresh UI in case no data. Empty response, api failure/success have been handled. And user is notified or UI is shown with movie cards cached or online data based on whether user is offline or online.

Search feature has been implemented for movie list as well as favorite list.

Offline mode has been implemented to use sqlite which will cache data - both lists and favorite and will show the cached data if user is offline and relaunches the app. Detail page shows the data in case of no internet as the movie details are already cached.

A toggle button on the list screen to change grid items from all movies to favorite and vice versa is implemented.

API key details are in assets/.env file.
