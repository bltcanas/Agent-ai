# 🔧 API Setup Guides

This document provides step-by-step instructions for setting up all required APIs and services for the Educational Companion System.

## 🤖 Discord Bot Setup

### 1. Create a Discord Application

1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Click "New Application"
3. Enter a name (e.g., "Educational Companion Bot")
4. Click "Create"

### 2. Create a Bot

1. In your application, go to the "Bot" section
2. Click "Add Bot"
3. Customize your bot:
   - **Username**: Educational Assistant
   - **Avatar**: Upload an educational icon
   - **Public Bot**: Disable (unless you want others to add it)

### 3. Get Bot Token

1. In the Bot section, click "Copy" under Token
2. Add to your `.env` file:
   ```bash
   DISCORD_BOT_TOKEN=your-copied-token-here
   ```

### 4. Set Bot Permissions

In the Bot section, enable these permissions:
- Send Messages
- Read Message History
- Add Reactions
- Embed Links
- Attach Files

### 5. Invite Bot to Server

1. Go to "OAuth2" > "URL Generator"
2. Select scopes: `bot`
3. Select permissions: `Send Messages`, `Read Message History`, `Add Reactions`
4. Copy the generated URL and open it
5. Select your server and authorize

### 6. Get Channel ID

1. Enable Developer Mode in Discord (User Settings > Advanced > Developer Mode)
2. Right-click on your desired channel
3. Click "Copy Channel ID"
4. Add to your `.env` file:
   ```bash
   DISCORD_CHANNEL_ID=your-channel-id-here
   ```

---

## 🔑 OpenAI API Setup

### 1. Create OpenAI Account

