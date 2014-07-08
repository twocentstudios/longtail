# longtail

longtail aggregates posts from your Facebook Groups and shows you what you and your friends were talking about on this day in history. I'm looking to add more services in the future.

longtail is an opportunity to explore [Timehop](http://timehop.com)-style content filtering with data sources that aren't as mainstream (or in other words, the "[long tail](http://en.wikipedia.org/wiki/Long_tail)" of content sources).

longtail is [currently unavailable](http://twocentstudios.com/blog/2014/07/05/my-review-of-the-new-facebook-login-review-process/) on the App Store due to [Facebook's changes](https://developers.facebook.com/docs/apps/review/login) to their Login Review process :(

* ~~[App Store]() (it's free)~~ (not until Facebook decides [to allow it](http://twocentstudios.com/blog/2014/07/05/my-review-of-the-new-facebook-login-review-process/)).
* ~~[Landing page]() with screenshots.~~ (nah).
* ~~[Blog post]() walking through the source.~~ (hopefully someday).

## Screenshots

![Screenshot 1](https://raw.githubusercontent.com/twocentstudios/longtail/master/Design/screenshots/image-01-s.png)
![Screenshot 2](https://raw.githubusercontent.com/twocentstudios/longtail/master/Design/screenshots/image-02-s.png)
![Screenshot 3](https://raw.githubusercontent.com/twocentstudios/longtail/master/Design/screenshots/image-03-s.png)
![Screenshot 4](https://raw.githubusercontent.com/twocentstudios/longtail/master/Design/screenshots/image-04-s.png)
![Screenshot 5](https://raw.githubusercontent.com/twocentstudios/longtail/master/Design/screenshots/image-05-s.png)

## Getting started

1. Clone the repo. `$ git clone git://github.com/twocentstudios/longtail.git`
1. Install the pods. `$ pod install`
1. Open `longtail.xcworkspace`.
1. Create a [Facebook App](https://developers.facebook.com/apps).
1. Add your Facebook App ID to Info.plist under the empty key `FacebookAppId`.
1. Add `fb{YOUR_APP_ID}` (sans brackets) to the `CFBundleURLSchemes` array in Info.plist.
1. Build!

## Structure

longtail is structured in the [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel) architectural pattern.

longtail uses the following libraries:

* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa): it's signals all the way down (note it uses version 2).
* [ReactiveViewModel](https://github.com/ReactiveCocoa/ReactiveViewModel) as a base for all view models.
* [Mantle](https://github.com/Mantle/Mantle) for model objects and serialization.
* [YapDatabase](https://github.com/yaptv/YapDatabase) as storage and querying for posts.
* [PureLayout](https://github.com/smileyborg/PureLayout) ~~[UIView+Autolayout](https://github.com/smileyborg/UIView-AutoLayout)~~ for lighter Autolayout syntax.
* [TTTAttributedLabel](https://github.com/smileyborg/UIView-AutoLayout) for link detection.
* [Facebook iOS SDK](https://github.com/facebook/facebook-ios-sdk) to get the goods.
* [Grocery List](https://github.com/jspahrsummers/GroceryList): I shamelessly lifted a lot of good code and ideas from Justin Spahr-Summers' project.

## License

License for source is MIT.

All rights are reserved for image assets.

Facebook [rejected my several attempts](http://twocentstudios.com/blog/2014/07/05/my-review-of-the-new-facebook-login-review-process/) at getting the `user_groups` permission approved, so even if you did attempt to get the app on the App Store, I'd appreciate it if you'd not. Thanks.

## Contributing

* Add your favorite content source? 
* Help me genericize the content models? 
* Improve the Auto Layout? 
* Improve the log in and import flow? 
* Make a legitimate icon? 
* Help get the Facebook Login Review Team to approve the `user_groups` permission?

## About

longtail was created by [Christopher Trott](http://twitter.com/twocentstudios).