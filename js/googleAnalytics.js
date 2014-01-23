import device;

var hasNativeEvents = NATIVE && NATIVE.plugins && NATIVE.plugins.sendEvent;

var GoogleAnalytics = Class(function () {
	this.init = function () {
		this._globalProperties = {};

		if (device.isSafari && !device.isSimulator && !window.weebyGoogleAnalyticsLoaded) {
			console.log("*** *** *** LOAD googleAnalytics");
			window.weebyGoogleAnalyticsLoaded = true;
			this._loadTrackingForWeb();
		}
	}

	this.track = function (name, data) {
		// copy in global properties
		merge(data, this._globalProperties);

		if (DEBUG) {
			logger.log("track: ", name, JSON.stringify(data));
		}

		if (hasNativeEvents) {
			NATIVE.plugins.sendEvent("GoogleAnalyticsPlugin", "track", JSON.stringify({
					eventName: name,
					params: data
				}));
		}
	};

	this.setGlobalProperty = function (key, value) {
		this._globalProperties[key] = value;
	}

	this._loadTrackingForWeb = function() {
		try {
			(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
			(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
			})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

			ga('create', 'UA-47369514-1', 'wee.by');
			ga('send', 'pageview');
		} catch (err) {
			console.log("*** *** ***" + err.message);
		}
	}

	this.trackPage = function(page, displayTitle) {
		ga('send', {
			'hitType': 'pageview',
			'page': '/' + page,
			'title': displayTitle
		});
	}
});

exports = new GoogleAnalytics();
