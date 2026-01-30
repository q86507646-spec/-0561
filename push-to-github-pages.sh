#!/bin/bash
# ==================== 配置参数（必须修改！）====================
GITHUB_USERNAME="你的GitHub用户名"   # 例如：octocat
REPO_NAME="你的仓库名称"             # 例如：my-jailbreak-repo
BRANCH="main"                       # 推送的分支（GitHub Pages 推荐用 main 或 gh-pages）
# ==============================================================

# 颜色输出函数
green_echo() { echo -e "\033[32m✅ $1\033[0m"; }
red_echo() { echo -e "\033[31m❌ $1\033[0m"; }
blue_echo() { echo -e "\033[34m🔧 $1\033[0m"; }

# 前置检查1：是否已在 GitHub 手动创建空仓库
blue_echo "重要提示：请先在 GitHub 手动创建【空仓库】（不要勾选 Initialize this repository with a README）"
read -p "是否已创建空仓库？(输入 y 继续，其他退出)：" IS_CREATED
if [[ "$IS_CREATED" != "y" && "$IS_CREATED" != "Y" ]]; then
    red_echo "请先前往 https://github.com/new 创建空仓库，再运行此脚本！"
    exit 1
fi

# 前置检查2：检查 Git 用户名和邮箱配置（首次推送必需）
if [[ -z $(git config --global user.name) || -z $(git config --global user.email) ]]; then
    red_echo "未配置 Git 全局用户名/邮箱！请先执行以下命令配置："
    echo "  git config --global user.name \"你的GitHub用户名\""
    echo "  git config --global user.email \"你的GitHub绑定邮箱\""
    exit 1
fi

# 前置检查3：进入本地仓库目录（确保脚本和仓库在同一目录，或修改下面的路径）
REPO_PATH="$HOME/$REPO_NAME"  # 与之前创建仓库的路径一致
if [[ ! -d "$REPO_PATH" ]]; then
    red_echo "本地仓库路径不存在！请检查 REPO_PATH 是否正确"
    exit 1
fi
cd "$REPO_PATH" || { red_echo "进入仓库目录失败！"; exit 1; }

# 步骤1：关联本地仓库与 GitHub 远程仓库
blue_echo "关联本地仓库到 GitHub 远程仓库..."
REMOTE_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git remote add origin "$REMOTE_URL" || {
    # 如果远程已存在，直接更新
    git remote set-url origin "$REMOTE_URL"
    blue_echo "远程仓库已存在，已更新关联地址"
}

# 步骤2：首次提交所有文件
blue_echo "提交本地仓库文件..."
git add .
git commit -m "Initial commit: Jailbreak repo basic structure" --allow-empty

# 步骤3：推送到 GitHub 远程分支
blue_echo "推送到 GitHub $BRANCH 分支..."
git push -u origin "$BRANCH" || {
    red_echo "推送失败！可能原因：1. 网络问题 2. 仓库名/用户名错误 3. 未创建空仓库"
    exit 1
}

# 完成提示
echo -e "\n======================================"
green_echo "🎉 本地仓库首次推送到 GitHub 成功！"
echo -e "📌 下一步：开启 GitHub Pages 服务（关键！）"
echo -e "1. 打开仓库地址：https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo -e "2. 点击 Settings → 左侧栏 Pages"
echo -e "3. Build and deployment → Source 选择：Deploy from a branch"
echo -e "4. Branch 选择：$BRANCH → / (root) → 点击 Save"
echo -e "5. 等待 1-5 分钟，Pages 服务生效后，你的源地址为："
echo -e "   https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
echo -e "======================================"
