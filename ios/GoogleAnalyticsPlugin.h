#import "PluginManager.h"
#import "GAI.h"

@interface GoogleAnalyticsPlugin : GCPlugin

@property(nonatomic, retain) id<GAITracker> tracker;

@end
