import { useEffect, useState } from 'react';
import {
  Text,
  View,
  StyleSheet,
  Pressable,
  SafeAreaView,
  ScrollView,
} from 'react-native';

import {
  greet,
  triggerHaptic,
  getCurrentNetworkStatus,
  subscribeToNetworkChanges,
  presentHapticHistory,
  type HapticType,
  type NetworkStatus,
} from 'rn-bridge';

const HAPTIC_TYPES: HapticType[] = [
  'light',
  'medium',
  'heavy',
  'success',
  'warning',
  'error',
];

const HAPTIC_ICONS = {
  light: '🤏',
  medium: '👆',
  heavy: '💥',
  success: '✅',
  warning: '⚠️',
  error: '❌',
};

export default function App() {
  const [network, setNetwork] = useState<NetworkStatus | null>(null);

  useEffect(() => {
    getCurrentNetworkStatus().then(setNetwork);

    const sub = subscribeToNetworkChanges((status) => {
      setNetwork(status);
    });

    return () => sub.remove();
  }, []);

  const handleHaptic = async (type: HapticType) => {
    await triggerHaptic(type);
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView
        contentContainerStyle={styles.content}
        showsVerticalScrollIndicator={false}
      >
        <Text style={styles.title}>RN Bridge</Text>

        <Text style={styles.subtitle}>{greet('Ravn iOS Team')}</Text>

        <View style={styles.card}>
          <Text style={styles.sectionTitle}>Haptic Feedback</Text>

          <View style={styles.grid}>
            {HAPTIC_TYPES.map((type) => (
              <Pressable
                key={type}
                style={({ pressed }) => [
                  styles.hapticButton,
                  pressed && styles.pressed,
                ]}
                onPress={() => handleHaptic(type)}
              >
                <Text style={styles.emoji}>{HAPTIC_ICONS[type]}</Text>

                <Text style={styles.hapticText}>{type}</Text>
              </Pressable>
            ))}
          </View>
        </View>

        <View style={styles.card}>
          <Text style={styles.sectionTitle}>Network Status</Text>

          <View style={styles.networkRow}>
            <View
              style={[
                styles.statusDot,
                {
                  backgroundColor: network?.isConnected ? '#22C55E' : '#EF4444',
                },
              ]}
            />

            <Text style={styles.networkText}>
              {network ? `${network.type}` : 'Checking network...'}
            </Text>
          </View>
        </View>

        <Pressable
          style={({ pressed }) => [
            styles.historyButton,
            pressed && styles.pressed,
          ]}
          onPress={presentHapticHistory}
        >
          <Text style={styles.historyText}>View Haptic History</Text>
        </Pressable>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#0F172A',
  },

  content: {
    padding: 24,
    paddingTop: 40,
  },

  title: {
    fontSize: 34,
    fontWeight: '800',
    color: '#FFF',
  },

  subtitle: {
    fontSize: 16,
    color: '#94A3B8',
    marginTop: 8,
    marginBottom: 32,
  },

  card: {
    backgroundColor: '#1E293B',
    borderRadius: 24,
    padding: 20,
    marginBottom: 20,
  },

  sectionTitle: {
    color: '#FFF',
    fontSize: 18,
    fontWeight: '700',
    marginBottom: 16,
  },

  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },

  hapticButton: {
    flexGrow: 1,
    minWidth: '30%',
    backgroundColor: '#334155',
    borderRadius: 18,
    paddingVertical: 18,
    alignItems: 'center',
  },

  emoji: {
    fontSize: 24,
    marginBottom: 8,
  },

  hapticText: {
    color: '#FFF',
    fontWeight: '600',
    textTransform: 'capitalize',
  },

  networkRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },

  statusDot: {
    width: 12,
    height: 12,
    borderRadius: 6,
    marginRight: 10,
  },

  networkText: {
    color: '#FFF',
    fontSize: 16,
    textTransform: 'capitalize',
  },

  historyButton: {
    backgroundColor: '#2563EB',
    paddingVertical: 18,
    borderRadius: 20,
    alignItems: 'center',
  },

  historyText: {
    color: '#FFF',
    fontWeight: '700',
    fontSize: 16,
  },

  pressed: {
    opacity: 0.75,
    transform: [{ scale: 0.97 }],
  },
});
