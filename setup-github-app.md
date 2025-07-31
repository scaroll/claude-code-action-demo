# GitHub App Setup Guide

## Step 1: Create GitHub App

1. **Open this link**: https://github.com/settings/apps/new

2. **Fill in these exact settings**:

   **GitHub App name**: `Claude Code Bot 2025`
   
   **Homepage URL**: `https://github.com/scaroll/claude-code-action-demo`
   
   **Description**: `AI-powered code review and issue assistance`
   
   **Webhook**: ❌ **Uncheck "Active"**

3. **Repository permissions** (scroll down):
   - **Contents**: Read & Write
   - **Issues**: Read & Write  
   - **Pull requests**: Read & Write
   - **Metadata**: Read (automatically selected)

4. **Where can this GitHub App be installed?**
   - Select: "Only on this account"

5. Click **"Create GitHub App"**

## Step 2: After Creating the App

You'll see your app's settings page. Note down:
- **App ID**: (shown at the top of the page)

## Step 3: Generate Private Key

1. Scroll down to **"Private keys"** section
2. Click **"Generate a private key"**
3. A .pem file will download - save it somewhere safe

## Step 4: Install the App

1. In the left sidebar, click **"Install App"**
2. Click **"Install"** next to your username
3. Select **"All repositories"** or choose specific ones
4. Click **"Install"**

## Step 5: What You Need

After completing the above, you should have:
1. **App ID**: A number like 123456
2. **Private Key**: A downloaded .pem file
3. **Anthropic API Key**: Get from https://console.anthropic.com/settings/keys

Once you have all three, we'll add them as repository secrets!