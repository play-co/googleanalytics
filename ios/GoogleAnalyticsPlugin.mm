#import "GoogleAnalyticsPlugin.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "JSONKit.h"
#import "platform/log.h"

@implementation GoogleAnalyticsPlugin

// The plugin must call super dealloc.
- (void) dealloc {
	[super dealloc];
}

// The plugin must call super init.
- (id) init {
	self = [super init];
	if (!self) {
		return nil;
	}

	return self;
}

- (void) initializeWithManifest:(NSDictionary *)manifest appDelegate:(TeaLeafAppDelegate *)appDelegate {
	@try {
		NSDictionary *ios = [manifest valueForKey:@"ios"];
		NSString *trackingId = [ios valueForKey:@"googleTrackingID"];

		//[[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];

		// Initialize Google Analytics with a 120-second dispatch interval. There is a
		// tradeoff between battery usage and timely dispatch.
		//[GAI sharedInstance].dispatchInterval = 120;

		[GAI sharedInstance].trackUncaughtExceptions = YES;
		self.tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingId];

		[self.tracker set:kGAIUseSecure value:[@NO stringValue]];

		[self.tracker send:[[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                           action:@"appstart"
                                                            label:nil
                                                            value:nil] set:@"start" forKey:kGAISessionControl] build]];

		NSLOG(@"{googleAnalytics} Initialized with manifest googleTrackingID: '%@'", trackingId);
	}
	@catch (NSException *exception) {
		NSLOG(@"{googleAnalytics} Failure to get ios:googleTrackingID key from manifest file: %@", exception);
	}
}

- (void) track:(NSDictionary *)jsonObject {
	@try {
		NSString *eventName = [jsonObject valueForKey:@"eventName"];

		NSDictionary *evtParams = [jsonObject objectForKey:@"params"];

		if ([evtParams count] == 1) {
			NSString *key0 = [[evtParams allKeys] objectAtIndex:0];
			NSString *value0 = [[evtParams allValues] objectAtIndex:0];

			[self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventName
									 action:key0
									  label:value0
									  value:nil] build]];

			NSLOG(@"{googleAnalytics} Delivered event '%@' : action=%@ label=%@", eventName, key0, value0);
		} else {
			NSString *jsonString = [evtParams JSONString];

			[self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventName
									 action:@"JSON"
									  label:jsonString
									  value:nil] build]];

			NSLOG(@"{googleAnalytics} Delivered event '%@' : action=JSON label=%@", eventName, jsonString);
		}
	}
	@catch (NSException *exception) {
		NSLOG(@"{googleAnalytics} Exception while processing event: ", exception);
	}
}

- (void) trackScreen:(NSString *)screenName {
	[self.tracker set:kGAIScreenName value:screenName];
	[self.tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

@end
