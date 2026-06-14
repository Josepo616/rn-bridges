import type { TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  multiply(a: number, b: number): number;
  greet(name: string): string;
  triggerHaptic(type: string): void;
}

// Web implementation - no-op or return mock values
export default {
  multiply: (a: number, b: number) => a * b,
  greet: (name: string) => `Hello, ${name}!`,
  triggerHaptic: (type: string) => console.log(`Haptic (web): ${type}`),
};
