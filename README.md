# Game Closure DevKit Plugin: Google Analytics

This plugin allows you to collect analytics using the [Google Analytics](https://www.google.com/analytics/) toolkit.  Both iOS and Android targets are supported.

## Usage

Install the addon with `basil install googleanalytics`.

Include it in the `manifest.json` file under the "addons" section for your game:

~~~
"addons": [
	"googleanalytics"
],
~~~

To specify your game's Tracking ID, edit the `manifest.json "android" and "ios" sections as shown below:

~~~
	"android": {
		"versionCode": 1,
		"icons": {
			"36": "resources/icons/android36.png",
			"48": "resources/icons/android48.png",
			"72": "resources/icons/android72.png",
			"96": "resources/icons/android96.png"
		},
		"googleTrackingID": "UA-42399544-1"
	},
~~~

~~~
	"ios": {
		"bundleID": "mmp",
		"appleID": "568975017",
		"version": "1.0.3",
		"icons": {
			"57": "resources/images/promo/icon57.png",
			"72": "resources/images/promo/icon72.png",
			"114": "resources/images/promo/icon114.png",
			"144": "resources/images/promo/icon144.png"
		},
		"googleTrackingID": "UA-42399545-1"
	},
~~~

Note that the manifest keys are case-sensitive.

To use Google Analytics tracking in your game, import the googleanalytics object:

~~~
import plugins.googleanalytics.googleAnalytics as googleAnalytics;
~~~

Then send individual track events like this:

~~~
googleAnalytics.track("myEvent", {
	"score": 999,
	"coins": 11,
	"isRandomParameter": true
});
~~~

Note that the second parameter to `track` should be an object even if it is one entry.

Your events will be logged with category = event name.  If you specifiy just one key in the event object, then: action = key name, label = key value.  If you specify multiple keys in the event objects, then: action = "JSON" and label = JSON string.

You can test for successful integration via the [Google Analytics](https://www.google.com/analytics/) website after successfully building and running your game on a network-connected device.  Also check the console for helpful debug messages.

You should see console logs like this:

~~~
E/JS      ( 5978): {googleAnalytics} Initializing from manifest with googleTrackingID= UA-42399544-1

…

D/JS      ( 5978): LOG plugins.googleanalytics.googleAnalytics {googleAnalytics} track:  AppStart [object Object]
E/JS      ( 5978): {googleAnalytics} track - success: category= AppStart action='JSON' label= {"paramTest1":"valueTest1","paramTest2":"valueTest2"}
D/JS      ( 5978): LOG plugins.googleanalytics.googleAnalytics {googleAnalytics} track:  UpgradePriceGroup [object Object]
E/JS      ( 5978): {googleAnalytics} track - success: category= UpgradePriceGroup action= priceGroup label= B_CHEAPER
~~~
