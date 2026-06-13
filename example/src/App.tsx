import { Text, View, StyleSheet, Pressable } from 'react-native';
import { greet, triggerHaptic, type HapticType } from 'rn-bridge';

const HAPTIC_TYPES: HapticType[] = [
  'light',
  'medium',
  'heavy',
  'success',
  'warning',
  'error',
];

export default function App() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>RnBridge Demo</Text>
      <Text style={styles.greeting}>{greet('Ravn iOS Team')}</Text>

      <Text style={styles.subtitle}>Tap to feel</Text>

      <View style={styles.grid}>
        {HAPTIC_TYPES.map((type) => (
          <Pressable
            key={type}
            style={styles.button}
            onPress={() => triggerHaptic(type)}
          >
            <Text style={styles.buttonText}>{type}</Text>
          </Pressable>
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
    gap: 16,
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
  },
  greeting: {
    fontSize: 16,
    color: '#666',
  },
  subtitle: {
    fontSize: 18,
    marginTop: 24,
    marginBottom: 8,
  },
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
    justifyContent: 'center',
  },
  button: {
    backgroundColor: '#007AFF',
    paddingVertical: 14,
    paddingHorizontal: 24,
    borderRadius: 12,
    minWidth: 110,
    alignItems: 'center',
  },
  buttonText: {
    color: 'white',
    fontWeight: '600',
    textTransform: 'capitalize',
  },
});
