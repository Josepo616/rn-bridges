import {
  TurboModuleRegistry,
  type CodegenTypes,
  type TurboModule,
} from 'react-native';

export type HapticEvent = {
  type: string;
  timestamp: number; // Epoch time in milliseconds
};

export interface NetworkStatus {
  isConnected: boolean;
  type: string; // 'wifi' | 'cellular' | 'other' | 'none'
  isExpensive: boolean;
  isConstrained: boolean;
  supportsIPv4: boolean;
  supportsIPv6: boolean;
  supportsDNS: boolean;
}

export interface Spec extends TurboModule {
  multiply(a: number, b: number): number;
  greet(name: string): string;
  triggerHaptic(type: string): Promise<void>;
  getHapticHistory(limit: number): HapticEvent[];
  presentHapticHistory(): void;
  getCurrentNetworkStatus(): Promise<NetworkStatus>;
  readonly onNetworkChanged: CodegenTypes.EventEmitter<NetworkStatus>;
  presentNetworkDetails(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RnBridge');
