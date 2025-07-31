# Claude Code Action Demo

🤖 AI-powered code reviews and issue assistance using Claude

This repository demonstrates the Claude Code GitHub Action, which provides intelligent code reviews on pull requests and helpful responses to issues.

## Features

- **Automated PR Reviews**: Claude automatically reviews all pull requests
- **Issue Assistant**: Claude responds to issues and helps solve problems
- **@claude Mentions**: Mention @claude in any comment for AI assistance
- **Customizable**: Configure Claude's behavior with custom prompts

## Setup Instructions

### 1. Create GitHub App

1. Go to [GitHub App settings](https://github.com/settings/apps/new)
2. Configure with these permissions:
   - **Repository permissions**:
     - Contents: Read & Write
     - Issues: Read & Write
     - Pull requests: Read & Write
   - **Account permissions**: None required

### 2. Generate Private Key

1. After creating the app, scroll to "Private keys"
2. Click "Generate a private key"
3. Save the downloaded .pem file

### 3. Install App

1. In the app settings, click "Install App"
2. Select repositories where you want Claude

### 4. Add Secrets

In your repository settings, add these secrets:
- `APP_ID`: Your GitHub App's ID
- `APP_PRIVATE_KEY`: Contents of the .pem file
- `ANTHROPIC_API_KEY`: Your Anthropic API key from [console.anthropic.com](https://console.anthropic.com)

## Usage

### Pull Request Reviews

Claude automatically reviews:
- New pull requests
- Updated pull requests
- When mentioned with @claude in PR comments

### Issue Assistance

Claude responds to:
- New issues
- Issues labeled with 'claude'
- Comments mentioning @claude

## Example

Create a pull request or issue to see Claude in action!
