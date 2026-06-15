import RnBridge from './NativeRnBridge';
import type { HapticEvent } from './NativeRnBridge';

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

export function triggerHaptic(type: HapticType): Promise<void> {
  return RnBridge.triggerHaptic(type);
}

export function getHapticHistory(limit: number = 0): HapticEvent[] {
  return RnBridge.getHapticHistory(limit);
}

export function presentHapticHistory(): void {
  RnBridge.presentHapticHistory();
}

export type { HapticEvent };
