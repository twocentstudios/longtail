# longtail

longtail aggregates posts from your Facebook Groups and shows you what you and your friends were talking about on this day in history. I'm looking to add more services in the future.

longtail is an opportunity to explore [Timehop](http://timehop/com)-style content filtering with data sources that aren't as mainstream (or in other words, the "[long tail](http://en.wikipedia.org/wiki/Long_tail)" of content sources).

* [App Store TODO](https://itunes.apple.com/us/app/) (it's free).
* [Landing page TODO](http://twocentstudios.com/apps/longtail/) with screenshots.
* [Blog post TODO](http://twocentstudios.com/blog/) walking through the source.

![Screenshot 1](http://twocentstudios.com/apps/longtail/img/image1.png)
![Screenshot 2](http://twocentstudios.com/apps/longtail/img/image2.png)
![Screenshot 3](http://twocentstudios.com/apps/longtail/img/image3.png)

## Getting started

1. Clone the repo. `$ git clone git://github.com/twocentstudios/longtail.git`
1. Install the pods. `$ pod install`
1. Open `longtail.xcworkspace`.
1. Create a [Facebook App](https://developers.facebook.com/apps).
1. Add your Facebook App ID to Info.plist under the empty key `FacebookAppId`.
1. Add `fb{YOUR_APP_ID}` to the `CFBundleURLSchemes` array in Info.plist.
1. Build!

## Structure

longtail is structured in the [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) architecture.

longtail uses the following libraries:

* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa): it's signals all the way down (note it uses version 2).
* [ReactiveViewModel](https://github.com/ReactiveCocoa/ReactiveViewModel) as a base for all view models.
* [Mantle](https://github.com/Mantle/Mantle) for model objects and serialization.
* [YapDatabase](https://github.com/yaptv/YapDatabase) as storage and querying for posts.
* [UIView+Autolayout](https://github.com/smileyborg/UIView-AutoLayout) for lighter Autolayout syntax.
* [TTTAttributedLabel](https://github.com/smileyborg/UIView-AutoLayout) for link detection.
* [Facebook iOS SDK](https://github.com/facebook/facebook-ios-sdk) to get the goods.
* [Grocery List](https://github.com/jspahrsummers/GroceryList): I shamelessly lifted a lot of good code and ideas from Justin Spahr-Summers' project.

## License

License for source is MIT.

All rights are reserved for image assets.

If you'd like to improve the app or add other services, please fork and submit pull requests and we'll keep one version on the App Store for everyone to enjoy.

## About

longtail was created by [Christopher Trott](http://twitter.com/twocentstudios).