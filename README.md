#OPUIKit - a collection of custom UIKit components

OPUIKit was built to accomodate the many interface patterns we saw repeatedly while designing apps. This collection of components aims to supplement the UIKit framework and to stay true to UIKit's patterns and idioms. We have no interest in creating or maintaining a monolithic framework, especially when considering how fast Apple innovates with iOS.

##Highlights

* `OPSideBarNavigationController` : A subclass of `UINavigationController` giving a Facebook-esque navigation interface.
* `OPView`, `OPControl`, `OPButton` : Subclasses of `UIView`, `UIControl` and `UIButton` respectively giving a block based interface for low level drawing.
* `OPTabBarController` : A tab bar controller written from scratch, supporting most of the features of `UITabBarController`, but highly customizable. The tab bar and tab bar items are instances of `OPView` and `OPControl`, respectively, hence subject to the awesomeness that is the block based drawing mentioned above.

##Other cool stuff

* `OPNavigationBar` : A `UINavigationBar` subclass that allows block based custom drawing, and the ability to add a drop shadow underneath.
* `OPNavigationController` : A sensible navigation controller subclass to use in your navigation based apps. It's primary purpose is to use a NIB to replace its navigation bar with an instance of `OPNavigationBar` so that we do fancy things like custom drawing and adding a drop shadow in the navigation bar.
* `OPGradientView` : A`UIView` subclass that simply replaces the default backing layer with a `CAGradientLayer` so that we can easily create gradient views.

##Global styling

There is a category on `NSObject` that adds an instance method `-styling` and class method `+styling` to every subclass. It returns an instance of `OPStyle` (well, technically `OPStyleProxy`, but more on that later) that allows you to set global stylings associated with your class. For example,

	[[OPNavigationBar styling] setBackgroundColor:[UIColor lightGrayColor]];
	[[OPNavigationBar styling] setShadowHeight:4.0f];

Now all new instances of `OPNavigationBar` will be styled accordingly. For a list of styles that can be applied, see `OPStyleProtocol.h`.
    
##Installation

We love [CocoaPods](http://github.com/cocoapods/cocoapods), so we recommend you use it.

##Dependencies

We make extensive use of [OPQuartzKit](http://www.opetopic.com) and [OPExtensionKit](http://www.opetopic.com). They have some pretty kick ass things though, so you may want to check them out anyway :)

##Demo

Checkout [OPKitDemo](http://www.opetopic.com) for a demo application using OPUIKit, among other things.

##Author

Brandon Williams  
brandon@opetopic.com  
[www.opetopic.com](http://www.opetopic.com)
