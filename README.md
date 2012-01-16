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

All UIKit component subclasses listed above have class methods that allow for setting up default stylings that will be applied automatically when new instances are created. This solved a serious problem in the pre-iOS 5 days (before `UIAppeance` was released), allowing for easy skinning of apps. However, even in the post-iOS 5 days we have found this method of skinning to be sufficient (perhaps even superior) to `UIAppearance`, therefore we have decided to keep this functionality and improve on it as we develop the components more.

An example of how we use this (this code should happen right after the application launches):

	[OPNavigationBar setDefaultColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar_texture.png"]]];
	[OPBarButtonItem setDefaultTextColor:[UIColor grayColor]];
	[OPBarButtonItem setDefaultTextShadowColor:[UIColor colorWithWhite:1.0f alpha:0.8f]];
	[OPTableViewController setDefaultBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]]];
	
Now, all of our navigation controllers with have nicely textured navigation bars and properly styled navigation buttons, and all of our table view controllers will have a nice textured background.
    
##Installation

We love [CocoaPods](http://github.com/cocoapods/cocoapods), so we recommend you use it.

##Dependencies

We make use extensive of [OPQuartzKit](http://www.opetopic.com) and [OPExtensionKit](http://www.opetopic.com). They have some pretty kick ass things though, so you may want to check them out anyway :)

##Demo

Checkout [OPKitDemo](http://www.opetopic.com) for a demo application using OPUIKit, among other things.

##Author

Brandon Williams  
brandon@opetopic.com  
[www.opetopic.com](http://www.opetopic.com)
