#import "RnBridge.h"
#import <CoreData/CoreData.h>
#import "RnBridge-Swift.h"

@implementation RnBridge

- (NSNumber *)multiply:(double)a b:(double)b {
  NSNumber *result = @(a * b);
  return result;
}

- (NSString *)greet: (NSString *)name {
  return [[RnBridgeImpl shared] greet:name];
}

- (void)triggerHaptic:(NSString *)type
                resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject {
  [[RnBridgeImpl shared] triggerHapticWithType:type
                                       resolve:^(id _Nullable result){
    resolve(result);
  } reject:^(NSString *code, NSString *message, NSError *error) {
    reject(code, message, error);
  }];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeRnBridgeSpecJSI>(params);
}

- (NSArray<NSDictionary *> *)getHapticHistory:(double)limit{
  return [[RnBridgeImpl shared] getHapticHistoryWithLimit:(NSInteger)limit];
}

- (void)presentHapticHistory {
  [[RnBridgeImpl shared] presentHapticHistory];
}

- (instancetype)init {
  if ( self = [super init]) {
    [RnBridgeImpl shared].networkDelegate = self;
    [[RnBridgeImpl shared] startMonitoring];
  }
  return self;
}

- (void)getCurrentNetworkStatus:(RCTPromiseResolveBlock)resolve
                         reject:(RCTPromiseRejectBlock)reject {
  [[RnBridgeImpl shared] getCurrentNetworkStatusWithResolve:^(id _Nullable result){
    resolve(result);
  } reject:^(NSString *code, NSString *message, NSError *error) {
    reject(code, message, error);
  }];
}

- (void)presentNetworkDetails {
  [[RnBridgeImpl shared] presentNetworkDetails];
}

- (void)sendNetworkChanged:(NSDictionary *)status {
  [self emitOnNetworkChanged:status];
}

+ (NSString *)moduleName {
  return @"RnBridge";
}

@end
