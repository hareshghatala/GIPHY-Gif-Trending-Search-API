# GIPHY Gif with trending and search API using MVVM
This repository demonstrates the GIPHY Gif's open API using trending & search endpoints and demonstrates MVVM architecture with Swift.
It is using the Giphy API inside the application which allows users to search, view, and favourite gifs.

This demo app contains tab-based UI where one tab is for Gif feed and another is for favourites. When opening the app, users can see the trending gif image list. All Gif images are fetched from GIPHY's API with `trending` endpoint. Also, it allows users to search the gif images as per his/her need and when users search any of the keywords it searches in the GIPHY's API with `search` endpoint.
- Loading and error states are handled using observable closure.
- Images are cached for better performance.
- ViewModel & View bounded using swift closure.
- UI refreshed with the data update.
- Data passed to the next screen and populate UI using RxSwift.
- Contain a favourite button that allows favourite and unfavourite.
- The favourited items will be stored locally on the device.
- The unfavourite functionality will remove gif from local storage.


## Technical Specification

>  - [x] Xcode 12 and later 
>  - [x] iOS 13.0 and later
>  - [x] Swift 5
>  - [x] iPhone only app
>  - [x] Swift & Storyboard

### Architecture
MVVM *(Model View ViewModel)*

### Cocoa Pods Used
`JellyGif` to Gif image handling.
[JellyGig github](https://github.com/TaLinh/JellyGif)


### API provider
`https://developers.giphy.com/docs/api`

---------- 

## Communication

-   If you  **want to contribute**, submit a pull request.
-   For any qustion or suggetions, you can create issue for it. Enjoy The Coding !!!
