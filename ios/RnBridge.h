#import <RnBridgeSpec/RnBridgeSpec.h>
#import "RnBridge-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface RnBridge : NativeRnBridgeSpecBase <NativeRnBridgeSpec, RnBridgeNetworkDelegate>
@end

NS_ASSUME_NONNULL_END
