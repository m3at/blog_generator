+++
categories = []
date = 2021-04-13T06:30:26Z
draft = true
mathjax = false
tags = ["video"]
title = "Basic watermark removal in videos"

+++
# Basic watermark removal in videos

The general problem of completing images and videos depending on a mask is called [inpainting](https://en.wikipedia.org/wiki/Inpainting), and numerous methods exists to tackle this problem in [ingenuous ways](https://dmitryulyanov.github.io/deep_image_prior "deep image prior"). 

However most approaches are relatively costly to run, especially without a graphic card, so I wanted to see what result we could get with simple and fast methods.

![](/uploads/watermark_removal.webp)

You can find the [repository here](https://github.com/m3at/video-watermark-removal "video-watermark-removal").