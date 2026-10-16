# dsh-animation-zlh

DSH（DeepSeek Harness）开机动画。打开新会话时，视频铺满客户端窗口播放一段片头。

![preview](preview.png)

## 目录结构

参照 [adi1090x/plymouth-themes](https://github.com/adi1090x/plymouth-themes) 的组织方式：每个动画是**自包含、同名**的文件夹，内含素材与描述文件。

```
.
├── preview.png              # 预览图
├── showanimation.sh         # 本地预览脚本
└── zlh_intro/               # 动画主题目录
    ├── zlh_intro.theme      # 主题描述文件（对应 plymouth 的 .plymouth）
    ├── zlh_intro.mp4        # 动画视频
    └── zlh_intro.json       # 播放配置
```

## 主题：zlh_intro

| 项目 | 值 |
| --- | --- |
| 分辨率 | 768×576 |
| 帧率 | 30 fps |
| 时长 | 5.64 s |
| 编码 | H.264 (High) + AAC |
| 容器 | MP4，已启用 faststart（moov 位于文件头部，可边下边播） |
| 音轨 | 保留原声 |

## 预览

```sh
./showanimation.sh          # 播放 10 秒
./showanimation.sh 5        # 播放 5 秒
./showanimation.sh full     # 完整播放一遍
```

需要 ffplay（ffmpeg 自带），或 mpv / vlc 作为后备。

## 安装到 DSH

先安装 [dsh-boot-animation](https://github.com/NativeDog1/dsh-boot-animation) 插件：

```sh
dsh plugin --profile desktop add github:NativeDog1/dsh-boot-animation
```

然后把主题文件放到 DSH 的动画目录：

```sh
mkdir -p ~/.dsh/boot-animation
cp zlh_intro/zlh_intro.mp4 ~/.dsh/boot-animation/intro.mp4
cp zlh_intro/zlh_intro.json ~/.dsh/boot-animation/selection.json
```

### 关于 selectedClipId

zlh_intro.json 里的 selectedClipId 是插件按文件内容生成的 id。**换机器或换文件后需要改成该机上的实际值**：

```sh
curl http://127.0.0.1:19387/dsh-boot-animation/status.json
```

在返回的 videos 数组里找到 source 为 yours 的那一项，把它的 id 填进 selection.json 的 selectedClipId，即可确保每次播放的都是这个片头。

## 配置项说明

| 字段 | 当前值 | 含义 |
| --- | --- | --- |
| selectedClipId | intro-b2f82b4d | 钉选播放的片段 id |
| randomPlayback | false | 关闭随机播放，避免播到插件内置片头 |
| fitMode | contain | 完整显示整个画面，左右留黑边。改成 cover 则铺满窗口但会裁掉上下 |
| playOnAppStart | true | 每次启动 DSH 播放一次 |
| conversationOverrides | {} | 单会话覆盖，未使用 |

## 备注

- 视频已用 delogo 去除原始素材左上角的水印。
- 源素材为 768×576，未做放大，保持原始分辨率。
- 若安装后没有反应，在应用窗口按 **Ctrl+Shift+R** 硬刷新。DSH 给客户端资源设置了长缓存，普通 F5 不足以更新。

## License

素材仅供个人使用。代码部分见 [LICENSE](LICENSE)。
