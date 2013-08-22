#import "GoogleAnalyticsPlugin.h"
#import "GAI.h"
#import "JSONKit.h"

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

		// Initialize Google Analytics with a 120-second dispatch interval. There is a
		// tradeoff between battery usage and timely dispatch.
		[GAI sharedInstance].debug = YES;
		[GAI sharedInstance].dispatchInterval = 120;
		[GAI sharedInstance].trackUncaughtExceptions = YES;
		self.tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingId];

		NSLog(@"{googleAnalytics} Initialized with manifest googleTrackingID: '%@'", trackingId);
	}
	@catch (NSException *exception) {
		NSLog(@"{googleAnalytics} Failure to get ios:googleTrackingID key from manifest file: %@", exception);
	}
}

- (void) track:(NSDictionary *)jsonObject {
	@try {
		NSString *eventName = [jsonObject valueForKey:@"eventName"];

		NSDictionary *evtParams = [jsonObject objectForKey:@"params"];

		if ([evtParams count] == 1) {
			NSString *key0 = [[evtParams allKeys] objectAtIndex:0];
			NSString *value0 = [[evtParams allValues] objectAtIndex:0];

			[self.tracker sendEventWithCategory:eventName
									 withAction:key0
									  withLabel:value0
									  withValue:nil];

			NSLOG(@"{googleAnalytics} Delivered event '%@' : action=%@ label=%@", eventName, key0, value0);
		} else {
			NSString *jsonString = [evtParams JSONString];

			[self.tracker sendEventWithCategory:eventName
									 withAction:@"JSON"
									  withLabel:jsonString
									  withValue:nil];

			NSLOG(@"{googleAnalytics} Delivered event '%@' : action=JSON label=%@", eventName, jsonString);
		}
	}
	@catch (NSException *exception) {
		NSLOG(@"{googleAnalytics} Exception while processing event: ", exception);
	}
}

- (void) trackScreen:(NSDictionary *)jsonObject {
	@try {
		NSString *screenName = [jsonObject valueForKey:@"screenName"];
		[self.tracker sendView:screenName];
		NSLOG(@"{googleAnalytics} Delivered screen '%@'", screenName);
	}
	@catch (NSException *exception) {
		NSLOG(@"{googleAnalytics} Exception while processing screen: ", exception);
	}
}

@end
