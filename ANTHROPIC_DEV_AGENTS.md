# Anthropic Dev Agents - GitHub Integration

This repository is configured with Anthropic's Claude Dev Agents for automated code review, issue assistance, and code implementation.

## 🤖 What are Anthropic Dev Agents?

Anthropic Dev Agents are AI-powered development assistants that integrate directly with your GitHub workflow to:
- Perform intelligent code reviews
- Assist with issue resolution
- Implement features based on specifications
- Provide debugging help
- Suggest architectural improvements

## 🚀 Features

### 1. **Automated PR Reviews**
- Instant code review on every pull request
- Security vulnerability detection
- Performance optimization suggestions
- Best practices enforcement

### 2. **Issue Assistant**
- Responds to issues with helpful suggestions
- Provides code examples and implementation guidance
- Helps debug problems
- Explains complex concepts

### 3. **Code Implementation**
- Automatically implements features from issues
- Creates pull requests with working code
- Includes tests and documentation
- Follows project conventions

## 📋 Available Commands

### In Pull Requests:
- `@claude` - General review request
- `/review` - Detailed code review
- `/suggest` - Get specific code suggestions
- `/security` - Security-focused analysis
- `/performance` - Performance optimization tips

### In Issues:
- `@claude` - General assistance
- `/implement` - Get implementation code
- `/explain` - Explain code or concepts
- `/debug` - Debug help
- `/test` - Testing strategies
- `/architecture` - Architectural guidance

## 🛠️ Setup Instructions

### Prerequisites:
1. GitHub account with admin access to create apps
2. Anthropic API key from [console.anthropic.com](https://console.anthropic.com)

### Quick Setup:

1. **Run the setup script:**
   ```bash
   ./setup-anthropic-integration.sh
   ```

2. **Follow the prompts to:**
   - Create a GitHub App
   - Generate a private key
   - Install the app on your repositories
   - Configure secrets

### Manual Setup:

1. **Create GitHub App:**
   - Go to https://github.com/settings/apps/new
   - Name: `Claude Dev Agent [unique-name]`
   - Permissions needed:
     - Actions: Read
     - Contents: Read & Write
     - Issues: Read & Write
     - Pull requests: Read & Write

2. **Generate Private Key:**
   - In app settings, click "Generate a private key"
   - Save the .pem file

3. **Add Repository Secrets:**
   - `APP_ID`: Your GitHub App ID
   - `APP_PRIVATE_KEY`: Contents of .pem file
   - `ANTHROPIC_API_KEY`: Your Anthropic API key

## 🧪 Testing

1. **Test PR Review:**
   ```bash
   git checkout -b test-feature
   echo "test" > test.txt
   git add test.txt
   git commit -m "Test Claude review"
   git push origin test-feature
   # Create PR - Claude will review automatically
   ```

2. **Test Issue Assistant:**
   - Create an issue titled "Help me implement a sorting algorithm"
   - Claude will respond with implementation suggestions

3. **Test Implementation:**
   - Create an issue with the `implement` label
   - Claude will create a PR with the implementation

## 🔧 Configuration

### Customize Claude's Behavior:

Edit the workflow files in `.github/workflows/` to modify:
- Model selection (claude-3-5-sonnet, claude-3-opus, etc.)
- Temperature settings
- System prompts
- Response length limits

### Advanced Features:

1. **Conditional Triggers:**
   - Configure when Claude responds
   - Set up label-based automation
   - Create custom commands

2. **Integration with CI/CD:**
   - Run Claude before tests
   - Gate merges on Claude approval
   - Automate documentation updates

## 📊 Best Practices

1. **Be Specific:** The more detailed your requests, the better Claude's responses
2. **Use Commands:** Leverage specific commands for targeted assistance
3. **Iterate:** Claude can refine suggestions based on feedback
4. **Review Output:** Always review AI-generated code before merging

## 🔒 Security

- All API keys are stored as encrypted secrets
- Claude only has access to public repository data
- No code is sent to external services beyond Anthropic's API
- All communications are encrypted

## 🆘 Troubleshooting

### Claude not responding?
1. Check workflow runs in Actions tab
2. Verify secrets are set correctly
3. Ensure GitHub App is installed on repository

### Rate limits?
- Anthropic API has rate limits
- Consider upgrading your API plan for heavy usage

### Need help?
- Open an issue and mention `@claude`
- Check [Anthropic's documentation](https://docs.anthropic.com)

## 📚 Resources

- [Anthropic Console](https://console.anthropic.com)
- [Claude Documentation](https://docs.anthropic.com)
- [GitHub Apps Documentation](https://docs.github.com/en/apps)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)