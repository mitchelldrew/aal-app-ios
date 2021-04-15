# aal-app-ios

This app finds restaurants on Google Places and displays their data in a UICollectionView and Google Maps. 

[Presenter](https://github.com/mitchelldrew/aal-presenter) and [model](https://github.com/mitchelldrew/aal-model) logic have been implemented in Kotlin Native for portability and unit testing. [Provider](https://github.com/mitchelldrew/aal-provider-ios) handles platform specific non-view code.

Views are implemented programmatically in UIKit to sidestep the punishing compile times and merge conflicts of Interface Builder while supporting the maximum number of devices possible.
