# flutter_stage_OTT
Technical Assessment 

The following are the implementation details of the flutter app. The main changes are in /lib folder

1) Movie List
    a) Contains grid of movies with each movie card containing movie image, title, genres, favorite icon, based on selection, this icon, upon click, adds/removes the movie as favorite.
    b) Movie list screen has favorite icon at the top right right corner which displays the list of favorite movies.
    c) Movie lis also has a search icon at the top right corner with which we will be able to search for movie titles both in movies list and favorite list.
    d) On tapo of movie card in the list takes to detail page.

2) Movie Detail screen
   a) It contains movie bannerUrl image as the background.
   b) It contains the movie image, release date and voting in the form of rating.
   c) Below there is a synopsis which is shown as overview.
   d) There is a trailers section which is shown at the bottom if any of them have youtube ids. The trailer can be played on tap of it which shows an alert dialog and plays using YoutubeController and tap on outside of it will dismiss the dialog.

3) The favorite icon is present in both list and detail pages and they both are in sync and can be added or removed from favorites from any screen.

4) MVVM architecture has been implemented for easy readibility and for code modularization and handling of complex logic.

5) User experience has been made smooth to  make sure the UI images and movie cards load smoothly.

6) UI refresh. In case the user is in offline mode, and it shows No internet, a retry button has been to refresh the UI once the user comes online. 

7) Error handling has been done to print the errors to console for now. For user experience, either the user will be shown with cached data or No movies found or no internet if no data. There is an option to refresh UI in case no data. Empty response, api failure/success have been handled. And user is notified or UI is shown with movie cards cached or online data based on whether user is offline or online.

8) Search feature has been implemented for movie list as well as favorite list.

9) Offline mode has been implemented to use sqlite which will cache data - both lists and favorite and will show the cached data if user is offline and relaunches the app. Detail page shows the data in case of no internet as the movie details are already cached.

10) A toggle button on the list screen to change grid items from all movies to favorite and  vice versa is implemented.

11) API key details are in assets/.env file.


The following are the screenshots of the app:

<img width="370" alt="Screenshot 2025-03-10 at 10 08 15 PM" src="https://github.com/user-attachments/assets/7943bc3a-4df5-446d-b185-0bec21480534" />
<img width="378" alt="Screenshot 2025-03-10 at 10 09 06 PM" src="https://github.com/user-attachments/assets/36986676-90e9-4cda-9c5f-10ec2df1cbd0" />
<img width="377" alt="Screenshot 2025-03-10 at 10 09 23 PM" src="https://github.com/user-attachments/assets/8435275c-0d5b-4abc-b8fe-07a0f9b9f515" />
<img width="379" alt="Screenshot 2025-03-10 at 10 08 29 PM" src="https://github.com/user-attachments/assets/3d8a7504-ce93-49e2-be6e-9ccfd2a18496" />
<img width="376" alt="Screenshot 2025-03-10 at 10 08 42 PM" src="https://github.com/user-attachments/assets/2d105a86-64cc-42f3-a499-de35d896d286" />




