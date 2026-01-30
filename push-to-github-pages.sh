#!/bin/bash
# ==================== 配置参数（必须修改！）====================
GITHUB_USERNAME="q86507646-spec"   # 你的GitHub用户名
REPO_NAME="-0561"                  # 你的GitHub仓库名称
BRANCH="main"                      # 推送的分支
REPO_PATH="$HOMEhttps://raw.githubusercontent.com/q86507646-spec/-0561/main/push-to-github-pages.sh# 你的本地越狱源仓库路径（必须修改！）
# ==============================================================

# 颜色输出函数（纯文字，避免终端显示异常）
green_echo() { echo -e "\033[32m[OK] $1\033[0m"; }
red_echo() { echo -e "\033[31m[ERROR] $1\033[0m"; }
blue_echo() { echo -e "\033[34m[INFO] $1\033[0m"; }

# 前置检查1：是否已在 GitHub 手动创建空仓库
blue_echo "Important: Please create an empty repository on GitHub first (do NOT initialize with a README)"
read -p "Have you created the empty repository? (Enter y to continue, others to exit): " IS_CREATED
if [[ "$IS_CREATED" != "y" && "$IS_CREATED" != "Y" ]]; then
    red_echo "Please go to https://github.com/new to create an empty repository first, then run this script!"
    exit 1
fi

# 前置检查2：检查 Git 用户名和邮箱配置（首次推送必需）
if [[ -z $(git config --global user.name) || -z $(git config --global user.email) ]]; then
    red_echo "Git global username/email not configured! Please run the following commands first:"
    echo "  git config --global user.name \"your-github-username\""
    echo "  git config --global user.email \"your-github-email@example.com\""
    exit 1
fi

# 前置检查3：进入本地仓库目录
if [[ ! -d "$REPO_PATH" ]]; then
    red_echo "Local repository path does not exist! Please check REPO_PATH is correct"
    exit 1
fi
cd "$REPO_PATH" || { red_echo "Failed to enter repository directory!"; exit 1; }

# 步骤1：关联本地仓库与 GitHub 远程仓库
blue_echo "Linking local repository to GitHub remote..."
REMOTE_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git remote add origin "$REMOTE_URL" || {
    # 如果远程已存在，直接更新
    git remote set-url origin "$REMOTE_URL"
    blue_echo "Remote repository already exists, updated the URL"
}

# 步骤2：首次提交所有文件
blue_echo "Committing local files..."
git add .
# 检查是否有文件需要提交，避免空提交
if git diff --cached --quiet; then
    git commit -m "Initial commit: Jailbreak repo basic structure" --allow-empty
else
    git commit -m "Initial commit: Jailbreak repo basic structure"
fi

# 步骤3：推送到 GitHub 远程分支
blue_echo "Pushing to GitHub $BRANCH branch..."
git push -u origin "$BRANCH" || {
    red_echo "Push failed! Possible reasons: 1. Network issues 2. Wrong repo name/username 3. Empty repo not created"
    exit 1
}

# 完成提示
echo -e "\n======================================"
green_echo "Local repository successfully pushed to GitHub!"
echo -e "Next step: Enable GitHub Pages service (critical!)"
echo -e "1. Open your repo: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo -e "2. Go to Settings → Pages"
echo -e "3. Under 'Build and deployment', select 'Deploy from a branch'"
echo -e "4. Choose branch: $BRANCH → / (root) → Click Save"
echo -e "5. Wait 1-5 minutes for it to take effect, your repo URL will be:"
echo -e "   https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
echo -e "======================================"
