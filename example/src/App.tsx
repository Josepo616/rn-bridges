import { useEffect, useState, useRef } from 'react';
import {
  Text,
  View,
  StyleSheet,
  Pressable,
  SafeAreaView,
  Animated,
} from 'react-native';
import {
  greet,
  triggerHaptic,
  getHapticHistory,
  type HapticType,
  type HapticEvent,
  presentHapticHistory,
  getCurrentNetworkStatus,
  subscribeToNetworkChanges,
  presentNetworkDetails,
  type NetworkStatus,
} from 'rn-bridge';

const RAVN = {
  primary: '#161616',
  onPrimary: '#FFFFFF',
  secondary: '#ADB5BD',
  gold: '#B7986A',
  surface: '#1E1E1E',
};

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
  const [network, setNetwork] = useState<NetworkStatus | null>(null);

  const colorAnim = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    getCurrentNetworkStatus().then(setNetwork).catch(console.error);
    const sub = subscribeToNetworkChanges((status) => {
      console.log('Network changed:', status);
      setNetwork(status);
      colorAnim.setValue(0.4);
      Animated.timing(colorAnim, {
        toValue: 1,
        duration: 350,
        useNativeDriver: true,
      }).start();
    });
    return () => sub.remove();
  }, [colorAnim]);

  const handleHaptic = async (type: HapticType) => {
    await triggerHaptic(type);
    refreshHistory();
  };

  const refreshHistory = () => {
    setHistory(getHapticHistory(20));
  };

  const isUp = network?.isConnected ?? false;

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        {/* Header */}
        <View style={styles.header}>
          <View style={styles.eyebrowRule} />
          <Text style={styles.eyebrow}>RN BRIDGE · DEMO</Text>
          <Text style={styles.title}>Native bridges,{'\n'}live.</Text>
          <Text style={styles.greeting}>{greet('Ravn iOS Team')}</Text>
        </View>

        {/* Haptics */}
        <Text style={styles.sectionLabel}>HAPTICS · JS → SWIFT</Text>
        <View style={styles.grid}>
          {HAPTIC_TYPES.map((type) => (
            <Pressable
              key={type}
              style={({ pressed }) => [
                styles.chip,
                pressed && styles.chipPressed,
              ]}
              onPress={() => handleHaptic(type)}
            >
              <Text style={styles.chipText}>{type}</Text>
            </Pressable>
          ))}
        </View>

        <Pressable
          style={({ pressed }) => [
            styles.primaryBtn,
            pressed && styles.primaryBtnPressed,
          ]}
          onPress={() => presentHapticHistory()}
        >
          <Text style={styles.primaryBtnText}>VIEW HISTORY</Text>
        </Pressable>

        {/* Network */}
        <Text style={styles.sectionLabel}>NETWORK · SWIFT → JS</Text>
        <Pressable onPress={() => presentNetworkDetails()}>
          <Animated.View style={[styles.networkCard, { opacity: colorAnim }]}>
            <View style={styles.networkRow}>
              <View
                style={[
                  styles.statusDot,
                  { backgroundColor: isUp ? RAVN.gold : RAVN.secondary },
                ]}
              />
              <Text style={styles.networkType}>
                {network ? network.type.toUpperCase() : '…'}
              </Text>
              <Text style={styles.networkState}>
                {network ? (isUp ? 'CONNECTED' : 'OFFLINE') : ''}
              </Text>
            </View>
            <Text style={styles.networkHint}>TAP FOR DETAILS →</Text>
          </Animated.View>
        </Pressable>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: RAVN.primary },
  container: { flex: 1, paddingHorizontal: 24, paddingTop: 16, gap: 28 },

  // Header
  header: { gap: 8 },
  eyebrowRule: {
    width: 40,
    height: 2,
    backgroundColor: RAVN.gold,
    marginBottom: 8,
  },
  eyebrow: {
    color: RAVN.gold,
    fontSize: 12,
    fontWeight: '600',
    letterSpacing: 2,
  },
  title: {
    color: RAVN.onPrimary,
    fontSize: 40,
    fontWeight: '800',
    lineHeight: 44,
    marginTop: 4,
  },
  greeting: { color: RAVN.secondary, fontSize: 15, marginTop: 4 },

  // Section labels
  sectionLabel: {
    color: RAVN.gold,
    fontSize: 12,
    fontWeight: '600',
    letterSpacing: 2,
  },

  // Haptic chips
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10, marginTop: -16 },
  chip: {
    borderWidth: 1,
    borderColor: RAVN.secondary,
    paddingVertical: 12,
    paddingHorizontal: 18,
    borderRadius: 4,
    minWidth: 96,
    alignItems: 'center',
  },
  chipPressed: { backgroundColor: RAVN.gold, borderColor: RAVN.gold },
  chipText: {
    color: RAVN.onPrimary,
    fontWeight: '600',
    fontSize: 13,
    letterSpacing: 1,
    textTransform: 'uppercase',
  },

  // Primary button (white on dark, Ravn CTA)
  primaryBtn: {
    backgroundColor: RAVN.onPrimary,
    height: 52,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: -16,
  },
  primaryBtnPressed: { opacity: 0.85 },
  primaryBtnText: {
    color: RAVN.primary,
    fontWeight: '600',
    letterSpacing: 2,
    fontSize: 13,
  },

  // Network card
  networkCard: {
    borderWidth: 1,
    borderColor: RAVN.secondary,
    borderRadius: 4,
    padding: 20,
    gap: 14,
    marginTop: -16,
  },
  networkRow: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  statusDot: { width: 12, height: 12, borderRadius: 6 },
  networkType: {
    color: RAVN.onPrimary,
    fontSize: 20,
    fontWeight: '800',
    letterSpacing: 1,
  },
  networkState: {
    color: RAVN.secondary,
    fontSize: 12,
    fontWeight: '600',
    letterSpacing: 1.5,
    marginLeft: 'auto',
  },
  networkHint: {
    color: RAVN.gold,
    fontSize: 11,
    fontWeight: '600',
    letterSpacing: 1.5,
  },
});
