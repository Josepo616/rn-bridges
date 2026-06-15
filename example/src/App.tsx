import { useState } from 'react';
import { Text, View, StyleSheet, Pressable, SafeAreaView } from 'react-native';
import {
  greet,
  triggerHaptic,
  getHapticHistory,
  type HapticType,
  type HapticEvent,
  presentHapticHistory,
} from 'rn-bridge';

const HAPTIC_TYPES: HapticType[] = [
  'light',
  'medium',
  'heavy',
  'success',
  'warning',
  'error',
];

export default function App() {
  const [, setHistory] = useState<HapticEvent[]>([]);

  const handleHaptic = async (type: HapticType) => {
    await triggerHaptic(type);
    refreshHistory();
  };

  const refreshHistory = () => {
    const events = getHapticHistory(20);
    setHistory(events);
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <Text style={styles.title}>RnBridge Demo</Text>
        <Text style={styles.greeting}>{greet('Ravn iOS Team')}</Text>

        <View style={styles.grid}>
          {HAPTIC_TYPES.map((type) => (
            <Pressable
              key={type}
              style={styles.button}
              onPress={() => handleHaptic(type)}
            >
              <Text style={styles.buttonText}>{type}</Text>
            </Pressable>
          ))}
        </View>

        <Pressable
          style={[styles.button, styles.historyButton]}
          onPress={() => presentHapticHistory()}
        >
          <Text style={styles.buttonText}>View History</Text>
        </Pressable>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#111',
  },

  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 24,
  },

  title: {
    fontSize: 30,
    fontWeight: '700',
    color: '#FFF',
    marginBottom: 8,
  },

  greeting: {
    fontSize: 16,
    color: '#AAA',
    marginBottom: 28,
    textAlign: 'center',
  },

  grid: {
    width: '100%',
    maxWidth: 360,
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'center',
    gap: 12,
  },

  button: {
    backgroundColor: '#007AFF',
    minWidth: 100,
    paddingVertical: 14,
    paddingHorizontal: 20,
    borderRadius: 12,
    alignItems: 'center',
  },

  historyButton: {
    marginTop: 20,
    width: '100%',
    maxWidth: 336,
    backgroundColor: '#34C759',
  },

  buttonText: {
    color: '#FFF',
    fontWeight: '600',
    textTransform: 'capitalize',
  },
});
