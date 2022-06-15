+++
categories = []
date = 2022-06-15T04:50:04Z
mathjax = false
tags = ["machine-learning", "search", "web"]
title = "Real-time semantic search demo"

+++
**_TLDR_**_: I wanted to make a fast and low complexity "search engine", and got good results with neural network embeddings combined with an approximate vector search._

Recent advances in large deep learning models have brought interesting multi-modal capabilities, notably for combined text and images, like [Imagen](https://imagen.research.google/) and [DALL-E 2](https://openai.com/dall-e-2/) for image synthesis from raw text. [CLIP](https://openai.com/blog/clip/), which is also used in DALL-E for image ranking, allow projecting both text and images into a coherent space.

I want to be able to search images from text, so using CLIP we can project both into the same space, making them comparable. Concretely we obtain vectors, and for pairs of vectors we can take their norm as a distance to find closest ones, and return that as a search result.

In practice comparing one vector (example our query) to all existing ones could be very slow if done exactly. Luckily _approximate_ nearest neighbor (ANN) methods allow us to trade-off a tiny bit of accuracy for massive speed-ups and memory savings. Lots of methods exist ([here for benchmarks](http://ann-benchmarks.com/) and [pinecone](https://www.pinecone.io/learn/) has great docs as an introduction), including innovative [learned quantization methods](https://arxiv.org/abs/2110.05789) that achieve excellent compression.

For the user interaction, any web tech stack can do the job, I went with [FastAPI](https://fastapi.tiangolo.com/) for the backend and [Svelte](https://svelte.dev/) for the frontend.

So let's combine the three!

TODO: add video demo

The demo above search over \~1.5M images, taking about 3Gb of space for the index and with latency under 100ms. This is running on single process from my laptop.

To show off the speed, I prepared a tiny version of all images (<500 bytes) that are returned with the search results and loaded immediately. The full size image is then loaded asynchronously, that can take up to a second as those are random internet images.

Also human typing speed is not that fast, so to make the search field usable I added a delay before triggering the search, so the latency you see is after the search query is sent.

![fast demo](/uploads/ann_demo_short_fast.webm "fast demo with low delay")

Here is an other demo, with full image loading disabled and a lower typing delay, just to show the speed.

I'm quite pleased with those results, there's still a lot that could be done to speed-up the search further but it's fast enough for a prototype. The index size/accuracy ratio could also be improved a lot, and the CLIP model should be transferable into a smaller inference network. Also I could make a UI that doesn't suck 😬

Calling this a "search engine" is a bit of a stretch, there is limited control and no filtering options but the tech stack is very simple (it only took a day to make this demo!). I think simplicity has value in itself. Though with the [recent support of ANN+filtering](https://github.com/elastic/elasticsearch/pull/84734) in Lucene/Elasticsearch the comparison would be interesting.