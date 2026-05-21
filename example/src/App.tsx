import { Text, View, StyleSheet } from 'react-native';
import { greet } from 'rn-bridge';

const greeting = greet('Jose');

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{greeting}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
