var GoogleAnalytics = Class(function () {
	this.track = function (name, data) {
		logger.log("{googleAnalytics} track: ", name, data);
		NATIVE && NATIVE.plugins && NATIVE.plugins.sendEvent &&
			NATIVE.plugins.sendEvent("GoogleAnalyticsPlugin", "track",
				JSON.stringify({ eventName: name, params: data }));
	};

	this.trackScreen = function (name) {
		logger.log("{googleAnalytics} trackScreen: ", name);
		NATIVE && NATIVE.plugins && NATIVE.plugins.sendEvent &&
			NATIVE.plugins.sendEvent("GoogleAnalyticsPlugin", "trackScreen",
				JSON.stringify({screenName: name}));
	};
});

exports = new GoogleAnalytics();