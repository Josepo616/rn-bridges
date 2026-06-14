#import "RnBridge.h"
#import "RnBridge-swift.h"

@implementation RnBridge

- (NSNumber *)multiply:(double)a b:(double)b {
  NSNumber *result = @(a * b);
  return result;
}

- (NSString *)greet: (NSString *)name {
  return [[RnBridgeImpl shared] greet:name];
}

- (void)triggerHaptic:(NSString *)type {
  [[RnBridgeImpl shared] triggerHapticWithType:type];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeRnBridgeSpecJSI>(params);
}

+ (NSString *)moduleName {
  return @"RnBridge";
}

@end
