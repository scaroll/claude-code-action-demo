#!/bin/bash

# Anthropic Dev Agents GitHub Integration Setup
# This script automates the GitHub App creation and configuration

set -e

echo "🤖 Anthropic Dev Agents - GitHub Integration Setup"
echo "================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we have Anthropic API key
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}📌 Anthropic API Key Required${NC}"
    echo "Get your API key from: https://console.anthropic.com/settings/keys"
    echo -n "Enter your Anthropic API key: "
    read -rs ANTHROPIC_API_KEY
    echo ""
fi

# GitHub App creation guidance
echo -e "${BLUE}📱 Creating GitHub App for Claude Code${NC}"
echo ""
echo "Since GitHub Apps must be created manually, follow these steps:"
echo ""
echo -e "${GREEN}1. Open this link:${NC} https://github.com/settings/apps/new"
echo ""
echo -e "${GREEN}2. Use these exact settings:${NC}"
echo "   GitHub App name: Claude Dev Agent $(date +%s)"
echo "   Homepage URL: https://github.com/scaroll/claude-code-action-demo"
echo "   Description: Anthropic Claude Code integration for automated code review"
echo "   Webhook URL: Leave blank"
echo "   Webhook Active: ❌ Uncheck"
echo ""
echo -e "${GREEN}3. Repository permissions:${NC}"
echo "   - Actions: Read"
echo "   - Contents: Read & Write"
echo "   - Issues: Read & Write"
echo "   - Metadata: Read"
echo "   - Pull requests: Read & Write"
echo ""
echo -e "${GREEN}4. Account permissions:${NC} None needed"
echo ""
echo -e "${GREEN}5. Where can this GitHub App be installed?${NC}"
echo "   Select: 'Only on this account'"
echo ""
echo -e "${YELLOW}Press Enter after creating the app...${NC}"
read -r

# Get App details
echo ""
echo -e "${BLUE}📝 Enter your GitHub App details:${NC}"
echo -n "App ID (from the app settings page): "
read -r APP_ID

echo ""
echo -e "${YELLOW}🔑 Generate a private key:${NC}"
echo "1. On your app's settings page, scroll to 'Private keys'"
echo "2. Click 'Generate a private key'"
echo "3. Save the downloaded .pem file"
echo ""
echo -n "Enter the full path to your .pem file: "
read -r PEM_PATH

# Verify pem file exists
if [ ! -f "$PEM_PATH" ]; then
    echo -e "${YELLOW}❌ Error: Private key file not found at $PEM_PATH${NC}"
    exit 1
fi

# Read the private key
APP_PRIVATE_KEY=$(<"$PEM_PATH")

echo ""
echo -e "${BLUE}🚀 Installing the GitHub App${NC}"
echo "1. On your app's page, click 'Install App' in the left sidebar"
echo "2. Click 'Install' next to your username"
echo "3. Select 'All repositories' or choose specific ones"
echo "4. Click 'Install'"
echo ""
echo -e "${YELLOW}Press Enter after installing...${NC}"
read -r

# Set repository secrets
echo ""
echo -e "${BLUE}🔐 Setting repository secrets...${NC}"

# Set secrets using gh CLI
gh secret set APP_ID --repo="scaroll/claude-code-action-demo" --body="$APP_ID"
echo -e "${GREEN}✅ APP_ID set${NC}"

gh secret set APP_PRIVATE_KEY --repo="scaroll/claude-code-action-demo" --body="$APP_PRIVATE_KEY"
echo -e "${GREEN}✅ APP_PRIVATE_KEY set${NC}"

gh secret set ANTHROPIC_API_KEY --repo="scaroll/claude-code-action-demo" --body="$ANTHROPIC_API_KEY"
echo -e "${GREEN}✅ ANTHROPIC_API_KEY set${NC}"

# Update workflows for Anthropic Dev Agents
echo ""
echo -e "${BLUE}📄 Updating workflows for Anthropic Dev Agents...${NC}"

# Create enhanced PR review workflow
cat > .github/workflows/anthropic-pr-review.yml << 'EOF'
name: Anthropic Dev Agent - PR Review

on:
  pull_request:
    types: [opened, synchronize, ready_for_review]
  pull_request_review_comment:
    types: [created]
  issue_comment:
    types: [created]

permissions:
  contents: read
  pull-requests: write
  issues: write
  actions: read

jobs:
  claude-dev-review:
    if: |
      (github.event_name == 'pull_request' && !github.event.pull_request.draft) ||
      (github.event_name == 'pull_request_review_comment') ||
      (github.event_name == 'issue_comment' && 
       github.event.issue.pull_request && 
       (contains(github.event.comment.body, '@claude') || 
        contains(github.event.comment.body, '/review') ||
        contains(github.event.comment.body, '/suggest')))
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Generate GitHub App Token
        id: app-token
        uses: actions/create-github-app-token@v1
        with:
          app-id: ${{ secrets.APP_ID }}
          private-key: ${{ secrets.APP_PRIVATE_KEY }}
          
      - name: Anthropic Dev Agent Review
        uses: anthropics/claude-code-action@v1
        with:
          github-token: ${{ steps.app-token.outputs.token }}
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
          model: claude-3-5-sonnet-20241022
          max-comment-length: 4000
          temperature: 0.1
          system-prompt: |
            You are an expert software development agent specializing in code review.
            
            Your responsibilities:
            1. Analyze code for bugs, security issues, and performance problems
            2. Suggest improvements following best practices
            3. Provide specific, actionable feedback with code examples
            4. Check for proper error handling and edge cases
            5. Ensure code follows project conventions and standards
            6. Validate test coverage and suggest missing tests
            
            Commands you respond to:
            - @claude: General review request
            - /review: Detailed code review
            - /suggest: Provide specific code suggestions
            - /security: Focus on security analysis
            - /performance: Focus on performance optimization
            
            Be constructive, specific, and helpful. Provide code snippets when suggesting changes.
