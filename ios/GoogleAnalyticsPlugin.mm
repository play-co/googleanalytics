#import "GoogleAnalyticsPlugin.h"
#import "GAI.h"

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
		[self.tracker send:eventName params:evtParams];
		NSLOG(@"{googleAnalytics} Delivered event '%@' with %d params", eventName, (int)[evtParams count]);
	}
	@catch (NSException *exception) {
		NSLOG(@"{googleAnalytics} Exception while processing event: ", exception);
	}
}

@end
