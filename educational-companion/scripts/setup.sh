#!/bin/bash

# Educational Companion System Setup Script
# This script sets up the n8n-based educational companion system

set -e

echo "🎓 Educational Companion System Setup"
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create necessary directories
print_status "Creating directory structure..."
mkdir -p logs
mkdir -p backups
mkdir -p temp

# Check if .env file exists
if [ ! -f "config/.env" ]; then
    print_warning ".env file not found. Copying from .env.example..."
    cp config/.env.example config/.env
    print_warning "Please edit config/.env with your actual API keys and configuration before proceeding."
    read -p "Press Enter after updating the .env file to continue..."
fi

# Load environment variables
if [ -f "config/.env" ]; then
    export $(cat config/.env | grep -v '^#' | xargs)
fi

# Validate required environment variables
print_status "Validating configuration..."
required_vars=(
    "OPENAI_API_KEY"
    "DISCORD_BOT_TOKEN"
    "DISCORD_CHANNEL_ID"
    "GOOGLE_DRIVE_FOLDER_ID"
    "GOOGLE_DRIVE_NOTES_FOLDER_ID"
)

missing_vars=()
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ] || [ "${!var}" = "your-${var,,}-here" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
    print_error "The following required environment variables are missing or not configured:"
    for var in "${missing_vars[@]}"; do
        echo "  - $var"
    done
    print_error "Please update your config/.env file and run this script again."
    exit 1
fi

# Create database initialization script
print_status "Creating database initialization script..."
cat > scripts/init-db.sql << 'EOF'
-- Educational Companion Database Initialization
CREATE DATABASE IF NOT EXISTS n8n;
CREATE USER IF NOT EXISTS 'n8n'@'%' IDENTIFIED BY 'n8n_password';
GRANT ALL PRIVILEGES ON n8n.* TO 'n8n'@'%';
FLUSH PRIVILEGES;
EOF

# Pull Docker images
print_status "Pulling Docker images..."
docker-compose pull

# Start the services
print_status "Starting Educational Companion services..."
docker-compose up -d

# Wait for services to be ready
print_status "Waiting for services to start..."
sleep 30

# Check if n8n is accessible
print_status "Checking n8n accessibility..."
if curl -f http://localhost:5678 > /dev/null 2>&1; then
    print_status "n8n is accessible at http://localhost:5678"
else
    print_warning "n8n might still be starting up. Please check docker-compose logs if it doesn't become available soon."
fi

# Import workflows
print_status "Importing n8n workflows..."
echo "To import the workflows:"
echo "1. Open http://localhost:5678 in your browser"
echo "2. Login with your credentials (default: admin/changeme)"
echo "3. Go to Workflows > Import from File"
echo "4. Import the following files:"
echo "   - n8n-workflows/audio-transcription-workflow.json"
echo "   - n8n-workflows/discord-bot-workflow.json"

# Display setup completion message
echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "Services Status:"
docker-compose ps
echo ""
echo "Next Steps:"
echo "1. Configure your API credentials in n8n:"
echo "   - OpenAI API credentials"
echo "   - Discord Bot credentials"
echo "   - Google Drive OAuth2 credentials"
echo "   - Notion API credentials"
echo ""
echo "2. Import the workflows as described above"
echo ""
echo "3. Test the system by:"
echo "   - Uploading an audio file to your Google Drive folder"
echo "   - Sending a message to your Discord bot"
echo ""
echo "📚 Access n8n: http://localhost:5678"
echo "📖 Documentation: ./docs/"
echo "🔧 Configuration: ./config/.env"
echo ""
echo "Happy learning! 🎓"