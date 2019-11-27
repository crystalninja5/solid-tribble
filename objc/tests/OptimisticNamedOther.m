//  Based on the examples provided by Nicholas Lauer

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@protocol UBAdvancedExperimenting

- (BOOL)optimisticFeatureFlagEnabledForExperiment:(NSString *)experimentKey;

@end

@interface UBDependencyGraph : NSObject

+ (UBDependencyGraph *)currentGraph;

- (nullable id)implementationForProtocol:(Protocol *)protocol;

@end

/**
 See UBOptimisticNamedFeatureFlag. This is a helper macro.
 */
#define UBOptimisticNamedFeatureFlagIsEnabled(flagName)                  \
  ([[[UBDependencyGraph currentGraph]                                    \
      implementationForProtocol:@protocol(UBAdvancedExperimenting)]      \
      optimisticFeatureFlagEnabledForExperiment:                         \
          [NSString stringWithFormat:@"ios_%@_wide_optimistic_rollback", \
                                     [@ #flagName lowercaseString]]])

#define UBOptimisticNamedFeatureFlag(flagName) \
  if (UBOptimisticNamedFeatureFlagIsEnabled(flagName))


@implementation OptimisticTest

- (void)optimisticFeatureFlag_macro {
  UBOptimisticNamedFeatureFlag(optimistic_stale_flag) {
    NSLog(@"1");
  }
  else {
    NSLog(@"2");
  }
}

@end
