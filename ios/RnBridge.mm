#import "RnBridge.h"

@implementation RnBridge
- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);

    return result;
}

- (NSString *)greet:(NSString *)name {
    return [NSString stringWithFormat:@"Hello from Swift wrapper, %@!", name];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRnBridgeSpecJSI>(params);
}

+ (NSString *)moduleName
{
  return @"RnBridge";
}

@end
