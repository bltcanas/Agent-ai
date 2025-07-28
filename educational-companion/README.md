# 🎓 Educational Companion System

> An intelligent, automated educational assistant that transforms class recordings into comprehensive notes and provides real-time Discord-based learning support.

## ✨ What This System Does

### 📼 **Automated Audio Processing**
- Monitors your Google Drive for new class recordings
- Transcribes audio using OpenAI Whisper with high accuracy
- Generates detailed educational notes, summaries, and concept explanations
- Automatically saves formatted notes to Google Drive and Notion
- Sends Discord notifications when processing is complete

### 🤖 **Intelligent Discord Bot**
- Provides instant educational assistance through Discord commands
- Explains complex concepts in simple terms
- Summarizes notes and study materials
- Answers educational questions with context awareness
- Maintains conversation history for follow-up questions

## 🚀 Quick Start

### 1. **Prerequisites**
```bash
# Ensure you have Docker and Docker Compose installed
docker --version
docker-compose --version
```

### 2. **Setup**
```bash
# Clone and initialize the system
cd educational-companion
./scripts/setup.sh
```

### 3. **Configure APIs**
Edit `config/.env` with your API keys:
- OpenAI API key
- Discord bot token  
- Google Drive credentials
- Notion integration token

### 4. **Launch System**
```bash
# Start all services
./scripts/manage.sh start

# Check status
./scripts/manage.sh status
```

### 5. **Import Workflows**
1. Open http://localhost:5678
2. Login to n8n (default: admin/changeme)
3. Import workflows from `n8n-workflows/` folder

### 6. **Test the System**
- Upload an audio file to your Google Drive folder
- Send `!help` to your Discord bot

## 📚 Documentation

- **[Complete Setup Guide](docs/README.md)** - Detailed installation and configuration
- **[API Setup Guides](docs/api-setup-guides.md)** - Step-by-step API configuration
- **[Management Commands](scripts/manage.sh)** - System administration

## 🎯 Key Features

| Feature | Description |
|---------|-------------|
| 🎵 **Audio Transcription** | OpenAI Whisper converts speech to text with timestamps |
| 📝 **Smart Note Generation** | GPT-4o-mini creates structured educational content |
| 🔍 **Concept Identification** | Automatically identifies and explains confusing topics |
| 💾 **Multi-Platform Storage** | Saves to both Google Drive and Notion |
| 🤖 **Discord Integration** | Real-time educational assistance via chat bot |
| 📊 **Conversation Logging** | Tracks interactions for learning analytics |
| 🔄 **Automated Workflow** | Hands-off processing from upload to notification |

## 🛠️ System Management

```bash
# System Management Commands
./scripts/manage.sh start      # Start all services
./scripts/manage.sh stop       # Stop all services  
./scripts/manage.sh status     # Check system status
./scripts/manage.sh logs       # View system logs
./scripts/manage.sh backup     # Create system backup
./scripts/manage.sh health     # Run health check
```

## 🤖 Discord Bot Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `!help` | Show available commands | `!help` |
| `!explain [topic]` | Get concept explanations | `!explain quantum mechanics` |
| `!summarize [text]` | Create summaries | `!summarize my biology notes` |
| `!ask [question]` | Ask educational questions | `!ask What causes photosynthesis?` |

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Google Drive  │───▶│      n8n         │───▶│   OpenAI APIs   │
│  Audio Upload   │    │   Workflows      │    │ Whisper + GPT   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │                          │
                              ▼                          ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│    Discord      │◀───│   Educational    │───▶│ Google Drive +  │
│  Bot Responses  │    │   Content Gen    │    │     Notion      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🔒 Security & Privacy

- All API keys stored securely in environment variables
- Discord bot restricted to specified channels
- Google Drive access limited to designated folders
- Conversation logs stored privately in your Google Sheets
- No data shared with third parties beyond configured APIs

## 📈 Monitoring & Analytics

- **System Health**: Built-in health checks and monitoring
- **Usage Analytics**: Conversation logging for learning insights
- **Performance Metrics**: Docker container resource monitoring
- **Backup System**: Automated backup and restore capabilities

## 🆘 Troubleshooting

### Common Issues
- **Bot not responding**: Check Discord token and permissions
- **Audio not processing**: Verify Google Drive folder permissions
- **API errors**: Check rate limits and key validity

### Getting Help
1. Check the [troubleshooting guide](docs/README.md#troubleshooting)
2. Review system logs: `./scripts/manage.sh logs`
3. Run health check: `./scripts/manage.sh health`

## 🤝 Contributing

We welcome contributions! Please:
1. Fork the repository
2. Create a feature branch
3. Test thoroughly
4. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🎓 Educational Impact

This system is designed to enhance learning by:
- **Reducing Manual Work**: Automates note-taking from recordings
- **Improving Comprehension**: Identifies and explains difficult concepts  
- **Enabling Quick Review**: Provides instant access to key information
- **Supporting Active Learning**: Encourages questions and exploration
- **Tracking Progress**: Logs interactions for learning analytics

---

**Ready to transform your learning experience? Get started with the setup guide!**

📖 **[Read Full Documentation](docs/README.md)** | 🚀 **[Quick Setup](docs/api-setup-guides.md)** | 🛠️ **[Management Guide](scripts/manage.sh)**