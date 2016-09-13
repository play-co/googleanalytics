import userAgent;

var hasNativeEvents = NATIVE && NATIVE.plugins && NATIVE.plugins.sendEvent;

var GoogleAnalytics = Class(function () {
	this.init = function () {
		this._globalProperties = {};
		var isNative = userAgent.APP_RUNTIME === 'native';
		if (!isNative && !userAgent.SIMULATED && !window.weebyGoogleAnalyticsLoaded) {
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

			console.log('googleAnalytics addon [info]: create - ' + CONFIG.modules.googleanalytics.trackingId + ' - ' + CONFIG.modules.googleanalytics.url);
			ga('create', CONFIG.modules.googleanalytics.trackingId, CONFIG.modules.googleanalytics.url);
			ga('send', 'pageview');
		} catch (err) {
			console.log("googleAnalytics addon [error]: " + err.message);
		}
	}

	this.trackPage = function(page, displayTitle) {
		if (window.ga) {
			ga('send', {
				'hitType': 'pageview',
				'page': '/' + page,
				'title': displayTitle
			});
		} else {
			console.log('googleAnalytics addon [warn]: googleAnalytics object is not defined. Not tracking page: ' + page);
		}
	}

	this.trackEvent = function(category, action, label, value) {
		if (window.ga) {
			ga('send', {
				'hitType': 'event',
				'eventCategory': category,
				'eventAction': action,
				'eventLabel': label,
				'eventValue': value || 0
			});
		} else {
			console.log('googleAnalytics addon [warn]: googleAnalytics object is not defined. Not tracking event: ' + [category, action, label].join(':'));
		}
	}
});

exports = new GoogleAnalytics();
