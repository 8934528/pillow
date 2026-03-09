import React from 'react';
import { StyleSheet, TouchableOpacity, ScrollView } from 'react-native';
import { ThemedView } from '@/components/themed-view';
import { ThemedText } from '@/components/themed-text';
import { PillowColors } from '@/constants/colors';
import { FilterTab } from '@/types/music';
import Animated, { FadeIn, FadeOut } from 'react-native-reanimated';

interface FilterTabsProps {
  activeTab: FilterTab;
  onTabChange: (tab: FilterTab) => void;
}

const tabs: { key: FilterTab; label: string; icon: string }[] = [
  { key: 'songs', label: 'Songs', icon: '🎵' },
  { key: 'albums', label: 'Albums', icon: '💿' },
  { key: 'artists', label: 'Artists', icon: '👤' },
  { key: 'folders', label: 'Folders', icon: '📁' },
  { key: 'favourites', label: 'Favourites', icon: '❤️' },
];

export function FilterTabs({ activeTab, onTabChange }: FilterTabsProps) {
  return (
    <ThemedView style={styles.container}>
      <ScrollView 
        horizontal 
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.scrollContent}
      >
        {tabs.map((tab) => (
          <TouchableOpacity
            key={tab.key}
            style={[
              styles.tab,
              activeTab === tab.key && styles.activeTab,
            ]}
            onPress={() => onTabChange(tab.key)}
            activeOpacity={0.7}
          >
            <ThemedText style={styles.tabIcon}>{tab.icon}</ThemedText>
            <ThemedText style={[
              styles.tabLabel,
              activeTab === tab.key && styles.activeTabLabel,
            ]}>
              {tab.label}
            </ThemedText>
            {activeTab === tab.key && (
              <Animated.View 
                style={styles.activeIndicator}
                entering={FadeIn}
                exiting={FadeOut}
              />
            )}
          </TouchableOpacity>
        ))}
      </ScrollView>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingVertical: 8,
    borderBottomWidth: 1,
    borderBottomColor: '#E0E0E0',
  },
  scrollContent: {
    paddingHorizontal: 16,
    gap: 16,
  },
  tab: {
    alignItems: 'center',
    paddingVertical: 8,
    paddingHorizontal: 16,
    borderRadius: 20,
    position: 'relative',
  },
  activeTab: {
    backgroundColor: PillowColors.lemon,
  },
  tabIcon: {
    fontSize: 20,
    marginBottom: 4,
  },
  tabLabel: {
    fontSize: 12,
    fontWeight: '500',
  },
  activeTabLabel: {
    color: PillowColors.green,
    fontWeight: '600',
  },
  activeIndicator: {
    position: 'absolute',
    bottom: -2,
    width: 4,
    height: 4,
    borderRadius: 2,
    backgroundColor: PillowColors.green,
  },
});
