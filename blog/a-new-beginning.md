---
date: 2022-06-26 20:00:00 GMT
article.title: A new beginning
article.description: A simple blog with OCaml
tags:
  - Blog
  - OCaml
---


The last time I had a blog was maybe 15 years ago, at that time I was playing with PHP and MySQL, learning the basics of databases and web development. Just enough to have a simple blog with articles and tags. Nothing too fancy. Even back then I didn't want to deal with a generic solution like WordPress, there was an appeal to develop my own thing, and learn a few things in the process.

Fast forward to 2022. My interest in blogging has returned (a bit). I have been following the work of Pieter Levels, Alex West, Ben Stokes and many more for some time, and although I don't have their drive or talent, this blog is already something. I needed a place to share and document some of my projects so here I am. Don't expect too much from this blog.


Now about the technical part. There were a few things I wanted to avoid:
- I didn't want to use a non-technical solution like [Wordpress](https://wordpress.com), [Wix](https://wix.com) and the like. I've briefly tried it in the past, I like to have control over the code, and these platforms are too bloated and over-engineered, it's not for me. But for someone that does not have experience or the time to create a website, go for it!
- I didn't want to use something like [Angular](https://angular.io/), or one of the many more Javascript frameworks available. I don't have experience dealing with Javascript, and just trying to install packages using *npm* has been bad for my mental health.

Nowadays it seems that tools like [Jekyll](https://jekyllrb.com/) are widely used for technical/developer blogs. With this approach, you don't have to plug into a database, pages and articles of the website are stored in markdown files, then translated into HTML.
I came across [dinosaure's blog](https://blog.osau.re/), using [yocaml](https://github.com/xhtmlboi/yocaml). Yocaml is like Jekyll but for [OCaml](https://ocaml.org). Having to deal with OCaml is a strong plus for me, as it has always been my language of choice for many years now and it makes it easier for me to customize everything. Although after tinkering the engine to your liking you don't need to use OCaml to write more blog posts.
I encourage you to read [this article](https://blog.osau.re/articles/blog_requiem.html) to get more technical details.


Yocaml fulfills all my needs, let's get started then. I've forked *dinosaure*'s [blog repository](https://github.com/dinosaure/blogger), modified the theme for something easier to read (to my taste), and also made the HTML templates slightly more customizable. Here is [my fork](https://github.com/gpetiot/blogger) that contains the source of this website.

Now that this article is written, let's generate the HTML pages and host them online. And voila, the blog is live!
