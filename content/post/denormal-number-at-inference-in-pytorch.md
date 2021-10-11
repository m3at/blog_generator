+++
categories = ["machine learning"]
date = 2021-09-18T11:39:18Z
mathjax = true
tags = ["programming", "machine-learning"]
title = "Denormal number at inference in PyTorch"

+++
The other day at work I noticed a **slowdown in runtime** between a model with random weights compared to tuned ones.

It turned out to be due to [denormal numbers](https://en.m.wikipedia.org/wiki/Subnormal_number) computation on the cpu being much slower than the normal arithmetic. Denormal numbers are very low magnitude floats, treated differently to keep precision.

For deep learning, those are largely below significance and can be flushed to zero without accuracy loss. To do so for example in PyTorch, either set [the appropriate flag](https://pytorch.org/docs/stable/generated/torch.set_flush_denormal.html "https://pytorch.org/docs/stable/generated/torch.set_flush_denormal.html"): `torch.set_flush_denormal(True)`.

Or manually round down your weights, I choose \\(10e-12\\) arbitrarily:

```python
import torch

def flush(v, t=1e-12):
    v[torch.abs(v) < t] = 0.0
    return v

model = ...
model.load_state_dict(
    {k: flush(v) for k, v in torch.load("./model.pth").items()}
)

```

The speedup will be CPU and model dependent, for me it was quite significant (x2!). Hopefully this tip will save you some inference time too.