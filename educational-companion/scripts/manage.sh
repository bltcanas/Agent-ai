#!/bin/bash

# Educational Companion System Management Script
# Provides easy commands for managing the system

set -e

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

print_header() {
    echo -e "${BLUE}$1${NC}"
}

# Load environment variables if .env exists
if [ -f "config/.env" ]; then
    export $(cat config/.env | grep -v '^#' | xargs)
fi

# Function to show usage
show_usage() {
    print_header "🎓 Educational Companion System Manager"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start     - Start all services"
    echo "  stop      - Stop all services"
    echo "  restart   - Restart all services"
    echo "  status    - Show service status"
    echo "  logs      - Show logs (use 'logs [service]' for specific service)"
    echo "  update    - Update Docker images"
    echo "  backup    - Create system backup"
    echo "  restore   - Restore from backup"
    echo "  health    - Check system health"
    echo "  cleanup   - Clean up unused resources"
    echo "  reset     - Reset all data (DESTRUCTIVE)"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs n8n"
    echo "  $0 backup"
}

# Function to start services
start_services() {
    print_status "Starting Educational Companion services..."
    
    # Check if .env file exists
    if [ ! -f "config/.env" ]; then
        print_error ".env file not found. Please run setup.sh first."
        exit 1
    fi
    
    # Start services
    docker-compose up -d
    
    print_status "Services started. Waiting for initialization..."
    sleep 10
    
    # Check if services are running
    if docker-compose ps | grep -q "Up"; then
        print_status "✅ Services are running!"
        print_status "📚 Access n8n: http://localhost:5678"
    else
        print_error "❌ Some services failed to start. Check logs with: $0 logs"
    fi
}

# Function to stop services
stop_services() {
    print_status "Stopping Educational Companion services..."
    docker-compose down
    print_status "✅ Services stopped."
}

# Function to restart services
restart_services() {
    print_status "Restarting Educational Companion services..."
    docker-compose restart
    print_status "✅ Services restarted."
}

# Function to show status
show_status() {
    print_header "📊 Service Status"
    docker-compose ps
    
    echo ""
    print_header "💾 Resource Usage"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
}

# Function to show logs
show_logs() {
    if [ -n "$2" ]; then
        print_status "Showing logs for $2..."
        docker-compose logs -f "$2"
    else
        print_status "Showing all logs..."
        docker-compose logs -f
    fi
}

# Function to update images
update_system() {
    print_status "Updating Docker images..."
    docker-compose pull
    
    print_status "Restarting services with new images..."
    docker-compose up -d
    
    print_status "✅ System updated!"
}

# Function to create backup
create_backup() {
    BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    print_status "Creating backup in $BACKUP_DIR..."
    
    # Backup Docker volumes
    print_status "Backing up Docker volumes..."
    docker run --rm -v educational-companion_n8n_data:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar czf /backup/n8n_data.tar.gz -C /data .
    docker run --rm -v educational-companion_postgres_data:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar czf /backup/postgres_data.tar.gz -C /data .
    docker run --rm -v educational-companion_redis_data:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar czf /backup/redis_data.tar.gz -C /data .
    
    # Backup configuration
    print_status "Backing up configuration..."
    cp -r config "$BACKUP_DIR/"
    cp -r n8n-workflows "$BACKUP_DIR/"
    cp docker-compose.yml "$BACKUP_DIR/"
    
    # Create backup info file
    cat > "$BACKUP_DIR/backup_info.txt" << EOF
Educational Companion System Backup
Created: $(date)
Version: $(docker-compose version --short)
Services: $(docker-compose ps --services | tr '\n' ', ')
EOF
    
    print_status "✅ Backup created successfully in $BACKUP_DIR"
}

