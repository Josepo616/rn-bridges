import { TurboModuleRegistry, type TurboModule } from 'react-native';

export type HapticEvent = {
  type: string;
  timestamp: number; // Epoch time in milliseconds
};

export interface Spec extends TurboModule {
  multiply(a: number, b: number): number;
  greet(name: string): string;
  triggerHaptic(type: string): Promise<void>;
  getHapticHistory(limit: number): HapticEvent[];
  presentHapticHistory(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RnBridge');
