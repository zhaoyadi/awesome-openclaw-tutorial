# 第3章：进阶部署

> 本章介绍Windows、Linux、Docker和Cloudflare Workers等进阶部署方式。

![进阶部署方案](https://upload.maynor1024.live/file/1770963301031_attachment_531c0e90-e8a2-469c-b6ec-b9811a55edfa_image.png)

---

## 📋 本章导航

- [Windows本地部署](#windows本地部署)
- [Linux本地部署](#linux本地部署)
- [国内一键安装（完整版）](#国内一键安装完整版)
- [Cloudflare Workers部署](#cloudflare-workers部署)
- [Docker部署](#docker部署)

**其他章节**：
- 📖 **快速安装** → [第2章：快速安装](02-installation.md)
- 🔧 **维护升级** → [第4章：维护升级](04-maintenance-upgrade.md)

---

## Windows本地部署

> 🪟 **Windows用户**：完全可用，但部分系统集成功能受限。

### 系统要求

**硬件要求**：
- CPU：2核以上
- 内存：4GB以上（推荐8GB）
- 硬盘：10GB以上空闲空间

**操作系统**：
- Windows 10 或 Windows 11

**前置软件**：
- Node.js 22.0.0+

### 部署方式选择

Windows有两种部署方式：

1. **WSL2 + Ubuntu（强烈推荐）**：官方推荐方式，提供完整Linux环境支持
2. **PowerShell原生部署**：纯Windows环境，适合不想使用WSL2的用户

---

### 方式一：WSL2 + Ubuntu部署（强烈推荐）

这是官方推荐的Windows部署方式，提供最完整的Linux环境支持。

#### 第一步：启用WSL2

**以管理员身份打开PowerShell**，执行：

```powershell
# 启用WSL功能
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 设置WSL 2为默认版本
wsl --set-default-version 2
```

**重启计算机**。

#### 第二步：安装Ubuntu

**方法一：Microsoft Store安装（推荐）**

1. 打开Microsoft Store
2. 搜索「Ubuntu 22.04 LTS」或「Ubuntu 24.04 LTS」
3. 点击「获取」并安装
4. 首次启动设置用户名和密码

#### 第三步：更新Ubuntu系统

在Ubuntu终端中执行：

```bash
# 更新软件包列表
sudo apt update && sudo apt upgrade -y

# 安装基础工具
sudo apt install -y curl git wget build-essential
```

#### 第四步：安装Node.js 22+

```bash
# 添加NodeSource仓库
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

# 安装Node.js
sudo apt install -y nodejs

# 验证版本（必须≥22.x）
node -v
npm -v
```

![3.png](https://upload.maynor1024.live/file/1771289022495_1dedf21e9d0772afbfc21192bfb4f695.png)



#### 第五步：安装 OpenClaw

```bash
# 使用一键脚本
curl -fsSL https://openclaw.ai/install.sh | bash
```

#### 第六步：验证安装

```bash
# 查看版本
openclaw --version

# 查看帮助
openclaw --help

# 查看系统状态
openclaw status
```

#### 第七步：配置Windows访问WSL2服务

由于OpenClaw运行在WSL2中，需要配置端口转发以便Windows访问。

**创建启动脚本** `start-openclaw.bat`：

```batch
@echo off
echo Starting OpenClaw Gateway in WSL2...
wsl -d Ubuntu-22.04 -u root service openclaw start
timeout /t 3
start http://localhost:18789
```

或直接在WSL2中启动：

```bash
# 在WSL2 Ubuntu终端中
openclaw gateway run --port 18789
```

然后在Windows浏览器访问 `http://localhost:18789`

---

### 方式二：PowerShell原生部署

适合不想使用WSL2的纯Windows用户。

#### 第一步：安装Node.js 22+

1. 访问 https://nodejs.org/zh-cn
2. 下载Windows安装包（LTS版本22.x）
3. 运行安装程序，勾选「自动安装必要的工具」

![img](https://upload.maynor1024.live/file/1771289096418_1205021-20260131194900414-968176600.png)

#### 第二步：验证Node.js安装

```powershell
# 打开PowerShell
node -v
npm -v
```

#### 第三步：以管理员身份安装 OpenClaw

**重要**：必须以**管理员身份**运行PowerShell。

```powershell
# 安装最新稳定版
npm install -g openclaw@latest

# 或安装汉化版
npm install -g @qingchencloud/openclaw-zh@latest
```

![img](https://upload.maynor1024.live/file/1771289122746_1205021-20260131194900472-1442678342.png)

#### 第四步：解决安装权限问题

如果遇到权限错误：

```powershell
# 方法A：启用PowerShell脚本执行
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 方法B：修改npm安装目录
npm config set prefix "C:\npm"
npm config set cache "C:\npm-cache"

# 将目录添加到PATH
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\npm", "User")
```

#### 第五步：验证安装

```powershell
openclaw --version
openclaw --help
```

#### 第六步：解决常见问题

**问题：sharp模块加载失败**

```powershell
# 清理npm缓存
npm cache clean --force

# 重新安装
npm install -g openclaw@latest --force
```

**问题：Windows Defender阻止**

将OpenClaw安装目录添加到Windows Defender排除项：
- `C:\Users\你的用户名\AppData\Roaming\npm`
- `C:\Users\你的用户名\.openclaw`

---

### 初始化配置

安装完成后，需要运行初始化向导。

```bash
openclaw onboard --install-daemon
```

配置向导会引导你完成：
- ✅ 选择网关模式
- ✅ 配置 AI 模型
- ✅ 配置聊天平台（可选）
- ✅ 安装后台服务





### Windows常用命令速查

**系统管理**：

| 命令 | 功能 |
|------|------|
| `openclaw --version` | 查看版本 |
| `openclaw status` | 查看系统状态 |
| `openclaw health` | 健康检查 |
| `openclaw update` | 更新OpenClaw |
| `openclaw doctor` | 诊断系统问题 |

**配置管理**：

| 命令 | 功能 |
|------|------|
| `openclaw onboard` | 初始化向导 |
| `openclaw configure` | 交互式配置 |
| `openclaw config get <key>` | 查看配置项 |
| `openclaw config set <key> <value>` | 修改配置项 |
| `openclaw config unset <key>` | 删除配置项 |

---

## Linux本地部署

> 🐧 **Linux用户**：适合开发者，配置灵活。

### 系统要求

**推荐发行版**：
- Ubuntu 20.04+
- Debian 11+
- CentOS 8+

### 安装步骤

#### 第一步：安装Node.js

```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# 验证安装
node --version
```

#### 第二步：安装 OpenClaw

```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

#### 第三步：验证安装

```bash
openclaw --version
```

#### 第四步：初始化配置

```bash
openclaw onboard
```

---

## 国内一键安装（完整版）

> 🇨🇳 **国内用户推荐**：使用官方中文版一键安装脚本，速度快、配置简单。

### 为什么选择国内版？

**优势**：
- ⚡ **速度快**：使用国内镜像源，下载速度快
- 🇨🇳 **中文友好**：完整中文界面和提示
- 📦 **一键安装**：自动配置所有依赖
- 🎯 **开箱即用**：预配置国内常用服务
- 💰 **成本优化**：默认配置国产模型

![国内版安装界面](https://upload.maynor1024.live/file/1770956917086_image-20260213122830687.png)

### 前置要求

**必需环境**：
- Node.js 22.0.0+（必需）
- pnpm（可选，推荐用于源码构建）

**推荐配置**：
- Brave Search API 密钥（用于网络搜索）
- 可通过 `openclaw-cn configure --section web` 配置

**系统要求**：
- macOS：需要 Xcode / Command Line Tools
- Windows：强烈推荐使用 WSL2（Ubuntu）
- Linux：Ubuntu 20.04+、Debian、CentOS

### 快速开始

#### macOS/Linux 安装

```bash
# 使用国内官方安装脚本
curl -fsSL https://clawd.org.cn/install.sh | bash
```

#### Windows 安装

使用 PowerShell（管理员权限）：

```powershell
# 使用国内官方安装脚本
iwr -useb https://clawd.org.cn/install.ps1 | iex
```

> ⚠️ **Windows 用户注意**：强烈推荐使用 WSL2（Ubuntu）。

**WSL2 安装步骤**：

```powershell
# 1. 安装 WSL2
wsl --install

# 2. 重启电脑

# 3. 在 WSL2 中运行 Linux 安装命令
curl -fsSL https://clawd.org.cn/install.sh | bash
```

#### 全局安装（替代方案）

如果一键脚本失败，可以使用 npm 全局安装：

```bash
# 使用 npm
npm install -g openclaw-cn@latest

# 或使用 pnpm（推荐）
pnpm add -g openclaw-cn@latest
```

### 运行入门向导

安装完成后，运行配置向导：

```bash
# 运行入门向导并安装后台服务
openclaw-cn onboard --install-daemon
```

### 配置向导流程

向导会引导你完成以下配置：

**1. 选择网关模式**：
- 本地网关（推荐）：Gateway 运行在本机
- 远程网关：Gateway 运行在服务器

**2. 配置认证**：
- OpenAI Code（Codex）订阅（OAuth）
- API 密钥（推荐用于 Anthropic）
：

本地回环地址：`http://127.0.0.1:18789/`

### 快速验证

```bash
# 检查状态
openclaw-cn status

# 健康检查
openclaw-cn health
```

### 配对 + 连接聊天界面

> 💡 提示：可以通过飞书、企微、钉钉、QQ等平台接入OpenClaw。具体配置方法请参考[第11章：多平台集成](../03-advanced/11-multi-platform-integration.md)。

---

### 从源码运行（开发）

如果需要修改 OpenClaw 本身，可以从源码运行：

```bash
# 克隆仓库
git clone https://github.com/clawdbot/clawdbot.git
cd clawdbot

# 安装依赖
pnpm install

# 构建 UI
pnpm ui:build

# 构建项目
pnpm build

# 运行入门向导
openclaw-cn onboard --install-daemon
```

**从源码运行 Gateway**：

```bash
node dist/entry.js gateway --port 18789 --verbose
```

### 配置文件位置

```bash
# 主配置文件
~/.openclaw/openclaw.json

# 认证配置
~/.openclaw/agents/<agentId>/agent/auth-profiles.json

# OAuth 凭据（旧版）
~/.openclaw/credentials/oauth.json

# 日志文件
~/.openclaw/logs/gateway.log
```

### 国内版特色功能

**1. 预配置国产模型**：
- Kimi（月之暗面）
- DeepSeek（深度求索）
- GLM-4（智谱 AI）
- 通义千问（阿里）
- 文心一言（百度）

**2. 国内平台集成**：
- 飞书（字节跳动）
- 企业微信（腾讯）
- 钉钉（阿里）
- QQ（腾讯）

**3. 优化的网络配置**：
- 使用国内镜像源
- 优化 API 访问速度
- 支持代理配置

### 常见问题

**Q1: 安装失败怎么办？**

```bash
# 检查 Node.js 版本（需要 22+）
node --version

# 如果版本过低，使用 nvm 升级
nvm install 22
nvm use 22
```

**Q2: 如何更新到最新版本？**

```bash
# 重新运行安装脚本
curl -fsSL https://clawd.org.cn/install.sh | bash
```

**Q3: 如何卸载？**

```bash
# 停止服务
openclaw-cn gateway stop

# 卸载
npm uninstall -g openclaw-cn

# 删除配置（可选）
rm -rf ~/.openclaw
```

---

## Cloudflare Workers部署

> ☁️ **全球 CDN 加速**：使用 Cloudflare Workers 部署 OpenClaw，享受全球边缘网络加速。

### 为什么选择 Cloudflare Workers？

**优势**：
- 🌍 **全球加速**：部署在 Cloudflare 全球边缘网络
- 💰 **成本可控**：5美元/月起步，24小时在线
- 🔒 **安全可靠**：内置 Zero Trust 安全认证
- ⚡ **快速部署**：一键部署，10分钟完成
- 📦 **无需服务器**：Serverless 架构，无需维护

### 前置要求

**必需条件**：
- Cloudflare 账号
- Workers Paid 计划（5美元/月）
- 信用卡（用于订阅付费计划）

**成本说明**：
- 基础费用：5美元/月（起步价）
- 高频使用可能产生额外费用
- 作为 24 小时在线的 AI 服务，月成本在可接受范围内

### 部署流程

#### 第一步：一键部署 Moltworker

1. **点击部署按钮**：https://deploy.workers.cloudflare.com/?url=https://github.com/cloudflare/moltworker

2. **配置 Gateway Token**：
   - 务必修改并妥善保存 `MOLTBOT_GATEWAY_TOKEN`
   - 这是后续进入管理后台的唯一凭证
   - 建议使用强密码生成器

![Cloudflare Workers 部署](https://upload.maynor1024.live/file/1770956993044_webp)

#### 第二步：等待构建

- 部署过程约需 10 分钟
- 可点击「继续处理项目」跳过等待页面
- 构建完成后会自动跳转到项目页面

#### 第三步：配置 Access（Zero Trust）

访问网页界面需要配置 `CF_ACCESS_AUD` 和 `CF_ACCESS_TEAM_DOMAIN` 两个变量。

**1. 创建应用**：
- 进入 Zero Trust → Access → Applications
- 添加一个 Self-hosted 应用

**2. 设置域名**：
- 子域默认为 `moltbot-sandbox`
- 域名可使用 Cloudflare 分配的 Worker 域名或自定义域名
- Session Duration（会话时间）建议设置长一些

**3. 配置策略**：
- 系统会自动创建 `moltbot-sandbox - Production` 策略
- 默认通过邮箱验证码登录

**4. 获取配置变量**：

**CF_ACCESS_AUD**：
- 保存应用后，点击右侧「⋮」编辑
- 在应用程序受众（AUD）标签页找到 Application Audience (AUD)

**CF_ACCESS_TEAM_DOMAIN**：
- 进入 Zero Trust → Settings
- 团队域名格式：`xxxxxx.cloudflareaccess.com`

#### 第四步：配置 R2 对象存储

OpenClaw 需要 R2 来存储状态，需配置以下三个变量：
- `CF_ACCOUNT_ID`
- `R2_ACCESS_KEY_ID`
- `R2_SECRET_ACCESS_KEY`

**操作步骤**：

**1. 获取 Account ID**：
- 在 Cloudflare 侧边栏进入 R2 → Overview
- 右侧 Account Details 中的 Account ID 即为 `CF_ACCOUNT_ID`

**2. 创建 API 令牌**：
- 点击 Manage R2 API Tokens
- 选择 Create API Token

**3. 设置权限**：
- 权限选择 Object Read & Write
- 建议范围通过 Specific Bucket 限制在 `moltbot-data`

**4. 保存密钥**：
- 创建成功后，记录 Access Key ID 和 Secret Access Key

> ⚠️ **重要提示**：修改 Token 时请务必核对变量名称。

#### 第五步：注入变量并重启

1. **进入设置**：Workers → Settings → Variables and Secrets

2. **填入变量**：
   - `MOLTBOT_GATEWAY_TOKEN`
   - `CF_ACCESS_AUD`
   - `CF_ACCESS_TEAM_DOMAIN`
   - `CF_ACCOUNT_ID`
   - `R2_ACCESS_KEY_ID`
   - `R2_SECRET_ACCESS_KEY`

3. **重新部署**：点击 Deploy 重新部署

### 访问与管理

部署完成后，可通过以下地址访问：

**访问 Worker**（需要 token）：
```
https://moltbot-sandbox.xxxxxxxx.workers.dev?token=MOLTBOT_GATEWAY_TOKEN
```

**管理后台**（需要邮箱验证）：
```
https://moltbot-sandbox.xxxxxxxx.workers.dev/_admin/
```

### 基础使用

#### 查看或切换模型

```bash
# 查看当前模型
/model

# 切换模型
/model minimax/MiniMax-M2.1
```

#### 设置开机自启命令

```bash
set model minimax/MiniMax-M2.1
```

#### 远程终端连接

```bash
# 登录到 Gateway
openclaw gateway login --url https://moltbot-sandbox.xxxxxxxx.workers.dev

# 配置 Skills
openclaw configure --section skills
```

### 成本估算

| 项目 | 费用 | 说明 |
|------|------|------|
| Workers Paid 计划 | 5美元/月 | 基础费用 |
| 额外请求费用 | 按量计费 | 高频使用时产生 |
| R2 存储 | 免费额度内 | 通常不会超出 |
| 总计 | 5-10美元/月 | 取决于使用频率 |

---

## Docker部署

> 🐳 **开发者选项**：Docker 部署适合需要环境隔离的场景。

### 为什么选择 Docker？

**优势**：
- 🔒 **环境隔离**：不影响系统环境，干净整洁
- 📦 **一键部署**：无需配置依赖，开箱即用
- 🔄 **易于更新**：一条命令完成更新
- 🌐 **跨平台**：Windows/macOS/Linux 统一方案
- 🚀 **快速启动**：5分钟完成部署

### 前置要求

**安装 Docker**：

**macOS**：
```bash
# 下载 Docker Desktop
# 访问：https://www.docker.com/products/docker-desktop

# 或使用 Homebrew
brew install --cask docker
```

**Windows**：
```bash
# 下载 Docker Desktop
# 访问：https://www.docker.com/products/docker-desktop

# 安装 WSL2（如果还没安装）
wsl --install
```

**Linux (Ubuntu)**：
```bash
# 安装 Docker
curl -fsSL https://get.docker.com | sh

# 启动 Docker 服务
sudo systemctl start docker
sudo systemctl enable docker

# 添加当前用户到 docker 组
sudo usermod -aG docker $USER
```

**验证安装**：
```bash
docker --version
# 应显示：Docker version 24.x.x
```

### 快速开始

#### 方式一：一键脚本部署（推荐新手）

最简单的方式，一条命令搞定所有配置！

```bash
curl -fsSL https://clawd.org.cn/install.sh | bash
```

**这个脚本会自动：**
- ✅ 检查 Docker 环境
- ✅ 下载镜像（使用国内镜像：`jiulingyun803/openclaw-cn:latest`）
- ✅ 配置环境变量
- ✅ 启动容器
- ✅ 运行配置向导
- ✅ 生成网关令牌

完成后，在浏览器打开 `http://127.0.0.1:18789/` 即可使用。

#### 方式二：手动 Docker Compose 部署（适合进阶用户）

**步骤 1：创建工作目录**

```bash
mkdir -p ~/openclaw-docker
cd ~/openclaw-docker
```

**步骤 2：创建 `.env` 环境文件**

```bash
cat > .env << 'EOF'
# 镜像配置（使用国内镜像）
OPENCLAW_IMAGE=jiulingyun803/openclaw-cn:latest

# 数据目录
OPENCLAW_CONFIG_DIR=./data/.openclaw
OPENCLAW_WORKSPACE_DIR=./data/clawd

# 网关配置
OPENCLAW_GATEWAY_PORT=18789
OPENCLAW_BRIDGE_PORT=18790
OPENCLAW_GATEWAY_BIND=lan
OPENCLAW_GATEWAY_TOKEN=your-secure-token-here
EOF
```

**步骤 3：创建 `docker-compose.yml` 文件**

```yaml
services:
  openclaw-cn-gateway:
    image: ${OPENCLAW_IMAGE:-jiulingyun803/openclaw-cn:latest}
    user: node:node
    environment:
      HOME: /home/node
      TERM: xterm-256color
      OPENCLAW_GATEWAY_TOKEN: ${OPENCLAW_GATEWAY_TOKEN}
    volumes:
      - ${OPENCLAW_CONFIG_DIR:-./data/.openclaw}:/home/node/.openclaw
      - ${OPENCLAW_WORKSPACE_DIR:-./data/clawd}:/home/node/clawd
    ports:
      - "${OPENCLAW_GATEWAY_PORT:-18789}:18789"
      - "${OPENCLAW_BRIDGE_PORT:-18790}:18790"
    init: true
    restart: unless-stopped
    command:
      [
        "node",
        "dist/index.js",
        "gateway",
        "--bind",
        "${OPENCLAW_GATEWAY_BIND:-lan}",
        "--port",
        "${OPENCLAW_GATEWAY_PORT:-18789}"
      ]

  openclaw-cn-cli:
    image: ${OPENCLAW_IMAGE:-jiulingyun803/openclaw-cn:latest}
    user: node:node
    environment:
      HOME: /home/node
      TERM: xterm-256color
      BROWSER: echo
    volumes:
      - ${OPENCLAW_CONFIG_DIR:-./data/.openclaw}:/home/node/.openclaw
      - ${OPENCLAW_WORKSPACE_DIR:-./data/clawd}:/home/node/clawd
    stdin_open: true
    tty: true
    init: true
    entrypoint: ["node", "dist/index.js"]
```

**步骤 4：启动容器**

```bash
# 拉取最新镜像
docker compose pull

# 启动网关（后台运行）
docker compose up -d openclaw-cn-gateway

# 查看日志（可选）
docker compose logs -f openclaw-cn-gateway
```

**步骤 5：运行配置向导**

```bash
docker compose run --rm openclaw-cn-cli onboard
```

**步骤 6：访问 Web UI**

打开浏览器访问：`http://127.0.0.1:18789/`

### 常用操作

#### 查看网关状态

```bash
# 检查容器是否运行
docker compose ps

# 查看网关日志
docker compose logs openclaw-cn-gateway

# 实时查看日志
docker compose logs -f openclaw-cn-gateway
```

#### 配置渠道

> 💡 提示：Docker部署后，可以通过飞书、企微、钉钉、QQ等平台接入OpenClaw。具体配置方法请参考[第11章：多平台集成](../03-advanced/11-multi-platform-integration.md)。

---

#### 重启网关

```bash
# 重启网关容器
docker compose restart openclaw-cn-gateway

# 停止网关
docker compose down

# 重新启动
docker compose up -d openclaw-cn-gateway
```

#### 更新到最新版本

```bash
# 拉取最新镜像
docker compose pull

# 重启容器（自动使用新镜像）
docker compose up -d openclaw-cn-gateway
```

### 数据持久化

Docker 容器的数据存储在工作目录的 `data` 文件夹：

```bash
~/openclaw-docker/data/
├── .openclaw/         # 配置文件
│   ├── openclaw.json  # 主配置
│   └── logs/          # 日志文件
└── clawd/             # 工作空间
    └── workspace/     # 代理工作文件
```

**备份数据**：
```bash
# 备份配置和数据
tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz ./data

# 恢复数据
tar -xzf openclaw-backup-20260210.tar.gz
```

### Docker 部署常见问题

**Q1: 容器无法启动**

```bash
# 查看详细错误日志
docker compose logs openclaw-cn-gateway

# 检查端口是否被占用
sudo netstat -ltnp | grep 18789
# macOS 使用：lsof -i :18789
```

**Q2: 权限拒绝**

```bash
# 确保数据目录存在且权限正确
mkdir -p ./data/.openclaw ./data/clawd
chmod 755 ./data/.openclaw ./data/clawd
```

**Q3: 无法访问 Web UI**

```bash
# 检查容器是否运行
docker compose ps

# 检查网关日志
docker compose logs openclaw-cn-gateway
```

---

## 本章小结

本章介绍了OpenClaw的进阶部署方式：

1. **Windows本地部署**：WSL2+Ubuntu（推荐）或PowerShell原生部署
2. **Linux本地部署**：适合开发者，配置灵活
3. **国内一键安装**：完整版功能，包含源码构建选项
4. **Cloudflare Workers**：全球CDN加速，Serverless架构
5. **Docker部署**：环境隔离，跨平台统一方案

### 下一步

- 📖 **快速安装** → [第2章：快速安装](02-installation.md)
- 🔧 **维护升级** → [第4章：维护升级](04-maintenance-upgrade.md)
- 🚀 **快速上手** → [第5章：快速上手](05-quick-start.md)
- 🔗 **平台集成** → [第11章：多平台集成](../03-advanced/11-multi-platform-integration.md)
