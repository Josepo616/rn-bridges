import RnBridge from './NativeRnBridge';

export function multiply(a: number, b: number): number {
  return RnBridge.multiply(a, b);
}
