+++
categories = ["programming"]
date = 2020-12-31T06:16:13Z
draft = true
mathjax = false
tags = ["blog", "programming", "web"]
title = "Creating a static blog, the convoluted way"

+++
_TLDR: I wanted to create a static blog while being able to type articles from a nice UI, from anywhere. It is quite straightforward with_ [_forestry_](https://forestry.io/) _+_ [_hugo_](https://gohugo.io/) _+_ [_github pages_](https://pages.github.com/)_._ [Jump](#tldr-jump) to the solution.

## Motivation

If you're looking to create a blog, you're in luck! There are countless tools to help you get up and running in a few minutes. For example [Hugo](https://gohugo.io/) will generate a static site from a few markdown files, and pushing it to github in a repository named `YOUR_USERNAME.github.io` will put you online.

That's it! You're done! :sparkles:

However if it's too easy it isn't fun. Also by accepting what's good enough, you might actually write _content_ into your blog! Let's not do that.

Here are my requirements:

1. The website should be **static**. It makes hosting cheap or even free.
2. **Modifying any parts** should be possible. I want control of my site.
3. Once set-up, I should be able to **focus on the content**. No distraction from the command line, just press save and be done.
4. Be able to **edit from anywhere**. That typo your friend noticed? Fix it with a quick edit from your phone!

The first two can be satisfied by any static site generator. The third can be solved by a nice tool like [Publii](https://getpublii.com/), though it does make customizing details a bit more tricky. Editing from anywhere is easy with commercial offerings like [WordPress](https://wordpress.com/), but the website is not static and I would need to give up a lot of control.

The solution for all four come from static **content management system** (CMS), which –as the name imply– will provide tools to manage your content and generate your static site.

I found two candidates: [NetlifyCMS](https://www.netlifycms.org/) and [Forestry.io](https://forestry.io/). Both are promising and let you work with a site generator of your choosing. However I need only one, and forestry's editor looked prettier 🤩

## Solution

<a name="tldr-jump"></a>

> If you want to look at the code directly, you can find it [here](https://github.com/m3at/blog_generator). The steps below explain how to get there.

With the context out of the way, here are the necessary steps:

* Create a github repository matching your username, for example `jondoe.github.io` (if you're not familiar with git or github, head [over there](https://pages.github.com/) for some simple explanations). Once done `git clone https://github.com/jondoe/jondoe.github.io`
* Install Hugo and follow the [quick start guide](https://gohugo.io/getting-started/quick-start/). Now is a good time to [choose a theme](https://themes.gohugo.io/). Push the code Hugo created for you into a new repository, for example `https://github.com/`_`jondoe`_`/site_generator`
* Once you're done configuring your site to your liking, copy the generated static site (under `./public`) to your `jondoe.github.io` directory. Push, and admire your website at `https://jondoe.github.io`!
* Now we can setup the CMS. Login with your github account into forestry.io and follow the [quickstart guide](https://forestry.io/docs/quickstart/setup-site/). (I know, I said that for Hugo already, that's the last one I promise!). You will want to link the `site_generator` repo, not the one hosting your generated site itself. Now from forestry you will be able to write new content, however it's not published to github pages yet. 
* To automate the publishing, we will use github actions, that will allow us to push the changes to the static site into the right repository. Luckily some nice folks already did the job for us, so let's use the [example they provide](https://github.com/peaceiris/actions-hugo). There are multiple ways to authenticate from your script, suggest using the [deploy key](https://github.com/peaceiris/actions-gh-pages#%EF%B8%8F-create-ssh-deploy-key). 

That's it! (again)

Now you can edit content from forestry, and upon saving your changes will be published automatically. After a blog post or two, internet fame should follow!