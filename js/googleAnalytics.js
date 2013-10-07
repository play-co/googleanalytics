var hasNativeEvents = NATIVE && NATIVE.plugins && NATIVE.plugins.sendEvent;

var GoogleAnalytics = Class(function () {
	this.init = function () {
		this._globalProperties = {};
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
});

exports = new GoogleAnalytics();
