# 🎓 Educational Companion System

An automated educational assistant system built with n8n that processes class recordings, generates notes, and provides real-time Discord-based interaction for enhanced learning.

## 🌟 Features

### 📼 Audio Processing Pipeline
- **Automatic Monitoring**: Watches Google Drive folder for new audio recordings
- **AI Transcription**: Uses OpenAI Whisper for accurate speech-to-text conversion
- **Smart Note Generation**: Creates detailed notes, summaries, and identifies confusing concepts
- **Multi-Platform Storage**: Saves to both Google Drive and Notion automatically
- **Discord Notifications**: Alerts when new notes are ready

### 🤖 Discord Bot Integration
- **Real-time Assistance**: Instant help with questions and explanations
- **Command System**: Easy-to-use commands for different types of help
- **Context Awareness**: Maintains conversation context for follow-up questions
- **Conversation Logging**: Tracks interactions for learning analytics

## 🏗️ System Architecture

```
Audio Upload (Google Drive) → Whisper Transcription → GPT-4o-mini Analysis
                                                    ↓
Discord Notifications ← Note Storage (Drive/Notion) ← Educational Content Generation
                                                    
Discord Messages → GPT-4o-mini Processing → Contextual Responses
                ↓
        Conversation Logging (Google Sheets)
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- API Keys for: OpenAI, Discord, Google Drive, Notion
- Google Drive folder for audio files
- Discord server with bot permissions

### Installation

1. **Clone and Setup**
   ```bash
   git clone <repository>
   cd educational-companion
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

2. **Configure Environment**
   - Edit `config/.env` with your API keys
   - See [Configuration Guide](#configuration) below

3. **Import Workflows**
   - Access n8n at http://localhost:5678
   - Import workflow files from `n8n-workflows/`

4. **Test the System**
   - Upload an audio file to your Google Drive folder
   - Send `!help` to your Discord bot

## ⚙️ Configuration

### Required API Keys

#### OpenAI API
```bash
OPENAI_API_KEY=sk-your-key-here
```
Get from: https://platform.openai.com/api-keys

#### Discord Bot
```bash
DISCORD_BOT_TOKEN=your-bot-token
DISCORD_CHANNEL_ID=your-channel-id
```
Setup guide: [Discord Bot Setup](#discord-bot-setup)

#### Google Drive API
```bash
GOOGLE_DRIVE_FOLDER_ID=your-folder-id
GOOGLE_DRIVE_NOTES_FOLDER_ID=your-notes-folder-id
GOOGLE_CLIENT_ID=your-client-id
GOOGLE_CLIENT_SECRET=your-client-secret
```
Setup guide: [Google Drive Setup](#google-drive-setup)

#### Notion API
```bash
NOTION_API_KEY=your-integration-token
NOTION_DATABASE_ID=your-database-id
```
Setup guide: [Notion Setup](#notion-setup)

## 🤖 Discord Bot Commands

| Command | Description | Example |
|---------|-------------|---------|
| `!help` | Show available commands | `!help` |
| `!explain [topic]` | Get simple explanations | `!explain photosynthesis` |
| `!summarize [text]` | Create concise summaries | `!summarize my calculus notes` |
| `!ask [question]` | Ask educational questions | `!ask What is quantum entanglement?` |

## 📋 Workflow Details

### Audio Transcription Workflow
1. **Google Drive Trigger**: Monitors for new audio files
2. **File Download**: Retrieves audio file
3. **Whisper Transcription**: Converts speech to text
4. **Content Generation**: Creates educational materials
5. **Storage**: Saves to Google Drive and Notion
6. **Notification**: Alerts via Discord

### Discord Bot Workflow
1. **Message Trigger**: Listens for Discord messages
2. **Command Routing**: Processes different command types
3. **AI Processing**: Generates contextual responses
4. **Response Delivery**: Sends formatted replies
5. **Logging**: Records conversations for analytics

## 🔧 Customization

### Educational Content Templates

The system uses GPT-4o-mini with specialized prompts to generate:

- **Detailed Notes**: Comprehensive coverage of topics
- **Lesson Summaries**: Key learning objectives
- **Confusing Concepts**: Simplified explanations with resources

### Response Styles

Configure in `.env`:
```bash
EXPLANATION_STYLE=simple  # simple, detailed, academic
SUMMARY_MAX_LENGTH=500
NOTES_FORMAT=markdown
```

## 📊 Monitoring & Analytics

### Conversation Logging
All Discord interactions are logged to Google Sheets for:
- Usage analytics
- Learning pattern analysis  
- Bot performance monitoring

### System Health
Monitor via Docker:
```bash
docker-compose ps
docker-compose logs -f n8n
```

## 🛠️ Troubleshooting

### Common Issues

**Audio files not processing:**
- Check Google Drive folder permissions
- Verify audio format support (mp3, wav, m4a, ogg, flac)
- Check file size limits (default: 100MB)

**Discord bot not responding:**
- Verify bot token and permissions
- Check channel ID configuration
- Ensure bot is in the correct server

**API rate limits:**
- OpenAI: Monitor usage dashboard
- Discord: Respect rate limits (5 requests/5 seconds)
- Google APIs: Check quota limits

### Logs and Debugging

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs n8n
docker-compose logs postgres

# Follow logs in real-time
docker-compose logs -f
```

## 🔒 Security Considerations

- Store API keys securely in `.env` file
- Use environment-specific configurations
- Regularly rotate API keys
- Monitor API usage for unusual activity
- Restrict Discord bot permissions to necessary channels

## 📚 API Documentation

### Supported Audio Formats
- MP3, WAV, M4A, OGG, FLAC
- Maximum size: 100MB (configurable)
- Automatic format detection

### Response Formats
- **Discord**: Markdown with Discord formatting
- **Notes**: Standard Markdown
- **Summaries**: Structured text with headers

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Test thoroughly
4. Submit pull request

## 📄 License

MIT License - see LICENSE file for details

## 🆘 Support

For issues and questions:
1. Check troubleshooting guide above
2. Review Docker logs
3. Verify API configurations
4. Create GitHub issue with details

---

**Happy Learning! 🎓**