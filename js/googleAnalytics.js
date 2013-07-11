var GoogleAnalytics = Class(function () {
	this.track = function (name, data) {
		logger.log("{googleAnalytics} track: ", name, data);
		NATIVE && NATIVE.plugins && NATIVE.plugins.sendEvent &&
			NATIVE.plugins.sendEvent("GoogleAnalyticsPlugin", "track",
				JSON.stringify({ eventName: name, params: data }));
	};
});

exports = new GoogleAnalytics();
