# Suit Document

## 项目介绍

本项目使用了以下几个工具 MkDocs 包和 Material for MkDocs 主题制作而成，部署到 Firebase 提供的静态页面托管服务上。

## 更新流程

1. 从 main 分支拉一个新的分支。
2. 新的分支上更新 docs 目录的文档。
3. 如果有新增页面，还需要修改 `config/zh/mkdocs.yaml` 下的 `nav` 配置。
4. 提交 PR，提交 PR 后将自动产生新的临时站点提供预览。
5. 合并 PR，合并 PR 后正式版本将自动更新到 [yodo1-suit.web.app](https://yodo1-suit.web.app) 上。

## 目录介绍

```log
.
├── README.md
├── config             # 配置文件目录
│   ├── en
│   │   └── mkdocs.yml # 英文站点配置
│   └── zh
│       └── mkdocs.yml # 中文站点配置
├── docs               # 文档内容目录
│   ├── en             # 英文文档内容目录
│   │   ├── index.md                 
│   ├── index.html     # 统一 Index Page，用来根据语言打开对应的版本
│   └── zh             # 中文文档内容目录
│       ├── android
│       ├── index.md
│       ├── ios
│       └── unity
├── firebase.json      # firebase 配置文件
├── build              # 静态页面存储目录，生成的网页将存储在这里
├── includes
├── legacy               # 暂时没有用到的 markdown 文件目录，后期将删除
├── overrides            # 不涉及语言的资源包，比如 CSS，图片等
│   └── assets
│       ├── images       # 图片目录，调用方式问 `![Unity Settings](/zh/assets/images/unity_setting_3.png){ width="300" }`
│       ├── stylesheets  
├── requirements.txt          # Python 项目依赖文件
└── scripts                   # 一些快捷脚本
    ├── build-all.sh          # 编译全部，并且输出到 build 目录
    └── build-and-preview.sh  # 编译全部，并且输出到 build 目录，并且启动本地 http server
```

## 规范要求

- Markdown 文件需要通过 markdown linter 的检查。建议使用 VSCode 插件，在本地编写的时候就检查一遍
