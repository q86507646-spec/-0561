#!/bin/sh
# ==================== 配置参数（必须修改！）====================
GITHUB_USERNAME="q86507646-spec"
REPO_NAME="-0561"
BRANCH="main"
REPO_PATH="$HOME/my-jailbreak-repohttps://raw.githubusercontent.com/q86507646-spec/-0561/"  # 改成你本地仓库的实际路径
# ==============================================================

# 颜色输出（兼容sh）
green_echo() { echo "\033[32m[OK] $1\033[0m"; }
red_echo() { echo "\033[31m[ERROR] $1\033[0m"; }
blue_echo() { echo "\033[34m[INFO] $1\033[0m"; }

# 前置检查1：是否已创建空仓库
echo "\033[34m[INFO] Important: Please create an empty repository on GitHub first (do NOT initialize with a README)\033[0m"
read -p "Have you created the empty repository? (Enter y to continue, others to exit): " IS_CREATED
if [ "$IS_CREATED" != "y" ] && [ "$IS_CREATED" != "Y" ]; then
    echo "\033[31m[ERROR] Please go to https://github.com/new to create an empty repository first, then run this script!\033[0m"
    exit 1
fi

# 前置检查2：Git 配置
if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
    echo "\033[31m[ERROR] Git global username/email not configured! Please run:\033[0m"
    echo "  git config --global user.name \"your-github-username\""
    echo "  git config --global user.email \"your-github-email@example.com\""
    exit 1
fi

# 前置检查3：本地仓库路径
if [ ! -d "$REPO_PATH" ]; then
    echo "\033[31m[ERROR] Local repository path does not exist! Please check REPO_PATH\033[0m"
    exit 1
fi
cd "$REPO_PATH" || { echo "\033[31m[ERROR] Failed to enter repository directory!\033[0m"; exit 1; }

# 关联远程仓库
echo "\033[34m[INFO] Linking local repository to GitHub remote...\033[0m"
REMOTE_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git remote add origin "$REMOTE_URL" || {
    git remote set-url origin "$REMOTE_URL"
    echo "\033[34m[INFO] Remote repository already exists, updated URL\033[0m"
}

# 提交文件
echo "\033[34m[INFO] Committing local files...\033[0m"
git add .
if git diff --cached --quiet; then
    git commit -m "Initial commit: Jailbreak repo basic structure" --allow-empty
else
    git commit -m "Initial commit: Jailbreak repo basic structure"
fi

# 推送
echo "\033[34m[INFO] Pushing to GitHub $BRANCH branch...\033[0m"
git push -u origin "$BRANCH" || {
    echo "\033[31m[ERROR] Push failed! Check network/repo name/username\033[0m"
    exit 1
}

# 完成提示
echo "\n======================================"
echo "\033[32m[OK] Local repository successfully pushed to GitHub!\033[0m"
echo "Next step: Enable GitHub Pages service"
echo "1. Open your repo: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "2. Go to Settings → Pages"
echo "3. Select 'Deploy from a branch' and choose $BRANCH → / (root)"
echo "4. Wait 1-5 minutes, your repo URL: https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
echo "======================================"