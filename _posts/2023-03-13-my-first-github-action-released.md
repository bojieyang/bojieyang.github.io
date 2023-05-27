---
layout: post
title: 我的第一个 GitHub Action 发布了
excerpt: 记录我开发并上架第一个 GitHub Action 的过程和从其中学到的东西
categories: ['产品心得']
tags: ['SEO', 'IndexNow', 'GitHub Action', 'IndexNow Action']
image:
  path: "/assets/img/dist/indexnow_action_released.webp"
  alt: "Photo by my screenshot"
---


{: data-content='正文开始'}

* toc 
{:toc}
# 背景

事情的起因是由于 new Bing 整合的 ChatGPT 很好用，让我使用的频率增加了很多。于是我就把博客加入了 Bing Webmaster Tools，然后在其中发现了`IndexNow`这个工具。

这个工具简单来说就是一个搜索引擎的联盟，主动向任何一个联盟内的搜索引擎推送网址收录请求，其他搜索引擎也会得到通知。因此既提高了搜索引擎收录的时效性，又避免了分别向不同的搜索引擎各自提交一遍的繁琐事项，

于是我想用它来实现将每次新发布的博客自动提交给搜索引擎，以便其收录。

由于我的博客是采用`Jekyll`搭建并托管在`GitHub Pages`的静态网站，所以最理想的方式是采用 `Jeykll-plugin`的方式在构建时自动提交给搜索引擎。但是可惜，我没有找到对应的 plugin，而我也不想为了开发这个 plugin 去学习`ruby`这门语言。

于是我想到可以退而求其次，通过 GitHub Action 来实现这个功能。这样除了让我可以用熟悉的语言来开发，还有几个额外的好处：

- **不限制网站框架与部署环境**。由于 GitHub Action 的代码执行环境与任务调度都是独立的，与网站本身是分离的，因此不依赖任何网站框架。基于 Jekyll, Hugo, Hexo，Nextjs，WordPress 等框架构建的网站都可以使用。也不限制部署环境，无论是 静态网站 还是 动态网站 都可以使用。

- **可以和其他 Workflow 集成**。它被设计成既可以单独使用，也可以作为其他 Workflow 的其中一个 Step 执行。

于是说做就做，我花了几天时间，开发了 `IndexNow Action`，目前已经在我的博客上使用起来了。同时也发布到了 GitHub Marketplace，其他人也可以使用。

# 使用方式简介

使用方式很简单，在博客里我就简单介绍一下，完整文档可以去[官方地址][]查看。

```yaml
{% raw %}
# 只要在你的 GitHub workflow 中加入以下 step 就可以使用了。
steps:
  
  - uses: bojieyang/indexnow-action@v1 # v1 is the latest major version following the action-versioning.
    with:
      sitemap-location: "https://example.com/sitemap.xml" # your sitemap location, must start with http(s).
      key: ${{ secrets.INDEXNOW_KEY }} # The key you get from IndexNow.
{% endraw %}
```

# 我从中学到的东西

## 预期花费天数要乘以三
我原本认为我基本上用一天时间就可以完成功能开发和验证，但实际上花了 3 天，其中一天还搞到了凌晨 3 点多（见令人抓狂的小插曲部分）。原因是我自以为懂`javascript`，但实际上我从没在工作中用过这门语言，远远谈不上熟练。因此在开发时各种查语法，查 API 的用法花费了很多时间。再加上低估了写使用文档的时间，让我的实际投入时间大概是预估的三倍多。

总之，实际做起来，就会出现各种预期之外的情况，整体上会比预想的花费时间要多很多。因此要留足缓冲时间，以免到时手忙脚乱。

## 在下一个项目使用 typescript，无论项目大小

我在初始化项目时是用的官方工程模版，官方其实提供了 2 个模版，一个是 `javascript-action`, 另一个是`typescript-action`，我选择了`javascript-action`，原因是我以为代码量很少，体现不出 typescript 静态类型检查的优势，编写类型声明相关代码反而会让编码更繁琐。

事实证明这是个**错误**的决定。由于我的语法不熟，刚开始写出来的代码有各种小问题，如果是静态类型检查，基本上编辑器就直接提示错误了，最不济在编译期间也能发现。但 javascript 的动态类型让这项检查推迟到了运行时，于是我不得不通过 `单元测试 --> 发现一个编码问题 --> 修复后再单元测试 --> 再发现另一个编码问题` 这种方式来完成开发，增加了很多无谓的时间消耗。

