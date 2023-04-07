
# Sample2023

**Sample2023** is a modernized **SwiftUIReference** using SwiftUI and Swift 5.

It is written in Swift 5 and Xcode Version 14.3 (14E222b)

## Overview  
This app queries the GIPHY website via its URL API interface, and uses the tags returned to search deeper and deeper.  
(This isn't necessarily a good thing!)  
To use the app you need to get an API key from <https://developers.giphy.com/dashboard/?create=true>.  
The app can open the Giphy website to make it easier for the user to get the key.  

The app uses a variation on MVVM and is "inspired" by SOLID principles.  (It does not religiously adhere to SOLID principles.)

## SwiftUI  
### The main full screen view uses:  
* `ProgressView` for the loading activity indicator  
* Sheet views - for settings and tags selection  
* `Alert` views  
* `ToolbarItem`s that vary with changes in the view model  
* A `NavigationLink/.navigationDestination` to a detail view, within a `NavigationStack`.

### Additional large views  
* A SwiftUI launch screen view  
* A detail view  
* A settings view - displayed as a `sheet`  
* A multiple selection view - displayed as a `sheet`  

### UIKit wrapper  
* `UIViewRepresentable` wrapper around **SwiftyGif's** extension to `UIImageView`.  

## "Dependency injection", etc.  
* `MainViewModel` is an `ObservableObject` injected into `MainView`.
* `Result<T, SampleError>` is used for networking results.

## Extensions, etc.  
* Generic `Data` extensions for `Result<>`  
 * `func decodeData<T: Decodable>() -> Result<T, SampleError>`  

* `URLResponse` extension  
 * `urlResponse.validate(...) -> SampleError?`  

* `@propertyWrappers` used to refactor storing `UserSettings` in `UserDefaults`.  

## Networking  
Networking uses `try await` and uses `Result<>` for most networking objects.  

* `let (data, response) = try await URLSession.shared.data(from: url)`  
 * where `(data, response)` == `(Data, URLResponse)`  

## Unit tests
Except for SwiftUI views almost all code is covered by unit tests.

