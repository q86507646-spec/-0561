#!/bin/sh
# ==================== 配置参数 ====================
GITHUB_USERNAME="q86507646-spec"
REPO_NAME="-0561"
BRANCH="main"
REPO_PATH="$HOME/my-jailbreak-repo"  # 替换为你的本地仓库路径
# ==================================================

# 颜色输出
green_echo() { echo "\033[32m[OK] $1\033[0m"; }
red_echo() { echo "\033[31m[ERROR] $1\033[0m"; }
blue_echo() { echo "\033[34m[INFO] $1\033[0m"; }

# 前置检查1：是否已创建空仓库
blue_echo "Important: Please create an empty repository on GitHub first (do NOT initialize with a README)"
read -p "Have you created the empty repository? (Enter y to continue, others to exit): " IS_CREATED
if [ "$IS_CREATED" != "y" ] && [ "$IS_CREATED" != "Y" ]; then
    red_echo "Please go to https://github.com/new to create an empty repository first, then run this script!"
    exit 1
fi

# 前置检查2：Git 配置
if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
    red_echo "Git global username/email not configured! Please run:"
    echo "  git config --global user.name \"q86507646-spec\""
    echo "  git config --global user.email \"86507646@gmail.com\""
    exit 1
fi

# 前置检查3：本地仓库路径
if [ ! -d "$REPO_PATH" ]; then
    red_echo "Local repository path does not exist! Please check REPO_PATH"
    exit 1
fi
cd "$REPO_PATH" || { red_echo "Failed to enter repository directory!"; exit 1; }

# 关联远程仓库
blue_echo "Linking local repository to GitHub remote..."
REMOTE_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git remote add origin "$REMOTE_URL" || {
    git remote set-url origin "$REMOTE_URL"
    blue_echo "Remote repository already exists, updated URL"
}

# 提交文件
blue_echo "Committing local files..."
git add .
if git diff --cached --quiet; then
    git commit -m "Initial commit: Jailbreak repo basic structure" --allow-empty
else
    git commit -m "Initial commit: Jailbreak repo basic structure"
fi

# 推送
blue_echo "Pushing to GitHub $BRANCH branch..."
git push -u origin "$BRANCH" || {
    red_echo "Push failed! Check network/repo name/username"
    exit 1
}

# 完成提示
echo -e "\n======================================"
green_echo "Local repository successfully pushed to GitHub!"
echo "Next step: Enable GitHub Pages service"
echo "1. Open your repo: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "2. Go to Settings → Pages"
echo "3. Select 'Deploy from a branch' and choose $BRANCH → / (root)"
echo "4. Wait 1-5 minutes, your repo URL: https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
echo "======================================"