import RnBridge from './NativeRnBridge';

export function multiply(a: number, b: number): number {
  return RnBridge.multiply(a, b);
}

export function greet(name: string): string {
  return RnBridge.greet(name);
}

export type HapticType =
  | 'light'
  | 'medium'
  | 'heavy'
  | 'success'
  | 'warning'
  | 'error';

export function triggerHaptic(type: HapticType): void {
  RnBridge.triggerHaptic(type);
}
