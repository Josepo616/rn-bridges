import { TurboModuleRegistry, type TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  multiply(a: number, b: number): number;
  greet(name: string): string;
  triggerHaptic(type: string): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RnBridge');
