//  Based on the example provided by Nicholas Lauer 

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define UBEEXPERIMENT_NAMES_APP \
  X(UBExperimentNameSomething, @"some_random_experiment")

#define X(name, value) extern NSString *const name;
UBEEXPERIMENT_NAMES_APP
#undef X

@interface Test : NSObject

- (id)andReturn:(id)anObject;
- (id)andReturnValue:(NSValue *)aValue;

@property (nonatomic, readonly) Test *(^ _andReturn)(id);

@end

@protocol UBCachedExperimenting

- (BOOL)isValidExperiment:(NSString *)experimentKey;

- (BOOL)isInControlGroupForExperiment:(NSString *)experimentKey;

- (BOOL)isTreatedForExperiment:(NSString *)experimentKey;

- (BOOL)isInTreatmentGroup:(NSString *)treatmentGroupKey
             forExperiment:(NSString *)experimentKey;

- (nullable NSString *)stringParameter:(NSString *)parameterName
                         forExperiment:(NSString *)experimentKey
                      withDefaultValue:(nullable NSString *)defaultValue;

- (nullable NSNumber *)numberParameter:(NSString *)parameterName
                         forExperiment:(NSString *)experimentKey
                      withDefaultValue:(nullable NSNumber *)defaultValue;

- (void)sendInclusionEventForExperiment:(NSString *)experimentKey;

- (void)sendInclusionEventForExperiment:(NSString *)experimentKey
                      forTreatmentGroup:(NSString *)treatmentGroupKey;

@end


@interface UBEExperimentExamples : NSObject

@property(nonatomic, readonly) id<UBCachedExperimenting> experiments;
@property(nonatomic, readonly) id experimentsMock;

@end

@implementation UBEExperimentExamples

- (void)featureFlag_treated {
  if ([self.experiments
          isTreatedForExperiment:UBExperimentNameSomething]) {
    NSLog(@"1");
  }

  if ([self.experiments
          isTreatedForExperiment:UBExperimentNameSomething] || true) {
    NSLog(@"2");
  }

  if ([self.experiments
          isTreatedForExperiment:UBExperimentNameSomething] && true) {
    NSLog(@"3");
  }

  if ([self.experiments
          isTreatedForExperiment:UBExperimentNameSomething] || false) {
    NSLog(@"4");
  }

  if ([self.experiments
          isTreatedForExperiment:UBExperimentNameSomething] && false) {
    NSLog(@"5");
  }

  if (![self.experiments
          isTreatedForExperiment:UBExperimentNameSomething]) {
    NSLog(@"6");
  } else {
    NSLog(@"7");
  }

  if (![self.experiments
          isTreatedForExperiment:UBExperimentNameSomething] || true) {
    NSLog(@"8");
  }

  if (![self.experiments
          isTreatedForExperiment:UBExperimentNameSomething] && true) {
    NSLog(@"9");
  }

  if (![self.experiments
          isTreatedForExperiment:UBExperimentNameSomething] || false) {
    NSLog(@"10");
  }

  if (![self.experiments
          isTreatedForExperiment:UBExperimentNameSomething] && false) {
    NSLog(@"11");
  }

  if (false || ![self.experiments
          isTreatedForExperiment:UBExperimentNameSomething]) {
    NSLog(@"12");
  }

  int x;
  if (x || ![self.experiments
          isTreatedForExperiment:UBExperimentNameSomething]) {
    NSLog(@"13");
  }

  if (x && [self.experiments
          isTreatedForExperiment:UBExperimentNameSomething]) {
    NSLog(@"14");
  }

}

- (void)featureFlag_control {
  if (![self.experiments isInControlGroupForExperiment:
                            UBExperimentNameSomething]) {
    NSLog(@"control");
  }
}

// Group names are TODO
- (void)featureFlag_specificGroup {
  if ([self.experiments
          isInTreatmentGroup:@"groupname"
               forExperiment:UBExperimentNameSomething]) {
    NSLog(@"treated for groupname treatment group");
  }
}

// Non boolean returns are TODO
- (void)featureFlag_stringParameter {
  NSString *string = [self.experiments
       stringParameter:@"param_name"
         forExperiment:UBExperimentNameSomething
      withDefaultValue:@"default"];
  NSLog(@"%@", string);
}

- (void)featureFlag_numberParameter {
  NSNumber *number = [self.experiments
       numberParameter:@"param_name"
         forExperiment:UBExperimentNameSomething
      withDefaultValue:@2];
  NSLog(@"%@", number);
}

- (void)featureFlag_inclusions {
  [self.experiments sendInclusionEventForExperiment:
                        UBExperimentNameSomething];
  [self.experiments
      sendInclusionEventForExperiment:UBExperimentNameSomething
                    forTreatmentGroup:@"groupname"];
}

#pragma mark - Tests


- (void)featureFlag_test {
  [self enableFeatureFlagNamed:UBExperimentNameSomething];
  [self disableExperimentNamed:UBExperimentNameSomething];
  [self setNumberParameter:@"" value:@2 forExperimentNamed:@""];
  [self enableExperimentNamed:@"experiment"
            forTreatmentGroup:@"treatmentGroup"];
}


- (void)featureFlag_variants {
  [self testAllFeatureFlagVariants:^(NSArray<NSString *> *enabledFlags) {
  }
                  featureFlagNames:@[
                    UBExperimentNameSomething
                  ]];
}

- (void)featureFlag_snapshotVariants {
  [self snapshotTestAllFeatureFlagVariants:^(NSArray<NSString *> *enabledFlags,
                                             NSString *identifier) {
    // test code
  }
                          featureFlagNames:@[
                            UBExperimentNameSomething
                          ]];
}

#pragma mark - helpers

// Enable a feature flag for all treatment groups. Cleared at the end of every
// test
- (void)enableFeatureFlagNamed:(NSString *)name {
  return;
}

// Enable an experiment for one treatment group. Cleared at the end of every
// test
- (void)enableExperimentNamed:(NSString *)name
            forTreatmentGroup:(NSString *)treatmentGroup {
  return;
}

// Enable an experiment for one treatment group. Cleared at the end of every
// test
- (void)setNumberParameter:(NSString *)parameterName
                     value:(NSNumber *)number
        forExperimentNamed:(NSString *)name {
  return;
}

/** Puts experiment in control */
 - (void)disableExperimentNamed:(NSString *)name {
  return;
}

typedef void (^FeatureFlagTestBlock)(NSArray<NSString *> *enabledFlags);
typedef void (^SnapshotTestBlock)(NSArray<NSString *> *enabledFlags,
                                  NSString *identifier);

// Runs the test block with all possible combinations of experiments enabled and
// disabled.
- (void)testAllFeatureFlagVariants:(FeatureFlagTestBlock)testBlock
                  featureFlagNames:(NSArray<NSString *> *)featureFlagNames {
  return;
}

// Runs the test block with all possible combinations of experiments enabled and
// disabled. Passes in an identifier for the snapshot
- (void)snapshotTestAllFeatureFlagVariants:(SnapshotTestBlock)testBlock
                          featureFlagNames:
                              (NSArray<NSString *> *)featureFlagNames {
  return;
}

@end
