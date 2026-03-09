import React from 'react';
import {
  Modal,
  StyleSheet,
  TouchableOpacity,
  View,
  TouchableWithoutFeedback,
} from 'react-native';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { PillowColors } from '@/constants/colors';
import Animated, { FadeIn, FadeOut } from 'react-native-reanimated';

interface OptionsModalProps {
  visible: boolean;
  onClose: () => void;
  onVisualize: () => void;
  onShare: () => void;
  onDelete: () => void;
  songTitle?: string;
}

export function OptionsModal({
  visible,
  onClose,
  onVisualize,
  onShare,
  onDelete,
  songTitle,
}: OptionsModalProps) {
  return (
    <Modal
      visible={visible}
      transparent
      animationType="fade"
      onRequestClose={onClose}
    >
      <TouchableWithoutFeedback onPress={onClose}>
        <View style={styles.overlay}>
          <TouchableWithoutFeedback>
            <Animated.View 
              style={styles.modalContent}
              entering={FadeIn}
              exiting={FadeOut}
            >
              <ThemedView style={styles.container}>
                {songTitle && (
                  <View style={styles.header}>
                    <ThemedText style={styles.songTitle} numberOfLines={1}>
                      {songTitle}
                    </ThemedText>
                  </View>
                )}

                <TouchableOpacity
                  style={styles.option}
                  onPress={() => {
                    onVisualize();
                    onClose();
                  }}
                >
                  <ThemedText style={styles.optionIcon}>📊</ThemedText>
                  <ThemedText style={styles.optionText}>Visualization</ThemedText>
                </TouchableOpacity>

                <TouchableOpacity
                  style={styles.option}
                  onPress={() => {
                    onShare();
                    onClose();
                  }}
                >
                  <ThemedText style={styles.optionIcon}>📤</ThemedText>
                  <ThemedText style={styles.optionText}>Share</ThemedText>
                </TouchableOpacity>

                <TouchableOpacity
                  style={[styles.option, styles.deleteOption]}
                  onPress={() => {
                    onDelete();
                    onClose();
                  }}
                >
                  <ThemedText style={styles.optionIcon}>🗑️</ThemedText>
                  <ThemedText style={[styles.optionText, styles.deleteText]}>
                    Delete
                  </ThemedText>
                </TouchableOpacity>

                <TouchableOpacity style={styles.cancelButton} onPress={onClose}>
                  <ThemedText style={styles.cancelText}>Cancel</ThemedText>
                </TouchableOpacity>
              </ThemedView>
            </Animated.View>
          </TouchableWithoutFeedback>
        </View>
      </TouchableWithoutFeedback>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalContent: {
    width: '80%',
    maxWidth: 400,
  },
  container: {
    borderRadius: 12,
    padding: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
  },
  header: {
    paddingBottom: 12,
    marginBottom: 8,
    borderBottomWidth: 1,
    borderBottomColor: '#E0E0E0',
  },
  songTitle: {
    fontSize: 16,
    fontWeight: '600',
  },
  option: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 14,
    paddingHorizontal: 8,
    borderRadius: 8,
  },
  optionIcon: {
    fontSize: 20,
    marginRight: 12,
    width: 28,
  },
  optionText: {
    fontSize: 16,
  },
  deleteOption: {
    marginTop: 4,
  },
  deleteText: {
    color: '#FF3B30',
  },
  cancelButton: {
    marginTop: 12,
    paddingVertical: 14,
    alignItems: 'center',
    borderRadius: 8,
    backgroundColor: PillowColors.lightGrey,
  },
  cancelText: {
    fontSize: 16,
    fontWeight: '600',
    color: PillowColors.darkGrey,
  },
});
