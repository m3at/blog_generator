+++
categories = []
date = 2021-04-13T06:30:26Z
mathjax = false
tags = ["video"]
title = "Basic watermark removal in videos"

+++
The general problem of completing images and videos depending on a mask is called [inpainting](https://en.wikipedia.org/wiki/Inpainting), and numerous methods exists to tackle this problem in [ingenuous ways](https://dmitryulyanov.github.io/deep_image_prior "deep image prior").

However most approaches are relatively costly to run, especially without a graphic card, so I wanted to see what result we could get with simple and fast methods.

You can find the code for the steps below in [this repository](https://github.com/m3at/video-watermark-removal "github video-watermark-removal").

![Watermark removal on one frame](/uploads/watermark_removal.webp "Example watermark removal")

To start, we need to find the mask, which correspond to the location of pixels to remove.

Using [ffmpeg](https://www.ffmpeg.org/ "ffmpeg website") we can extract the timestamps of the [key frames](https://en.wikipedia.org/wiki/Key_frame "key frame") in the video. Getting only the timing is fast, and we can later cap to a maximum the number of frames to actually extract. We could also take random frames, but the key frames are more likely to be diverse (can't be too close in time), and faster to extract as other frames need to be reconstructed from the closest key.

With ffmpeg, we just need to run:

```bash
ffprobe -select_streams v -skip_frame nokey -show_frames -show_entries frame=pkt_pts_time video.mp4
```

Then for each `TIMESTAMP` obtained, we can extract the frame:

```bash
ffmpeg -ss TIMESTAMP -i video.mp4 -vframes 1 frame.png
```

And lastly we can aggregate the results of a simple image filter over all frames, to create a mask:

```python
# Compute the gradients per image
dx = np.gradient(images, axis=1).mean(axis=3)
dy = np.gradient(images, axis=2).mean(axis=3)

# Average globally
mean_dx = np.abs(np.mean(dx, axis=0))
mean_dy = np.abs(np.mean(dy, axis=0))

# Filter on both axis at a hand picked threshold
threshold = 10
salient = ((mean_dx > threshold) | (mean_dy > threshold)).astype(float)
salient = normalize(gaussian_filter(salient, sigma=3))
mask = ((salient > 0.2) * 255).astype(np.uint8)
```

_Bonus, if one wants to do it without python, it should be doable using ImageMagick's `convert` with the existing_ [_Sobel filter_](https://legacy.imagemagick.org/Usage/convolve/#sobel "Sobel ImageMagick") _and `-evaluate-sequence mean *.png mean.png`._

We now have a global mask to inpaint, so we can simply use ffmpeg's [`removelogo`](https://ffmpeg.org/ffmpeg-filters.html#removelogo) filter to obtain our cleaned-up video:

```bash
ffmpeg -i video.mp4 -vf "removelogo=mask.png" cleaned.mp4
```

This run at around x3 real-time on my aging MacBook Pro (i5-5287U), with a fixed overhead of \~5s for the mask extraction, which is fast! :sparkles:

Clearly the resulting inpainting is not of high quality –we're not even leveraging temporal information across frames– but is reasonable enough as a baseline to compare against real-time approaches.