1. Go to [OpenAI Platform](https://platform.openai.com)
2. Sign up or log in
3. Verify your account

### 2. Get API Key

1. Go to [API Keys](https://platform.openai.com/api-keys)
2. Click "Create new secret key"
3. Name it "Educational Companion"
4. Copy the key immediately (you won't see it again)
5. Add to your `.env` file:
   ```bash
   OPENAI_API_KEY=sk-your-api-key-here
   ```

### 3. Set Usage Limits (Recommended)

1. Go to [Usage Limits](https://platform.openai.com/account/limits)
2. Set monthly spending limits to control costs
3. Enable email notifications for usage alerts

### 4. Check Model Access

Ensure you have access to:
- `whisper-1` (for transcription)
- `gpt-4o-mini` (for text generation)

---

## 📁 Google Drive API Setup

### 1. Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select existing one
3. Name it "Educational Companion"

### 2. Enable APIs

1. Go to "APIs & Services" > "Library"
2. Enable these APIs:
   - Google Drive API
   - Google Sheets API

### 3. Create Credentials

1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth 2.0 Client IDs"
3. Configure consent screen if prompted:
   - User Type: External
   - App name: Educational Companion
   - Support email: Your email
   - Scopes: Add `../auth/drive` and `../auth/spreadsheets`
4. Create OAuth 2.0 Client ID:
   - Application type: Desktop application
   - Name: Educational Companion

### 4. Download Credentials

1. Download the JSON file
2. Extract the following values:
   ```bash
   GOOGLE_CLIENT_ID=your-client-id
   GOOGLE_CLIENT_SECRET=your-client-secret
   ```

### 5. Get Refresh Token

Run this script to get your refresh token:

```bash
# Create a temporary script
cat > get_refresh_token.py << 'EOF'
from google.auth.transport.requests import Request
from google_auth_oauthlib.flow import InstalledAppFlow
import json

SCOPES = [
    'https://www.googleapis.com/auth/drive',
    'https://www.googleapis.com/auth/spreadsheets'
]

def get_refresh_token():
    flow = InstalledAppFlow.from_client_secrets_file(
        'credentials.json', SCOPES)
    creds = flow.run_local_server(port=0)
    
    print(f"Refresh Token: {creds.refresh_token}")
    
    # Save for later use
    with open('token.json', 'w') as token:
        token.write(creds.to_json())

if __name__ == '__main__':
    get_refresh_token()
EOF

# Install required package
pip install google-auth-oauthlib

# Run the script (make sure credentials.json is in the same directory)
python get_refresh_token.py
```

Add the refresh token to your `.env`:
```bash
GOOGLE_REFRESH_TOKEN=your-refresh-token-here
```

### 6. Create Google Drive Folders

1. Create a folder for audio files
2. Create a folder for generated notes
3. Get folder IDs from the URLs:
   - URL: `https://drive.google.com/drive/folders/FOLDER_ID_HERE`
4. Add to your `.env`:
   ```bash
   GOOGLE_DRIVE_FOLDER_ID=your-audio-folder-id
   GOOGLE_DRIVE_NOTES_FOLDER_ID=your-notes-folder-id
   ```

### 7. Create Google Sheets for Logging

1. Create a new Google Sheet named "Educational Companion Logs"
2. Add headers: `Timestamp`, `User`, `Channel`, `Message`, `AI_Response`, `Command_Type`
3. Get the sheet ID from the URL
4. Add to your `.env`:
   ```bash
   GOOGLE_SHEETS_CONVERSATION_LOG_ID=your-sheet-id-here
   ```

---

## 📝 Notion API Setup

### 1. Create Notion Integration

1. Go to [Notion Integrations](https://www.notion.so/my-integrations)
2. Click "New integration"
3. Fill in details:
   - Name: Educational Companion
   - Logo: Upload an educational icon
   - Associated workspace: Select your workspace

### 2. Get Integration Token

1. Copy the "Internal Integration Token"
2. Add to your `.env`:
   ```bash
   NOTION_API_KEY=secret_your-integration-token-here
   ```

### 3. Create Database

1. Create a new Notion page
2. Add a database with these properties:
   - **Name** (Title)
   - **Content** (Text)
   - **Date** (Date)
   - **Audio File** (URL)

### 4. Share Database with Integration

1. Click "Share" on your database page
2. Click "Invite" and search for your integration name
3. Select your integration and click "Invite"

### 5. Get Database ID

1. Copy the database URL
2. Extract the ID from the URL:
   - URL: `https://www.notion.so/DATABASE_ID_HERE?v=...`
3. Add to your `.env`:
   ```bash
   NOTION_DATABASE_ID=your-database-id-here
   ```

---

## 🔒 Security Best Practices

### Environment Variables Security

1. **Never commit `.env` files** to version control
2. **Use different keys** for development and production
3. **Regularly rotate** API keys
4. **Monitor usage** for unusual activity

### API Key Management

```bash
# Good: Use environment variables
OPENAI_API_KEY=${OPENAI_API_KEY}

# Bad: Hardcode in scripts
api_key = "sk-actual-key-here"  # DON'T DO THIS
```

### Access Controls

1. **Discord**: Limit bot to specific channels
2. **Google Drive**: Use least-privilege access
3. **Notion**: Share only necessary databases
4. **OpenAI**: Set spending limits

---

## 🧪 Testing Your Setup

### 1. Test OpenAI Connection

```bash
curl -H "Authorization: Bearer $OPENAI_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{"model": "gpt-3.5-turbo", "messages": [{"role": "user", "content": "Hello!"}]}' \
     https://api.openai.com/v1/chat/completions
```

### 2. Test Discord Bot

1. Invite bot to a test server
2. Send a message in the channel
3. Check if bot receives webhook notifications

### 3. Test Google Drive Access

Upload a test file to your monitored folder and verify n8n detects it.

### 4. Test Notion Integration

Create a test page in your database to verify write access.

---

## ❗ Common Issues & Solutions

### Discord Bot Not Responding
- **Issue**: Bot token invalid
- **Solution**: Regenerate token in Discord Developer Portal

### Google Drive Access Denied
- **Issue**: Insufficient permissions
- **Solution**: Re-run OAuth flow with correct scopes

### OpenAI Rate Limits
- **Issue**: Too many requests
- **Solution**: Implement exponential backoff

### Notion Database Not Found
- **Issue**: Integration not shared with database
- **Solution**: Re-share database with integration

---

## 📞 Support Contacts

- **Discord**: [Discord Developer Support](https://discord.com/developers/docs)
- **OpenAI**: [OpenAI Help Center](https://help.openai.com)
- **Google**: [Google Cloud Support](https://cloud.google.com/support)
- **Notion**: [Notion Help Center](https://www.notion.so/help)

---

**Next**: Return to [main README](README.md) to continue setup