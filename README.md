# NasaLibrary

Nasa Media Library
===============
Project is to let the user search for a nasa image and get the list of images along with its title and date. when tapping on any image from list need to present a detail screen that presents image, title, date and description. Also, need to implement pagination.

Coding language
===============
Swift 4.2

APIs used for fetching image data
=================================
The data is fetched asynchronously using URLSession apis. 

Built with
==========
Xcode 10.1

Features
========
Following are the features that were implemented:

1. Present a search bar to let user enter the search query. Upon entering search query, app fetches the image data from nasa api and presents a list of search results.
2. Each item in the search result, displays image, title and date.
3. When tapped on any item in the list, the detailed screen is presented. This detailed screen displays image, title, date and description of the selected item.
4. Implemented pagination using infinite scrolling for the list table view as this gives user a seemless experience.
5. App also checks if we have reached the maximum pages for the given search query and does not query for any further pages. No hardcoded limit for the pages was assumed. Instead computed this limit based on the 'next' link coming in the response.
6. User can reset the search to see empty results. Upon entering another search the results table refreshes.
7. Used Grand central discpatch for multi threading
8. Ensured that the logging is only used in DEBUG scheme and not for RELEASE
9. Provided localization for English language.
10. Used MVVM design pattern.
11. Used storyboards for UI and Autolayouts for laying ui elements.
12. Added a few test cases for the view model to demonstrate the ability to do so.
13. Also, handled the error scenarios for when user enters a query that is invalid and generates no search results.

Reference
============ 
Apple documentation and nasa api references.

Unit Tests
==========
Added the basic unit testing target. Implemented a few tests for the view model. Would have done more, if had more time.

--------------------
Lopa Dharamshi (Mota)
