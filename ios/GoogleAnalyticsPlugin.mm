#import "AdMobPlugin.h"
#import "GAI.h"

@implementation AdMobPlugin

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
		NSString *trackingId = [ios valueForKey:@"adMobTrackingId"];

		// Initialize Google Analytics with a 120-second dispatch interval. There is a
		// tradeoff between battery usage and timely dispatch.
		[GAI sharedInstance].debug = YES;
		[GAI sharedInstance].dispatchInterval = 120;
		[GAI sharedInstance].trackUncaughtExceptions = YES;
		self.tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingId];

		NSLog(@"{admob} Initialized with manifest adMobTrackingId: '%@'", trackingId);
	}
	@catch (NSException *exception) {
		NSLog(@"{admob} Failure to get ios:adMobTrackingId key from manifest file: %@", exception);
	}
}

- (void) track:(NSDictionary *)jsonObject {
	@try {
		NSString *eventName = [jsonObject valueForKey:@"eventName"];
		
		NSDictionary *evtParams = [jsonObject objectForKey:@"params"];
		[self.tracker send:eventName params:evtParams];
		NSLOG(@"{admob} Delivered event '%@' with %d params", eventName, (int)[evtParams count]);
	}
	@catch (NSException *exception) {
		NSLOG(@"{admob} Exception while processing event: ", exception);
	}
}

@end
