# React Native Expo Project Makefile

.PHONY: check start web

check:
	@echo "Checking required tools..."
	@node -v || echo "Node.js is not installed"
	@npm -v || echo "npm is not installed"
	@npx expo --version || echo "Expo CLI not available"

start:
	@echo "Starting Expo app with cleared cache..."
	npx expo start -c

web:
	@echo "Starting Expo web version..."
	npx expo start --web