EOF

# Create issue automation workflow
cat > .github/workflows/anthropic-issue-agent.yml << 'EOF'
name: Anthropic Dev Agent - Issue Assistant

on:
  issues:
    types: [opened, labeled]
  issue_comment:
    types: [created]

permissions:
  contents: read
  issues: write
  pull-requests: write

jobs:
  claude-dev-assist:
    if: |
      (github.event_name == 'issues' && 
       (github.event.action == 'opened' || 
        contains(github.event.label.name, 'claude') ||
        contains(github.event.label.name, 'help wanted'))) ||
      (github.event_name == 'issue_comment' && 
       !github.event.issue.pull_request &&
       (contains(github.event.comment.body, '@claude') ||
        contains(github.event.comment.body, '/implement') ||
        contains(github.event.comment.body, '/explain') ||
        contains(github.event.comment.body, '/debug')))
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Generate GitHub App Token
        id: app-token
        uses: actions/create-github-app-token@v1
        with:
          app-id: ${{ secrets.APP_ID }}
          private-key: ${{ secrets.APP_PRIVATE_KEY }}
          
      - name: Anthropic Dev Agent Assist
        uses: anthropics/claude-code-action@v1
        with:
          github-token: ${{ steps.app-token.outputs.token }}
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
          model: claude-3-5-sonnet-20241022
          system-prompt: |
            You are an expert software development agent helping with repository issues.
            
            Your capabilities:
            1. Analyze and debug code issues
            2. Provide implementation suggestions with code examples
            3. Explain complex code or concepts
            4. Suggest architectural improvements
            5. Help with testing strategies
            6. Provide documentation guidance
            
            Commands you respond to:
            - @claude: General assistance
            - /implement: Provide implementation code
            - /explain: Explain code or concepts
            - /debug: Help debug an issue
            - /test: Suggest testing approaches
            - /architecture: Discuss architectural decisions
            
            Always provide practical, working code examples when relevant.
            Be thorough but concise, and ask clarifying questions when needed.
EOF

# Create automated workflow for code implementation
cat > .github/workflows/anthropic-code-implementation.yml << 'EOF'
name: Anthropic Dev Agent - Code Implementation

on:
  issues:
    types: [labeled]
  workflow_dispatch:
    inputs:
      issue_number:
        description: 'Issue number to implement'
        required: true
        type: number

permissions:
  contents: write
  issues: write
  pull-requests: write

jobs:
  implement-feature:
    if: |
      (github.event_name == 'issues' && 
       contains(github.event.label.name, 'implement')) ||
      github.event_name == 'workflow_dispatch'
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Generate GitHub App Token
        id: app-token
        uses: actions/create-github-app-token@v1
        with:
          app-id: ${{ secrets.APP_ID }}
          private-key: ${{ secrets.APP_PRIVATE_KEY }}
          
      - name: Get Issue Details
        id: issue
        uses: actions/github-script@v7
        with:
          github-token: ${{ steps.app-token.outputs.token }}
          script: |
            const issue_number = context.payload.issue?.number || 
                               context.payload.inputs?.issue_number;
            const issue = await github.rest.issues.get({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: issue_number
            });
            return issue.data;
            
      - name: Claude Code Implementation
        uses: anthropics/claude-code-action@v1
        with:
          github-token: ${{ steps.app-token.outputs.token }}
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
          model: claude-3-5-sonnet-20241022
          mode: implement
          issue-number: ${{ fromJson(steps.issue.outputs.result).number }}
          system-prompt: |
            You are an expert software development agent tasked with implementing features.
            
            Based on the issue description:
            1. Analyze the requirements
            2. Create or modify necessary files
            3. Implement the feature following best practices
            4. Add appropriate tests
            5. Update documentation if needed
            
            Create a pull request with your implementation.
EOF

echo -e "${GREEN}✅ Workflows updated${NC}"

# Commit changes
git add .github/workflows/
git commit -m "Configure Anthropic Dev Agents integration

- Enhanced PR review with multiple command support
- Advanced issue assistance with debugging capabilities
- Automated code implementation workflow
- Configured for Claude 3.5 Sonnet" || echo "No changes to commit"

git push origin main

echo ""
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo ""
echo -e "${BLUE}📋 What's been configured:${NC}"
echo "✅ GitHub App created and installed"
echo "✅ Repository secrets configured"
echo "✅ Anthropic Dev Agent workflows deployed"
echo "✅ PR review automation"
echo "✅ Issue assistance automation"
echo "✅ Code implementation automation"
echo ""
echo -e "${BLUE}🚀 Available Commands:${NC}"
echo "In PRs: @claude, /review, /suggest, /security, /performance"
echo "In Issues: @claude, /implement, /explain, /debug, /test, /architecture"
echo ""
echo -e "${BLUE}🧪 Test it out:${NC}"
echo "1. Create a new issue with the 'implement' label"
echo "2. Create a PR to see automated review"
echo "3. Comment '@claude' in any issue or PR"
echo ""
echo -e "${GREEN}Repository:${NC} https://github.com/scaroll/claude-code-action-demo"