# Function to restore from backup
restore_backup() {
    if [ -z "$2" ]; then
        print_error "Please specify backup directory. Usage: $0 restore <backup_directory>"
        exit 1
    fi
    
    BACKUP_DIR="$2"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        print_error "Backup directory $BACKUP_DIR not found."
        exit 1
    fi
    
    print_warning "This will restore from backup and overwrite current data."
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Restore cancelled."
        exit 0
    fi
    
    print_status "Stopping services..."
    docker-compose down
    
    print_status "Restoring from $BACKUP_DIR..."
    
    # Restore Docker volumes
    if [ -f "$BACKUP_DIR/n8n_data.tar.gz" ]; then
        print_status "Restoring n8n data..."
        docker run --rm -v educational-companion_n8n_data:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar xzf /backup/n8n_data.tar.gz -C /data
    fi
    
    if [ -f "$BACKUP_DIR/postgres_data.tar.gz" ]; then
        print_status "Restoring postgres data..."
        docker run --rm -v educational-companion_postgres_data:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar xzf /backup/postgres_data.tar.gz -C /data
    fi
    
    if [ -f "$BACKUP_DIR/redis_data.tar.gz" ]; then
        print_status "Restoring redis data..."
        docker run --rm -v educational-companion_redis_data:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar xzf /backup/redis_data.tar.gz -C /data
    fi
    
    # Restore configuration
    if [ -d "$BACKUP_DIR/config" ]; then
        print_status "Restoring configuration..."
        cp -r "$BACKUP_DIR/config" .
    fi
    
    if [ -d "$BACKUP_DIR/n8n-workflows" ]; then
        print_status "Restoring workflows..."
        cp -r "$BACKUP_DIR/n8n-workflows" .
    fi
    
    print_status "Starting services..."
    docker-compose up -d
    
    print_status "✅ Restore completed!"
}

# Function to check system health
check_health() {
    print_header "🏥 System Health Check"
    
    # Check Docker
    if command -v docker &> /dev/null; then
        print_status "✅ Docker is installed"
    else
        print_error "❌ Docker is not installed"
    fi
    
    # Check Docker Compose
    if command -v docker-compose &> /dev/null; then
        print_status "✅ Docker Compose is installed"
    else
        print_error "❌ Docker Compose is not installed"
    fi
    
    # Check if services are running
    if docker-compose ps | grep -q "Up"; then
        print_status "✅ Services are running"
    else
        print_warning "⚠️  Some services are not running"
    fi
    
    # Check n8n accessibility
    if curl -f http://localhost:5678 > /dev/null 2>&1; then
        print_status "✅ n8n is accessible"
    else
        print_warning "⚠️  n8n is not accessible"
    fi
    
    # Check disk space
    DISK_USAGE=$(df -h . | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$DISK_USAGE" -lt 80 ]; then
        print_status "✅ Disk space is sufficient ($DISK_USAGE% used)"
    else
        print_warning "⚠️  Disk space is running low ($DISK_USAGE% used)"
    fi
    
    # Check environment variables
    if [ -f "config/.env" ]; then
        print_status "✅ Configuration file exists"
        
        # Check critical variables
        if [ -n "$OPENAI_API_KEY" ] && [ "$OPENAI_API_KEY" != "sk-your-openai-api-key-here" ]; then
            print_status "✅ OpenAI API key configured"
        else
            print_warning "⚠️  OpenAI API key not configured"
        fi
        
        if [ -n "$DISCORD_BOT_TOKEN" ] && [ "$DISCORD_BOT_TOKEN" != "your-discord-bot-token-here" ]; then
            print_status "✅ Discord bot token configured"
        else
            print_warning "⚠️  Discord bot token not configured"
        fi
    else
        print_error "❌ Configuration file missing"
    fi
}

# Function to cleanup unused resources
cleanup_system() {
    print_status "Cleaning up unused Docker resources..."
    
    # Remove unused containers
    docker container prune -f
    
    # Remove unused images
    docker image prune -f
    
    # Remove unused volumes (be careful with this)
    read -p "Remove unused volumes? This might delete data (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker volume prune -f
    fi
    
    # Remove unused networks
    docker network prune -f
    
    print_status "✅ Cleanup completed!"
}

# Function to reset system (DESTRUCTIVE)
reset_system() {
    print_error "⚠️  WARNING: This will delete ALL data and reset the system!"
    print_error "This action cannot be undone."
    echo
    read -p "Type 'RESET' to confirm: " confirm
    
    if [ "$confirm" != "RESET" ]; then
        print_status "Reset cancelled."
        exit 0
    fi
    
    print_status "Stopping all services..."
    docker-compose down -v
    
    print_status "Removing all data..."
    docker volume rm educational-companion_n8n_data educational-companion_postgres_data educational-companion_redis_data 2>/dev/null || true
    
    print_status "Removing configuration..."
    rm -f config/.env
    
    print_status "✅ System reset completed. Run setup.sh to reinitialize."
}

# Main script logic
case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs "$@"
        ;;
    update)
        update_system
        ;;
    backup)
        create_backup
        ;;
    restore)
        restore_backup "$@"
        ;;
    health)
        check_health
        ;;
    cleanup)
        cleanup_system
        ;;
    reset)
        reset_system
        ;;
    *)
        show_usage
        ;;
esac