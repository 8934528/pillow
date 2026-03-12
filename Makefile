# React Native Expo Project Makefile

.PHONY: all check install start web android ios doctor lint clean reset




# Default command (runs everything needed to start the app)
all: check install start




# --------------------------------------------------
# Check required tools
# --------------------------------------------------
check:
	@echo "Checking required development tools..."

	@if command -v node >/dev/null 2>&1; then \
		echo "Node.js installed:"; \
		node -v; \
	else \
		echo "Node.js is NOT installed. Please install Node.js."; \
	fi

	@if command -v npm >/dev/null 2>&1; then \
		echo "npm installed:"; \
		npm -v; \
	else \
		echo "npm is NOT installed."; \
	fi

	@if npx expo --version >/dev/null 2>&1; then \
		echo "Expo CLI available:"; \
		npx expo --version; \
	else \
		echo "Expo CLI will be installed automatically when running Expo commands."; \
	fi








# --------------------------------------------------
# Install dependencies only if missing
# --------------------------------------------------
install:
	@echo "Checking project dependencies..."

	@if [ ! -d "node_modules" ]; then \
		echo "node_modules folder not found."; \
		echo "Installing project dependencies..."; \
		npm install; \
	else \
		echo "node_modules already exists. Dependencies appear installed."; \
	fi













# --------------------------------------------------
# Start Expo mobile app
# --------------------------------------------------
start:
	@echo "Starting Expo mobile development server..."
	@echo "Scan the QR code with Expo Go."
	npx expo start -c












# --------------------------------------------------
# Run Expo in web browser
# --------------------------------------------------
web: install
	@echo "Starting Expo Web..."
	npx expo start --web






# --------------------------------------------------
# Run Android emulator
# --------------------------------------------------
android: install
	@echo "Starting Android emulator..."
	npx expo start --android








# --------------------------------------------------
# Run iOS simulator (macOS only)
# --------------------------------------------------
ios: install
	@echo "Starting iOS simulator..."
	npx expo start --ios






# --------------------------------------------------
# Check project health
# --------------------------------------------------
doctor:
	@echo "Running Expo Doctor diagnostics..."
	npx expo doctor





# --------------------------------------------------
# Run ESLint if installed
# --------------------------------------------------
lint:
	@echo "Running ESLint..."

	@if command -v npx >/dev/null 2>&1; then \
		npx eslint . || echo "ESLint not configured in this project."; \
	else \
		echo "npx is not available."; \
	fi














# ==================================================
# Cleaning commands (Placed at the end intentionally)
# ==================================================

clean:
	@echo "Cleaning project build files..."

	@if [ -d "node_modules" ]; then \
		echo "Removing node_modules..."; \
		rm -rf node_modules; \
	else \
		echo "node_modules does not exist."; \
	fi

	@if [ -f "package-lock.json" ]; then \
		echo "Removing package-lock.json..."; \
		rm -f package-lock.json; \
	else \
		echo "package-lock.json not found."; \
	fi

	@if [ -d ".expo" ]; then \
		echo "Removing .expo cache..."; \
		rm -rf .expo; \
	fi


reset: clean
	@echo "Resetting project dependencies..."
	npm install
