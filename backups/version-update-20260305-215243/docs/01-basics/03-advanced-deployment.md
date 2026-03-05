# 第3章：进阶部署

本章面向需要在特定环境中稳定运行 OpenClaw 的用户，介绍 Windows、Linux、Docker 以及 Cloudflare Workers 四种进阶部署方式。每种方式各有侧重：Windows 部署适合桌面用户日常使用，Linux 部署适合开发者，Docker 部署适合追求环境隔离的运维场景，Cloudflare Workers 部署则适合希望获得全球边缘网络加速的用户。读者可根据自身环境和需求选择合适的方案，完成本章后可继续阅读第4章了解维护升级流程。

---

## 本章导航

本章共包含以下五个主要部分，可按需跳转阅读：

- 3.1节：Windows本地部署
- 3.2节：Linux本地部署
- 3.3节：国内一键安装（完整版）
- 3.4节：Cloudflare Workers部署
- 3.5节：Docker部署

如需了解基础安装流程，请参阅第2章。如需了解系统维护和版本升级方法，请参阅第4章。

---

## 3.1 Windows本地部署

本节适合在 Windows 系统上运行 OpenClaw 的用户。Windows 部署提供两条路径：一是通过 WSL2 搭建完整 Linux 子系统环境（官方推荐），二是直接在 PowerShell 原生环境中安装。两种方式各有适用场景，建议优先尝试 WSL2 方案，以获得最完整的功能支持。需要注意的是，部分依赖操作系统底层接口的集成功能在纯 Windows 环境下受到一定限制。

### 系统要求

在开始部署前，请确认当前环境满足以下硬件和软件要求，否则可能导致安装失败或运行不稳定。见表3-1。

表3-1  Windows部署系统要求

| 类型 | 最低要求 | 推荐配置 |
|------|----------|----------|
| CPU | 2核 | 4核及以上 |
| 内存 | 4GB | 8GB及以上 |
| 硬盘空闲空间 | 10GB | 20GB及以上 |
| 操作系统 | Windows 10 | Windows 11 |
| Node.js | 22.0.0+ | 最新LTS版本 |

硬件不满足推荐配置时，OpenClaw 仍可运行，但在处理大型知识库或高并发请求时响应速度会受到影响。

### 部署方式选择

Windows 提供两种部署路径，两者在功能完整性和配置复杂度上存在差异，见表3-2。

表3-2  Windows两种部署方式对比

| 维度 | WSL2 + Ubuntu | PowerShell原生 |
|------|--------------|----------------|
| 推荐程度 | 强烈推荐 | 可用 |
| 功能完整性 | 完整支持全部功能 | 部分系统集成受限 |
| 配置复杂度 | 需要启用WSL2 | 开箱即得 |
| 适合人群 | 希望获得完整体验 | 不想使用WSL2 |

两种方式在安装 OpenClaw 本身的步骤上基本相同，主要区别在于运行环境的准备阶段。下面分别说明。

---

### 方式一：WSL2 + Ubuntu部署（强烈推荐）

这是官方推荐的 Windows 部署方式，通过 WSL2 在 Windows 上获得完整的 Linux 运行环境，能够支持 OpenClaw 的全部功能，包括守护进程管理、文件系统监听以及各类平台集成。整体流程分为七步，从启用 WSL2 到最终验证安装，每步均有详细说明。

#### 第一步：启用WSL2

以管理员身份打开 PowerShell，依次启用 Linux 子系统功能和虚拟机平台功能，并将 WSL 默认版本设置为 2。命令如下：

```powershell
//第3章/enable-wsl2.ps1
# 启用WSL功能
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 设置WSL 2为默认版本
wsl --set-default-version 2
```

上述命令执行完毕后，系统将提示需要重启计算机。必须完成重启，WSL2 功能才能正式生效，否则后续安装 Ubuntu 时会出现错误。

#### 第二步：安装Ubuntu

重启完成后，需要安装 Ubuntu 发行版作为 WSL2 的 Linux 环境。推荐通过 Microsoft Store 安装，操作直观且版本稳定。具体步骤如下：

打开 Microsoft Store，在搜索栏中输入"Ubuntu 22.04 LTS"或"Ubuntu 24.04 LTS"，找到对应条目后点击"获取"按钮开始下载安装。安装完成后，首次启动 Ubuntu 时系统会要求设置 Linux 用户名和密码，该密码将用于后续所有 `sudo` 操作，请妥善记录。

如果 Microsoft Store 无法访问，可搜索"WSL Ubuntu 离线安装"获取替代安装方式。

#### 第三步：更新Ubuntu系统

Ubuntu 安装完成后，建议立即执行系统更新，确保软件包列表和基础工具处于最新状态，避免后续安装 Node.js 或 OpenClaw 时出现依赖版本冲突。在 Ubuntu 终端中执行，命令如下：

```bash
//第3章/update-ubuntu.sh
# 更新软件包列表
sudo apt update && sudo apt upgrade -y

# 安装基础工具
sudo apt install -y curl git wget build-essential
```

更新过程根据网络状况需要几分钟到十几分钟不等。全部更新完成后，终端会回到命令提示符，此时可以继续下一步。

#### 第四步：安装Node.js 22+

OpenClaw 要求 Node.js 版本不低于 22.0.0。通过 NodeSource 官方仓库安装可以确保获取到正确的版本，并与系统包管理器保持集成。命令如下：

```bash
//第3章/install-nodejs-ubuntu.sh
# 添加NodeSource仓库
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

# 安装Node.js
sudo apt install -y nodejs

# 验证版本（必须≥22.x）
node -v
npm -v
```

安装完成后，执行 `node -v` 应输出类似 `v22.x.x` 的版本号。如图3-1所示，安装完成后可在终端中验证 Node.js 版本信息，确认版本符合要求后再继续下一步。

