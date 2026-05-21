import RnBridge from './NativeRnBridge';

export function multiply(a: number, b: number): number {
  return RnBridge.multiply(a, b);
}

export function greet(name: string): string {
  return RnBridge.greet(name);
}