这还是一个非常小的项目，动态类型检查对效率的负面影响就已经到了能够感知到的程度。如果是更大的项目，本该在编译时解决的问题被拖到运行时，所浪费的时间会更多。

## 产品的美在于统一，统一要靠规范

GitHub 对规范的重视程度让我吃惊。由于我打算让其他人也能使用这个工具，因此就需要写`README`介绍使用方法。

原本我以为可以随意写，就去找几个知名项目准备借鉴一下。结果让我发现了[GitHub README Spec][]。是的，就连写 `README`也有规范，而且还规范的很详细，各种示例与解释说明都很完整。于是我好奇的随机查看了几个 GitHub 上的仓库，发现他们的 README 都遵循了规范。

进而发现，GitHub 在很多细节上都有规范。比如，要想上架 Marketplace，要遵循 [Action-Versioning][]，一个关于 `GitHub Action` 版本设置的规范。

在 Action 的图标方面，GitHub 也有规范，用户不能自行上传图标，只能从 [feather icons][]中选择图标，但是可以自定义图标颜色。这个方案既规范了图标的尺寸和形状，又避免了审核问题，还保留了一定的自由发挥的空间，真是一举三得，非常巧妙。

在各种细节层面制定规范已经很不容易做到了，GitHub 厉害的地方在于，它让整个社区都能很好的遵循规范，从而让这个社区体现出一种统一的美感。要知道这是一个全球性的社区，其中的难度不言而喻。

# 令人抓狂的小插曲

是什么事情让我凌晨 3 点还在熬夜呢。就是官方模版克隆下来的项目提交到 Workflow 上死活跑不通。

需要的必传参数始终无法注入到 Action 的执行代码中，运行结果就是提示必填参数没有设置。但明明代码和官方示例一摸一样。

我有一个（不好的）习惯，当我认为一个问题应该解决并且我可以解决的时候，不把这个问题解决掉我就睡不着。于是我反复对比我的执行记录和官方执行记录，从怀疑代码到怀疑环境，从怀疑环境到怀疑镜像。每次重试都是同样的错误提示。在网上搜索了很久，也没什么收获。

![让我抓狂的错误提示]
*忽视一条提示引发的惨案*

就在我快要抓狂的时候，突然发现一直存在一条发现高脆弱性代码的提示信息，而这条信息官方示例的执行结果中没有出现。奇诡的是，同样的代码为什么官方的执行结果没有这条提示信息？我当时已经不想再思考这个问题了，看了下关于这个高脆弱性风险的解释和修复方案，很容易修复。于是准备把这个修复后就睡觉，结果发现，修复了这个高脆弱性风险后，奇迹般的，参数注入进去了，执行结果一切正常了。

我顿时来了精神，开始分析（猜测）原因。结果发现，官方的执行结果之所以没有这条高脆弱性提示信息，是因为对应的代码检查规则在最近几天才加入的，而官方的运行结果是几周前的。

我接下来猜测，可能因为这个高脆弱性风险是关于脚本注入的，所以当命中这条规则后，*GitHub Action* 就自动不再进行环境变量传递以规避可能的安全风险。为了验证是否是这种情况，我又把代码改回去实验了一次，结果又执行失败了，果然和我猜测的一致。

![修复高脆弱性风险的代码]
*CodeQL js/shell-command-injection-from-environment*

解决了这个问题后，终于可以睡个好觉了。

事后回想，也许程序员还是有些代码洁癖更好，这样以来，发现存在类似的提示，不管三七二十一先都修复了再说。也就不会出现我这样的情况了。

最后，附上项目[官方地址]，欢迎使用，欢迎反馈 BUG，欢迎 PR。

[官方地址]:<https://github.com/bojieyang/indexnow-action> "indexnow-action repository"
[使用在我博客的示例]:<https://github.com/bojieyang/indexnow-action> "workflow used in my blog"
[GitHub README Spec]:<https://github.com/RichardLitt/standard-readme/blob/master/spec.md> "GitHub README Spec"

[Action-Versioning]:<https://github.com/actions/toolkit/blob/main/docs/action-versioning.md> "Action-Versioning"

[feather icons]:<https://feathericons.com> "feather icons"

[让我抓狂的错误提示]: {{site.url}}/assets/img/dist/the_high_vulnerability_notice.webp
{: width="482" loading="lazy"} 
{: .centered}

[修复高脆弱性风险的代码]: {{site.url}}/assets/img/dist/fix_high_vulnerability_issue.webp
{: width="403" loading="lazy"} 
{: .centered}