![Node.js版本验证](https://upload.maynor1024.live/file/1771289022495_1dedf21e9d0772afbfc21192bfb4f695.png)

图3-1  Node.js版本验证界面

#### 第五步：安装OpenClaw

Node.js 环境就绪后，即可通过官方安装脚本完成 OpenClaw 的下载和安装。该脚本会自动检测操作系统环境、下载对应二进制文件并配置好可执行路径。命令如下：

```bash
# 使用一键脚本
curl -fsSL https://openclaw.ai/install.sh | bash
```

脚本执行过程中会输出安装进度，包括下载、解压和路径配置等步骤。若提示"Installation complete"或类似成功信息，则表示安装已顺利完成，可以进入下一步验证。

#### 第六步：验证安装

安装完成后，通过以下命令验证 OpenClaw 是否可以正常调用，并检查系统初始状态。命令如下：

```bash
# 查看版本
openclaw --version

# 查看帮助
openclaw --help

# 查看系统状态
openclaw status
```

如果以上命令均能正常输出结果，说明 OpenClaw 已成功安装在 WSL2 环境中。若提示"command not found"，通常是因为安装路径未添加到 PATH 中，重新开启一个终端窗口再试即可解决。

#### 第七步：配置Windows访问WSL2服务

由于 OpenClaw 网关运行在 WSL2 内部，Windows 宿主机需要通过端口转发才能访问。有两种方法可以实现这一点。

第一种方法是创建一个批处理启动脚本，放置在桌面或任意位置，双击即可在 WSL2 中启动网关并自动打开浏览器。创建启动脚本 start-openclaw.bat，代码如下：

```batch
//第3章/start-openclaw.bat
@echo off
echo Starting OpenClaw Gateway in WSL2...
wsl -d Ubuntu-22.04 -u root service openclaw start
timeout /t 3
start http://localhost:18789
```

第二种方法是直接在 WSL2 终端中手动启动网关，适合需要查看实时日志的场景。命令如下：

```bash
# 在WSL2 Ubuntu终端中
openclaw gateway run --port 18789
```

两种方法均可正常使用。网关启动成功后，在 Windows 浏览器的地址栏中输入 `http://localhost:18789` 即可访问 OpenClaw 的 Web 管理界面。

---

### 方式二：PowerShell原生部署

对于不希望启用 WSL2 的用户，可以直接在 Windows PowerShell 环境中安装和运行 OpenClaw。此方式省去了配置 Linux 子系统的步骤，适合对 Windows 操作更为熟悉的用户。需要注意，原生 Windows 环境下部分依赖 Linux 系统调用的功能（如守护进程自动重启、某些文件监听特性）会受到限制。

#### 第一步：安装Node.js 22+

首先需要在 Windows 上安装 Node.js 22.x LTS 版本。可在浏览器中搜索"Node.js 官网"找到下载页面，选择 Windows 安装包（.msi 格式），下载 22.x LTS 版本后运行安装程序。安装时建议勾选"自动安装必要的工具"选项，该选项会一并安装 Python 和 Visual Studio Build Tools，避免后续编译原生模块时报错。

如图3-2所示，Node.js 安装程序界面中有多个安装选项，请确认勾选了自动安装工具的选项后再点击安装。

![Node.js安装程序](https://upload.maynor1024.live/file/1771289096418_1205021-20260131194900414-968176600.png)

图3-2  Node.js Windows安装程序界面

#### 第二步：验证Node.js安装

安装完成后，打开一个新的 PowerShell 窗口（必须是新窗口，否则 PATH 更新不会生效），执行以下命令确认 Node.js 和 npm 均可正常调用。命令如下：

```powershell
node -v
npm -v
```

两条命令均应输出版本号，且 Node.js 版本应为 `v22.x.x` 或更高。若显示"不是内部或外部命令"，说明安装过程中 PATH 配置未生效，可尝试重启计算机后重新验证。

#### 第三步：以管理员身份安装OpenClaw

PowerShell 原生安装 OpenClaw 需要使用管理员权限，以确保全局 npm 包能够正确写入系统目录。右键点击 PowerShell 图标，选择"以管理员身份运行"，然后执行以下命令。命令如下：

```powershell
# 安装最新稳定版
npm install -g openclaw@latest

# 或安装汉化版
npm install -g @qingchencloud/openclaw-zh@latest
```

安装过程中 npm 会逐步下载并编译依赖包，整个过程通常需要 2 至 5 分钟。如图3-3所示，安装过程会在终端中输出详细的依赖下载和编译进度，出现类似"added XXX packages"的提示即表示安装成功。

![OpenClaw安装过程](https://upload.maynor1024.live/file/1771289122746_1205021-20260131194900472-1442678342.png)

图3-3  OpenClaw安装过程输出界面

#### 第四步：解决安装权限问题

在某些 Windows 系统上，npm 全局安装可能因为执行策略或目录权限问题而失败。遇到此类错误时，可根据报错信息选择以下两种修复方法之一。命令如下：

```powershell
//第3章/fix-permission.ps1
# 方法A：启用PowerShell脚本执行
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 方法B：修改npm安装目录
npm config set prefix "C:\npm"
npm config set cache "C:\npm-cache"

# 将目录添加到PATH
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\npm", "User")
```

方法 A 适用于因执行策略限制导致脚本无法运行的情况；方法 B 适用于因系统目录权限不足导致写入失败的情况。修改完成后，重新以管理员身份运行第三步的安装命令即可。

#### 第五步：验证安装

权限问题解决并安装完成后，执行以下命令验证 OpenClaw 是否可以正常调用。命令如下：

```powershell
openclaw --version
openclaw --help
```

若两条命令均正常输出，说明安装成功。若仍提示找不到命令，可检查 PATH 中是否包含 npm 全局安装目录（默认为 `C:\Users\<用户名>\AppData\Roaming\npm`），必要时手动添加后重启 PowerShell。

#### 第六步：解决常见问题

**问题：sharp模块加载失败**

`sharp` 是 OpenClaw 使用的图像处理模块，在 Windows 原生环境下编译偶尔失败。遇到此问题时，先清理 npm 缓存再强制重新安装，通常可以解决。命令如下：

```powershell
# 清理npm缓存
npm cache clean --force

# 重新安装
npm install -g openclaw@latest --force
```

**问题：Windows Defender阻止**

Windows Defender 有时会将 OpenClaw 的网络监听行为识别为可疑活动并加以阻止，导致网关无法正常启动。解决方法是将以下两个目录添加到 Windows Defender 的排除项中，路径如下：

- `C:\Users\你的用户名\AppData\Roaming\npm`
- `C:\Users\你的用户名\.openclaw`

在 Windows 安全中心的病毒和威胁防护设置中，找到"排除项"并添加以上两个文件夹即可。添加后重新启动 OpenClaw 网关，此类误报通常不会再次出现。

---

### 初始化配置

无论使用 WSL2 方式还是 PowerShell 原生方式，安装完成后均需要运行一次初始化向导，完成网关模式选择和平台接入配置。该向导只需运行一次，后续配置变更可通过 `openclaw configure` 命令单独调整。命令如下：

```bash
openclaw onboard --install-daemon
```

配置向导会以交互问答的形式依次引导完成以下配置项：选择网关运行模式（本地或远程）；配置连接的 AI 模型及对应的 API 密钥；可选配置一个或多个聊天平台（如飞书、企微等）；最后选择是否将 OpenClaw 网关注册为系统后台服务，以便开机自动启动。完成全部配置后，向导会输出网关访问地址供验证。

### Windows常用命令速查

Windows 环境下常用的系统管理和配置管理命令汇总如下，供日常运维参考。系统管理类命令见表3-3，配置管理类命令见表3-4。

表3-3  Windows系统管理命令速查

| 命令 | 功能 |
|------|------|
| `openclaw --version` | 查看版本 |
| `openclaw status` | 查看系统状态 |
| `openclaw health` | 健康检查 |
| `openclaw update` | 更新OpenClaw |
| `openclaw doctor` | 诊断系统问题 |

表3-4  Windows配置管理命令速查

| 命令 | 功能 |
|------|------|
| `openclaw onboard` | 初始化向导 |
| `openclaw configure` | 交互式配置 |
| `openclaw config get <key>` | 查看配置项 |
| `openclaw config set <key> <value>` | 修改配置项 |
| `openclaw config unset <key>` | 删除配置项 |

---

## 3.2 Linux本地部署

本节面向熟悉命令行操作的开发者，介绍如何在 Linux 发行版上直接部署 OpenClaw。Linux 环境对 OpenClaw 的支持最为完整，守护进程管理、文件系统监听、定时任务等所有功能均可正常使用。相比 Windows 的 WSL2 方案，Linux 原生部署省去了虚拟化层，性能更优，也更易于与 CI/CD 流程或自动化脚本集成。

### 系统要求

OpenClaw 支持主流的 Linux 长期支持发行版，推荐使用以下版本以获得最佳兼容性：

- Ubuntu 20.04 LTS 及以上版本
- Debian 11 及以上版本
- CentOS 8 及以上版本（含 Rocky Linux、AlmaLinux 等兼容发行版）

系统内核版本建议不低于 4.19，以确保 Node.js 运行时的全部特性可用。内存建议不低于 2GB，磁盘空余空间建议不低于 5GB。

### 安装步骤

Linux 部署流程相对简洁，主要分为安装 Node.js、安装 OpenClaw、验证安装和初始化配置四步，整体耗时通常在 5 至 10 分钟之内。

#### 第一步：安装Node.js

Ubuntu 和 Debian 系发行版建议通过 NodeSource 官方仓库安装，以获得最新的 22.x LTS 版本。CentOS 或 RHEL 系用户可将下方 `apt-get` 命令替换为 `yum install`，其余步骤相同。命令如下：

```bash
//第3章/install-nodejs-linux.sh
# Ubuntu/Debian：添加NodeSource仓库并安装
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# 验证安装，应输出 v22.x.x
node --version
npm --version
```

安装完成后，`node --version` 输出的版本号应不低于 `v22.0.0`。若版本低于此要求，说明系统默认仓库中的 Node.js 版本较旧，需要先按上述步骤添加 NodeSource 仓库再重新安装。

#### 第二步：安装OpenClaw

Node.js 环境就绪后，通过官方安装脚本一键完成 OpenClaw 的安装。脚本会自动检测 Linux 发行版类型并选择合适的安装方式。命令如下：

```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

脚本执行完毕后，终端会输出安装结果摘要，包括 OpenClaw 可执行文件的安装路径以及配置文件的存储位置。若提示权限不足，可在命令前加 `sudo` 再次执行。

#### 第三步：验证安装

安装完成后，打开新的终端窗口（确保 PATH 已更新），执行以下命令验证 OpenClaw 是否可以正常调用。命令如下：

```bash
openclaw --version
```

若输出版本号，则说明安装成功。若提示"command not found"，可执行 `source ~/.bashrc` 或 `source ~/.zshrc` 刷新当前终端的环境变量后再试。

#### 第四步：初始化配置

Linux 环境下的初始化向导与 Windows 完全一致，通过交互式问答完成网关模式和平台接入配置。命令如下：

```bash
openclaw onboard
```

向导结束后，若选择了安装守护进程，OpenClaw 网关会注册为 systemd 服务并随系统启动自动运行。此后可通过 `systemctl status openclaw` 随时查看服务运行状态。

---

## 3.3 国内一键安装（完整版）

本节专为国内网络环境下的用户提供，介绍如何使用官方中文版一键安装脚本完成 OpenClaw 的完整部署。国内版在功能上与官方版完全一致，并额外提供了国产 AI 模型的预配置、国内平台（飞书、企微、钉钉、QQ）的集成支持，以及通过国内镜像源加速下载等优化，适合大多数国内用户作为首选安装方案。

### 为什么选择国内版

国内版相比直接安装官方版具有以下五项主要优势，能够显著降低首次部署的门槛和时间成本：

**速度快**：全程使用国内镜像源下载依赖包，在标准家庭宽带环境下通常 5 分钟内即可完成安装，无需任何网络代理配置。

**中文友好**：安装向导、错误提示和帮助文档均为完整中文，降低了理解成本。

**一键安装**：单条命令自动检测操作系统、安装 Node.js（如未安装）、下载 OpenClaw 主程序并完成路径配置，无需手动处理各环节依赖。

**开箱即用**：预置了国内常用 AI 服务的接入配置模板，初始化向导结束后即可直接连接 Kimi、DeepSeek 等模型，无需额外查阅文档。

**成本优化**：默认配置以国产模型为优先，相比直接使用 OpenAI 或 Anthropic 的 API，可降低推理调用费用。

如图3-4所示，国内版安装脚本运行时会显示进度信息和安装结果摘要，整个过程无需人工干预。

![国内版安装界面](https://upload.maynor1024.live/file/1770956917086_image-20260213122830687.png)

图3-4  国内版安装界面

### 前置要求

在运行安装脚本之前，请确认当前环境已满足以下条件，避免安装中途因依赖缺失而中断。

**必需环境**：系统中需要已安装 Node.js 22.0.0 及以上版本。若尚未安装，可参照 3.2节中的 Node.js 安装步骤先行完成。

**可选工具**：pnpm 包管理器为可选项，仅在需要从源码构建时使用，普通安装不需要。

**平台特定要求**：macOS 用户需要提前安装 Xcode Command Line Tools（在终端执行 `xcode-select --install`）；Windows 用户强烈建议使用 WSL2 Ubuntu 环境；Linux 用户确认系统为 Ubuntu 20.04 或 Debian 11 或 CentOS 8 及以上版本即可。

**可选配置**：若需要 OpenClaw 在回答问题时访问互联网搜索实时信息，可准备 Brave Search API 密钥，安装完成后通过 `openclaw-cn configure --section web` 命令配置。

### 快速开始

根据操作系统类型选择对应的安装命令，各平台具体步骤如下。

#### macOS/Linux安装

在终端中执行以下命令，脚本将自动完成全部安装步骤。命令如下：

```bash
# 使用国内官方安装脚本
curl -fsSL https://clawd.org.cn/install.sh | bash
```

脚本执行过程中会依次输出环境检测结果、依赖下载进度和最终安装状态。若中途因网络问题中断，可重新执行同一命令，脚本会自动跳过已完成的步骤。

#### Windows安装

Windows 用户有两种安装方式，推荐优先使用 WSL2 方案以获得完整功能支持。

若使用 WSL2（推荐），先在 PowerShell 中安装 WSL2，然后在 WSL2 Ubuntu 终端中执行 Linux 安装命令。命令如下：

```powershell
//第3章/install-wsl2.ps1
# 第1步：安装 WSL2（需要管理员身份运行PowerShell）
wsl --install

# 第2步：重启电脑后，在 WSL2 Ubuntu 终端中执行安装命令
curl -fsSL https://clawd.org.cn/install.sh | bash
```

若不使用 WSL2，可直接在 PowerShell（管理员身份）中执行以下命令。命令如下：

```powershell
# 使用国内官方安装脚本（PowerShell原生）
iwr -useb https://clawd.org.cn/install.ps1 | iex
```

PowerShell 原生安装方式功能有所限制，若后续使用中遇到功能异常，建议切换至 WSL2 方案。

#### 全局安装（备用方案）

如果安装脚本因网络或权限原因无法正常执行，可以改用 npm 或 pnpm 直接全局安装 OpenClaw 国内版，效果与脚本安装一致。命令如下：

```bash
# 使用 npm
npm install -g openclaw-cn@latest

# 或使用 pnpm（推荐，安装速度更快）
pnpm add -g openclaw-cn@latest
```

全局安装完成后，`openclaw-cn` 命令即可在终端中直接调用，后续步骤与脚本安装方式完全相同。

### 运行入门向导

安装完成后，必须运行一次入门向导才能完成网关的初始化配置。向导会以交互问答的形式引导完成所有必要配置，通常 3 至 5 分钟即可完成。命令如下：

```bash
# 运行入门向导并安装后台服务
openclaw-cn onboard --install-daemon
```

`--install-daemon` 参数表示同时将 OpenClaw 网关注册为系统后台服务，开机后自动启动，无需每次手动执行。若暂时不需要自动启动，可去掉该参数。

### 配置向导流程

向导运行后，会依次询问以下两个核心配置项，每项均有默认值可直接回车接受。

**网关模式选择**：选择"本地网关（推荐）"意味着 Gateway 运行在当前机器上，所有请求在本地处理，响应速度快且数据不经过第三方服务器。选择"远程网关"则适合将 Gateway 部署在专用服务器上、多台设备共享同一实例的场景。对于个人用户，推荐选择本地网关模式。

**认证方式配置**：支持 OpenAI Codex 订阅（OAuth 方式）和 API 密钥（适合 Anthropic 等提供商）两种认证方式。选择完成后按提示粘贴对应的密钥或完成 OAuth 授权流程即可。

向导完成后，网关服务会自动启动。在浏览器地址栏输入 `http://127.0.0.1:18789/` 即可访问本地管理界面，确认网关正常运行。

### 快速验证

向导完成后，通过以下两条命令可以快速确认网关服务处于正常运行状态。命令如下：

```bash
# 检查运行状态
openclaw-cn status

# 健康检查（验证各组件是否正常）
openclaw-cn health
```

`status` 命令输出服务运行状态和当前配置摘要，`health` 命令则对各核心组件（网络连通性、模型 API 可达性等）逐项检查并输出结果。若有项目显示为异常，可参照输出中的提示信息进行排查。

### 配对与连接聊天界面

OpenClaw 支持通过飞书、企微、钉钉、QQ 等多个聊天平台接入，实现在熟悉的即时通讯工具中直接与 AI 助手对话。国内版已预置了上述平台的接入配置模板，只需完成平台侧的应用创建和密钥填写即可快速接入。各平台的具体配置方法请参阅第11章，其中对每个平台的创建步骤和参数说明均有详细介绍。

---

### 从源码运行（开发）

如果需要修改 OpenClaw 本身的代码或参与开发调试，可以选择从源码构建并运行，以下步骤适合有 Node.js 开发经验的用户。从源码运行的步骤相比普通安装更多，但可以获得最新的开发版特性，并能够即时应用代码修改。命令如下：

```bash
//第3章/build-from-source.sh
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

构建完成后，所有产物位于 `dist/` 目录下。若需要修改代码后立即测试，修改源文件后重新执行 `pnpm build` 即可。

从源码运行 Gateway 时，直接调用构建产物中的入口文件即可，无需额外配置。命令如下：

```bash
node dist/entry.js gateway --port 18789 --verbose
```

`--verbose` 参数会输出详细的调试日志，便于在开发过程中追踪请求处理流程和排查问题。

### 配置文件位置

了解各配置文件的存储位置有助于手动排查问题或在服务器间迁移配置。主要配置文件路径如下所示，各文件用途的说明一并附在注释中。代码如下：

```bash
# 主配置文件
~/.openclaw/openclaw.json

# 认证配置（每个 Agent 独立存储）
~/.openclaw/agents/<agentId>/agent/auth-profiles.json

# OAuth 凭据（旧版格式，仍受支持）
~/.openclaw/credentials/oauth.json

# 网关运行日志
~/.openclaw/logs/gateway.log
```

主配置文件 `openclaw.json` 包含网关端口、模型设置和功能开关等全局配置，可直接用文本编辑器查看和修改，修改后重启网关生效。日志文件 `gateway.log` 是排查运行故障的第一手资料，若服务异常，应优先检查该文件中的错误信息。

### 国内版特色功能

国内版在官方版基础上提供了以下三类专项增强功能，更贴合国内用户的实际使用场景。

**预配置国产模型**：国内版预置了以下主流国产大模型的接入配置，用户只需填入对应的 API 密钥即可直接使用，无需手动编写配置文件：Kimi（月之暗面）、DeepSeek（深度求索）、GLM-4（智谱 AI）、通义千问（阿里）、文心一言（百度）。各模型的 API 密钥获取方式可在对应厂商官网的开发者中心查找。

**国内平台集成**：预置了飞书（字节跳动）、企业微信（腾讯）、钉钉（阿里）、QQ（腾讯）四个国内主流即时通讯平台的接入模板，省去了手动配置 Webhook 地址和消息格式的工作。各平台的详细接入步骤请参阅第11章、第12章和第13章。

**优化的网络配置**：全部依赖下载均通过国内镜像节点完成，同时内置了 API 请求代理配置项，支持为每个 AI 服务单独指定代理地址，解决国内网络环境下部分 API 访问不稳定的问题。

### 常见问题

以下是国内版安装过程中最常遇到的三类问题及其解决方法，供排查参考。

**Q1: 安装失败怎么办？**

安装失败最常见的原因是 Node.js 版本低于 22.0.0。先检查当前版本，若版本不足则使用 nvm 升级后重试。命令如下：

```bash
# 检查 Node.js 版本（需要 22+）
node --version

# 如果版本过低，使用 nvm 升级
nvm install 22
nvm use 22
```

升级完成后重新执行安装脚本即可。若问题依然存在，可尝试全局安装备用方案（见本节"全局安装"部分）。

**Q2: 如何更新到最新版本？**

重新运行安装脚本即可完成更新，脚本会自动检测已安装版本并替换为最新版。命令如下：

```bash
curl -fsSL https://clawd.org.cn/install.sh | bash
```

更新过程中网关服务会短暂中断，更新完成后自动恢复。若使用了守护进程，脚本也会同步更新服务配置。

**Q3: 如何卸载？**

完整卸载分为三步：停止服务、卸载程序包、删除配置文件（可选）。命令如下：

```bash
# 停止并注销后台服务
openclaw-cn gateway stop

# 卸载 npm 包
npm uninstall -g openclaw-cn

# 删除配置和数据文件（可选，删除后配置不可恢复）
rm -rf ~/.openclaw
```

若仅是临时停用而非彻底卸载，建议只执行第一步停止服务，保留配置文件以便后续恢复使用。

---

## 3.4 Cloudflare Workers部署

本节适合希望将 OpenClaw 网关部署在公网并获得全球边缘网络加速的用户。Cloudflare Workers 是 Cloudflare 提供的 Serverless 计算平台，将 OpenClaw 部署在其上后，用户的请求会被路由到全球最近的 Cloudflare 节点处理，能够有效降低延迟。这一方案尤其适合需要 24 小时在线服务、同时不希望自行维护服务器的用户。

### 为什么选择Cloudflare Workers

与本地部署或自建服务器相比，Cloudflare Workers 方案具备以下五项优势，见表3-5。

表3-5  Cloudflare Workers部署优势概览

| 优势 | 说明 |
|------|------|
| 全球加速 | 部署在Cloudflare全球边缘网络，自动就近处理请求 |
| 成本可控 | 5美元/月起步，费用透明 |
| 安全可靠 | 内置Zero Trust安全认证，防止未授权访问 |
| 快速部署 | 一键部署，全程约10分钟 |
| 无需运维 | Serverless架构，无需关注服务器维护 |

需要特别注意的是，Cloudflare Workers 方案需要使用 Workers Paid 计划，每月基础费用为 5 美元，高频使用时可能产生额外的按量计费。在决定使用此方案前，请确认已准备好信用卡用于订阅付费计划。

### 前置要求

在开始部署之前，需要准备以下条件：

- 已注册的 Cloudflare 账号（可在 Cloudflare 官网免费注册，搜索"Cloudflare 注册"即可找到官网）
- 已订阅 Workers Paid 计划（基础费用 5 美元/月，需绑定信用卡）
- 用于创建 R2 对象存储 API 令牌的权限（账号的 Admin 或 Super Administrator 角色）

若账号尚未订阅付费计划，需先前往 Cloudflare 控制台的 Workers 页面完成升级，否则部署步骤中将无法创建 Workers 应用。

### 部署流程

Cloudflare Workers 部署流程共分五步，从一键部署应用到注入环境变量，整个过程约需 10 至 15 分钟。以下步骤假设读者已完成 Cloudflare 账号注册和 Workers Paid 计划订阅。

#### 第一步：一键部署Moltworker

在浏览器中搜索"Cloudflare Workers 一键部署"找到 Cloudflare 官方的部署入口，使用官方提供的部署按钮完成 Moltworker 应用的初始部署。

部署时最重要的配置项是 `MOLTBOT_GATEWAY_TOKEN`，这是后续进入管理后台的唯一凭证，务必修改为足够复杂的自定义密码并妥善保存。建议使用密码管理工具生成随机强密码，长度不少于 32 位。若部署后遗失此 Token，需要重新部署应用才能恢复访问。

如图3-5所示，Cloudflare Workers 部署配置界面会显示所有可配置的环境变量，可在此处直接修改 Token 值。

![Cloudflare Workers 部署](https://upload.maynor1024.live/file/1770956993044_webp)

图3-5  Cloudflare Workers部署配置界面

#### 第二步：等待构建

点击部署按钮后，Cloudflare 会自动拉取代码、编译并部署到边缘网络，整个过程通常需要 10 分钟左右。可以点击页面上的"继续处理项目"跳过等待界面，转到项目管理页面查看构建进度。构建日志中出现"Deployment complete"字样时，表示部署成功完成，可以进行下一步配置。

#### 第三步：配置Access（Zero Trust）

为了保护管理界面不被未授权用户访问，需要通过 Cloudflare Zero Trust 的 Access 功能为 Moltworker 应用配置访问策略。此步骤需要在 Cloudflare 控制台的 Zero Trust 模块中完成，完成后需要记录两个配置变量：`CF_ACCESS_AUD` 和 `CF_ACCESS_TEAM_DOMAIN`。

**创建应用**：进入 Zero Trust 控制台，依次点击 Access、Applications，选择"Add an Application"，应用类型选择"Self-hosted"。

**设置域名**：应用域名的子域填写 `moltbot-sandbox`，主域选择 Cloudflare 分配的 Worker 域名或已绑定的自定义域名。会话时长（Session Duration）建议设置为较长时间（如 30 天），避免频繁重新验证。

**配置策略**：系统会自动生成名为"moltbot-sandbox - Production"的默认策略，使用邮箱验证码方式登录，无需额外修改，保存即可。

**获取 CF_ACCESS_AUD**：策略保存后，在应用列表中找到刚创建的应用，点击右侧的编辑按钮，切换到"Overview"标签页，找到"Application Audience (AUD) Tag"字段，复制其中的哈希值，即为 `CF_ACCESS_AUD` 的值。

**获取 CF_ACCESS_TEAM_DOMAIN**：进入 Zero Trust 的 Settings 页面，在"General"部分找到团队域名，格式为 `xxxxxx.cloudflareaccess.com`，此即为 `CF_ACCESS_TEAM_DOMAIN` 的值。

#### 第四步：配置R2对象存储

OpenClaw 需要使用 Cloudflare R2 对象存储来持久化网关状态数据，因此需要获取 R2 相关的三个配置变量：`CF_ACCOUNT_ID`、`R2_ACCESS_KEY_ID`、`R2_SECRET_ACCESS_KEY`。

**获取 Account ID**：在 Cloudflare 控制台左侧导航中进入 R2 的 Overview 页面，右侧的 Account Details 面板中显示的"Account ID"即为 `CF_ACCOUNT_ID` 的值。

**创建 API 令牌**：在 R2 Overview 页面中点击"Manage R2 API Tokens"，然后选择"Create API Token"。权限类型选择"Object Read & Write"；为降低安全风险，建议在存储桶范围中选择"Specific Bucket"并指定为 `moltbot-data`，而非授予所有存储桶的访问权限。

**保存密钥**：令牌创建成功后，页面会显示"Access Key ID"和"Secret Access Key"两个值，务必在关闭页面前复制并保存，因为 Secret Access Key 只显示一次，之后无法再次查看。

#### 第五步：注入变量并重启

将上述步骤中收集到的所有配置变量注入到 Moltworker 应用中，使其正式生效。操作步骤如下：

进入 Workers 控制台，找到 Moltworker 项目，依次点击 Settings、Variables and Secrets。依次添加以下六个变量：`MOLTBOT_GATEWAY_TOKEN`、`CF_ACCESS_AUD`、`CF_ACCESS_TEAM_DOMAIN`、`CF_ACCOUNT_ID`、`R2_ACCESS_KEY_ID`、`R2_SECRET_ACCESS_KEY`。所有变量均建议设置为"Secret"类型，避免在日志中被明文记录。

变量全部填写完成后，点击"Deploy"按钮重新部署，新的配置将在部署完成后立即生效。

### 访问与管理

部署完成后，可通过以下两种地址访问 Moltworker 服务。访问 Worker 网关接口时需要携带 Token 参数，地址格式如下所示。命令如下：

```
https://moltbot-sandbox.xxxxxxxx.workers.dev?token=MOLTBOT_GATEWAY_TOKEN
```

访问 Web 管理后台时需要通过 Cloudflare Access 的邮箱验证，管理后台地址格式如下。命令如下：

```
https://moltbot-sandbox.xxxxxxxx.workers.dev/_admin/
```

首次访问管理后台时，系统会向账号绑定的邮箱发送一次性验证码，输入验证码后会在本地保存会话凭证，此后在会话有效期内无需重复验证。

### 基础使用

Cloudflare Workers 部署完成后，可以通过以下常用命令对部署的实例进行管理和配置调整。

**查看或切换模型**，命令如下：

```bash
# 查看当前使用的模型
/model

# 切换到指定模型
/model minimax/MiniMax-M2.1
```

**设置开机自启命令**，命令如下：

```bash
set model minimax/MiniMax-M2.1
```

**远程终端连接**：若需要从本地终端远程连接到 Cloudflare Workers 上的网关实例进行配置，使用以下命令登录并完成 Skills 配置。命令如下：

```bash
# 登录到远程 Gateway（将地址替换为实际 Worker 域名）
openclaw gateway login --url https://moltbot-sandbox.xxxxxxxx.workers.dev

# 配置 Skills
openclaw configure --section skills
```

### 成本估算

Cloudflare Workers 部署方案的月度费用构成相对简单，正常个人使用场景下成本基本稳定。见表3-6。

表3-6  Cloudflare Workers部署成本估算

| 项目 | 费用 | 说明 |
|------|------|------|
| Workers Paid 计划 | 5美元/月 | 固定基础费用 |
| 额外请求费用 | 按量计费 | 超出免费额度后产生，个人使用通常不超出 |
| R2 存储 | 免费额度内 | 10GB存储免费，通常不会超出 |
| 总计 | 5-10美元/月 | 取决于请求频率 |

对于个人用户或小团队，月度总费用通常维持在 5 至 10 美元之间。若部署后发现费用异常偏高，可在 Cloudflare 控制台的 Analytics 页面查看请求量统计，排查是否存在异常调用。

---

## 3.5 Docker部署

本节介绍如何使用 Docker 部署 OpenClaw，适合需要严格环境隔离、希望在多台机器上统一部署方案，或在服务器上与其他服务共存的场景。Docker 部署的最大优势在于容器内的 OpenClaw 与宿主系统完全隔离，不会污染系统环境，同时通过 docker-compose 配置文件可以做到一键启动和一键更新，运维成本极低。

### 为什么选择Docker

Docker 部署方案相比本地直接安装具有以下五项主要优势，尤其适合有一定运维经验的用户使用。

**环境隔离**：OpenClaw 及其所有依赖均运行在独立容器内，不会与宿主系统的 Node.js 版本或其他软件产生冲突，卸载时只需删除容器和镜像即可彻底清除，不留任何残余文件。

**一键部署**：通过 docker-compose 配置文件，一条命令即可完成镜像拉取、容器创建、端口映射和环境变量注入，无需手动配置每个细节。

**易于更新**：更新只需拉取新镜像并重启容器，整个过程不超过一分钟，且历史版本镜像可以保留以便回滚。

**跨平台一致性**：同一份 docker-compose.yml 文件在 Windows、macOS 和 Linux 上均可直接使用，彻底消除不同操作系统之间的环境差异。

**快速启动**：熟悉流程后，从零开始部署整个 OpenClaw 服务通常只需 5 分钟。

### 前置要求

使用 Docker 部署前，需要先在宿主系统上安装 Docker Engine 或 Docker Desktop。各平台的安装方式如下，可在各平台的软件包管理器或官方渠道获取安装包（搜索"Docker Desktop 下载"或"Docker Engine 安装"即可找到对应的官方文档）。

**macOS 安装 Docker Desktop**，可通过 Homebrew 安装，命令如下：

```bash
# 使用 Homebrew 安装 Docker Desktop
brew install --cask docker
```

安装完成后，从"应用程序"中启动 Docker Desktop，等待状态栏图标变为稳定状态（不再转动）即表示 Docker 已就绪。

**Windows 安装 Docker Desktop**：在 Windows 下建议先确保 WSL2 已启用，再通过 Docker 官网下载 Docker Desktop 安装包进行安装。命令如下：

```bash
# 安装 WSL2（如果还没安装）
wsl --install
```

WSL2 安装并重启后，运行 Docker Desktop 安装程序，安装向导会自动配置 WSL2 集成。

**Linux (Ubuntu) 安装 Docker Engine**，命令如下：

```bash
//第3章/install-docker-ubuntu.sh
# 使用官方便捷脚本安装 Docker Engine
curl -fsSL https://get.docker.com | sh

# 启动 Docker 服务并设置开机自启
sudo systemctl start docker
sudo systemctl enable docker

# 将当前用户加入 docker 组（避免每次都需要 sudo）
sudo usermod -aG docker $USER
```

执行 `sudo usermod -aG docker $USER` 后需要重新登录（或执行 `newgrp docker`）才能使用户组变更生效。

各平台 Docker 安装完成后，均可通过以下命令验证安装是否成功。命令如下：

```bash
docker --version
# 应显示：Docker version 24.x.x 或更高版本
```

### 快速开始

Docker 部署提供两种方式：一键脚本部署适合希望快速体验的新手用户；手动 Docker Compose 部署则提供更灵活的配置选项，适合需要自定义部署参数的进阶用户。

#### 方式一：一键脚本部署（推荐新手）

一键脚本是最简便的 Docker 部署方式，一条命令完成从环境检测到网关启动的全部步骤，适合对 Docker 不熟悉的用户。命令如下：

```bash
curl -fsSL https://clawd.org.cn/install.sh | bash
```

该脚本会自动完成以下操作：检测宿主系统上的 Docker 环境是否就绪；下载国内镜像（`jiulingyun803/openclaw-cn:latest`）；根据检测到的系统配置自动生成环境变量文件；创建并启动 OpenClaw 容器；运行配置向导收集必要的接入信息；最后生成网关令牌并输出访问地址。

脚本全部执行完毕后，在浏览器中访问 `http://127.0.0.1:18789/` 即可打开 OpenClaw 的 Web 管理界面，确认服务正常运行。

#### 方式二：手动Docker Compose部署（适合进阶用户）

手动部署方式通过显式编写配置文件来完成部署，每个参数均可自由定制，适合需要调整端口映射、数据目录或镜像版本的用户。整个流程共分六步。

**步骤 1：创建工作目录**

所有 OpenClaw Docker 相关文件将存放在此目录下，包括配置文件、数据目录和 docker-compose.yml。命令如下：

```bash
mkdir -p ~/openclaw-docker
cd ~/openclaw-docker
```

**步骤 2：创建 .env 环境文件**

`.env` 文件集中管理所有可变的配置参数，方便后续修改而无需直接编辑 docker-compose.yml。创建时请将 `OPENCLAW_GATEWAY_TOKEN` 替换为自定义的强密码。命令如下：

```bash
//第3章/.env
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

`OPENCLAW_GATEWAY_BIND=lan` 表示网关监听本机所有网络接口，若只需本机访问可改为 `localhost`。

**步骤 3：创建 docker-compose.yml 文件**

docker-compose.yml 定义了 OpenClaw 的两个服务容器：网关容器（`openclaw-cn-gateway`）负责持续运行并处理所有请求；CLI 容器（`openclaw-cn-cli`）则用于交互式执行配置向导等一次性命令。代码如下：

```yaml
//第3章/docker-compose.yml
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

两个容器挂载了相同的数据卷，因此网关容器写入的配置文件可以立即被 CLI 容器读取，两者数据完全共享。

**步骤 4：启动容器**

配置文件准备就绪后，先拉取最新镜像，再以后台模式启动网关容器。命令如下：

```bash
# 拉取最新镜像（首次部署或更新时使用）
docker compose pull

# 以后台模式启动网关容器
docker compose up -d openclaw-cn-gateway

# 查看实时日志，确认启动正常（可选）
docker compose logs -f openclaw-cn-gateway
```

日志中出现类似"Gateway listening on port 18789"的信息时，说明网关已成功启动并进入监听状态。

**步骤 5：运行配置向导**

网关容器启动后，通过 CLI 容器运行一次配置向导，完成初始化配置。CLI 容器以交互模式运行，向导结束后容器自动退出。命令如下：

```bash
docker compose run --rm openclaw-cn-cli onboard
```

`--rm` 参数表示向导结束后自动删除 CLI 容器实例，避免产生废弃的容器占用资源。向导过程与本地安装完全一致，按照提示完成网关模式和认证方式配置即可。

**步骤 6：访问Web UI**

配置向导完成后，在浏览器地址栏输入 `http://127.0.0.1:18789/` 即可访问 OpenClaw 的 Web 管理界面，确认服务正常运行后即完成全部部署步骤。若无法访问，检查 .env 文件中的端口配置是否与本地已占用端口冲突，可修改 `OPENCLAW_GATEWAY_PORT` 后重启容器。

### 常用操作

Docker 部署完成后，以下是日常维护中最常用的操作命令，涵盖状态查看、平台配置、重启和更新四个方面。

#### 查看网关状态

通过以下命令可以快速了解容器运行状态和近期日志，是排查问题的第一步。命令如下：

```bash
# 检查容器是否运行（Running状态为正常）
docker compose ps

# 查看近期日志
docker compose logs openclaw-cn-gateway

# 实时跟踪日志输出（按 Ctrl+C 退出）
docker compose logs -f openclaw-cn-gateway
```

#### 配置渠道

Docker 部署完成后，可以通过飞书、企微、钉钉、QQ 等平台接入 OpenClaw，实现在即时通讯工具中与 AI 助手对话。各平台的具体配置步骤请参阅第11章，其中对每个平台的 Webhook 配置和 Bot 创建均有详细说明。使用第12章和第13章可分别了解飞书以及企微、钉钉、QQ 的专项配置细节。

#### 重启网关

当修改了环境变量或配置文件后，需要重启网关容器使变更生效。命令如下：

```bash
# 重启网关容器（不中断数据卷挂载）
docker compose restart openclaw-cn-gateway

# 完全停止所有容器（数据仍然保留在 data/ 目录中）
docker compose down

# 重新启动
docker compose up -d openclaw-cn-gateway
```

`docker compose down` 只停止和删除容器，不会删除数据卷，因此重新 `up` 后之前的配置和数据均完好保留。

#### 更新到最新版本

Docker 部署的更新流程极为简单，只需拉取新镜像并重启容器即可，整个过程通常在一分钟内完成。命令如下：

```bash
# 拉取最新镜像（新镜像标签仍为 latest，但内容已更新）
docker compose pull

# 重启容器（Docker 会自动使用新拉取的镜像）
docker compose up -d openclaw-cn-gateway
```

更新完成后，可通过 `docker compose logs openclaw-cn-gateway` 查看启动日志，确认新版本正常运行。若新版本出现兼容性问题，可通过修改 `.env` 中的 `OPENCLAW_IMAGE` 指向特定版本标签（如 `jiulingyun803/openclaw-cn:1.2.3`）进行回滚。

### 数据持久化

Docker 容器默认是无状态的，容器删除后其内部数据会随之消失。OpenClaw 通过将数据目录挂载为宿主机卷的方式实现数据持久化，所有配置和工作数据均存储在工作目录下的 `data/` 文件夹中，与容器生命周期无关。数据目录结构如下所示：

```bash
~/openclaw-docker/data/
├── .openclaw/         # 配置文件目录
│   ├── openclaw.json  # 主配置文件
│   └── logs/          # 运行日志
└── clawd/             # 工作空间目录
    └── workspace/     # Agent 工作文件
```

由于数据存储在宿主机上，即使完全重建容器（`docker compose down` 后再 `up`），所有配置和工作数据均会原样保留，无需重新运行配置向导。建议定期对 `data/` 目录进行备份，尤其是在更新前。备份和恢复命令如下：

```bash
# 备份全部配置和数据（文件名中含日期便于区分版本）
tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz ./data

# 恢复指定日期的备份（替换文件名为实际备份文件）
tar -xzf openclaw-backup-20260210.tar.gz
```

备份文件建议存放在不同磁盘或云存储中，避免宿主机故障导致数据和备份同时丢失。

### Docker部署常见问题

以下是 Docker 部署过程中最常见的三类问题及其解决方法，遇到问题时可优先参照此处排查。

**Q1: 容器无法启动**

容器无法启动时，第一步应查看详细错误日志，大多数问题均可从日志中直接找到原因。命令如下：

```bash
# 查看容器启动的详细错误日志
docker compose logs openclaw-cn-gateway

# 检查宿主机端口是否被其他进程占用（Linux/macOS）
sudo netstat -ltnp | grep 18789
# macOS 使用以下命令查看端口占用：
# lsof -i :18789
```

若日志显示端口已被占用，修改 `.env` 中的 `OPENCLAW_GATEWAY_PORT` 为其他未占用端口后重启即可。若日志显示权限错误，参照下方 Q2 的解决方法处理。

**Q2: 权限拒绝**

权限错误通常是因为数据目录不存在或权限不正确，导致容器内的 `node` 用户无法写入挂载目录。执行以下命令创建目录并赋予正确权限后重启容器。命令如下：

```bash
# 确保数据目录存在
mkdir -p ./data/.openclaw ./data/clawd

# 赋予正确的读写权限
chmod 755 ./data/.openclaw ./data/clawd
```

赋权完成后执行 `docker compose up -d openclaw-cn-gateway` 重新启动容器，确认日志中不再出现权限相关错误。

**Q3: 无法访问Web UI**

Web UI 无法访问通常有两种原因：容器未正常运行，或网关监听地址与访问地址不匹配。按以下步骤逐项排查。命令如下：

```bash
# 第1步：确认容器处于运行状态（状态应为 Up）
docker compose ps

# 第2步：查看网关日志，确认监听端口是否与访问地址一致
docker compose logs openclaw-cn-gateway
```

若容器状态显示"Exiting"或"Restarting"，说明容器启动后立即崩溃，需要查看详细日志定位具体错误。若容器运行正常但 Web UI 仍无法访问，检查 `.env` 中的 `OPENCLAW_GATEWAY_BIND` 是否设置为 `lan` 而非 `localhost`，前者允许本机所有接口访问，后者只允许回环地址访问。

---

## 3.6 本章小结

本章系统介绍了 OpenClaw 在四种不同环境下的进阶部署方式，涵盖从个人桌面到全球边缘网络的多种场景。各部署方案的适用场景和主要特点总结如下：

第一，Windows 本地部署提供 WSL2 和 PowerShell 原生两条路径，WSL2 方案功能最完整，是 Windows 用户的首选；PowerShell 方案配置简单，适合对 Linux 子系统不熟悉的用户。

第二，Linux 本地部署适合开发者和服务器场景，Node.js 原生支持最好，所有功能均可正常使用，与 CI/CD 流程集成也最为便利。

第三，国内一键安装方案通过国内镜像和预配置模板大幅降低了部署门槛，同时提供飞书、企微、钉钉、QQ 四个国内平台的集成支持，是国内用户的推荐方案。

第四，Cloudflare Workers 部署适合需要 24 小时公网在线服务且不希望维护服务器的用户，月均费用约 5 至 10 美元，提供全球边缘网络加速。

第五，Docker 部署以环境隔离和运维便利为核心优势，适合在服务器上与其他服务共存，或需要频繁更新和回滚的场景。

完成本章的部署后，可根据实际使用需求阅读后续章节：若需了解日常维护和版本升级方法，请参阅第4章；若希望快速体验核心功能，请参阅第5章；若需要配置聊天平台接入，请参阅第11章（多平台集成）、第12章（飞书专项）和第13章（企微、钉钉、QQ 专项）。
