---
date: 2022-08-18 17:25:00 BST
article.title: Ocamlformat-preview is live!
article.description: Preview of Ocamlformat options in the browser
tags:
  - OCaml
  - Projects
---

TLDR: [ocamlformat-preview](https://guillaumepetiot.com/ocamlformat-preview/) is live!

## What is Ocamlformat ?

If you use the `ocaml` programming language you probably already know what `ocamlformat` is. Ocamlformat is an [open-source](https://github.com/ocaml-ppx/ocamlformat) project, part of the ocaml ecosystem, that I maintain since 2018.

It is an auto-formatter for OCaml code. Similarly to what [gofmt](https://go.dev/blog/gofmt) is to Go, or [prettier](https://prettier.io/) is to a few web languages. You write your code without having in mind how to make it pretty (indentation, linebreaks, etc.) and the formatter will take care of it. You can either call manually, or automatically upon saving a file, or building the binary, or making a commit.

The most common workflow is to let the build system (`dune`) apply `ocamlformat` to the code, so the user doesn't have to bother with the command line and the myriad of options available to customize ocamlformat's behavior. The preferred way of customizing ocamlformat is to set an `.ocamlformat` configuration file at the root of the project. Something that looks like:

```
version = 0.24.1
profile = default
```

## Why a preview of ocamlformat options?

Ocamlformat has a lot of options, finding the ones that work for you might take some time. A big share of users are reluctant to have ocamlformat produce a long diff on their code, so they try to fine-tune ocamlformat's configuration to have the formatted code be as close as possible to their original coding style.
Sure it might be possible to edit the configuration file, and re-run `ocamlformat`, rinse and repeat until satisfied. Even more tedious if you don't know what each option is doing, and I admit the documentation can be vague sometimes.

A nice alternative, is to have a graphic interface that allows to have a preview of what each option does on a given source code.

Being the maintainer of ocamlformat for a few years, this request has arisen a few times already. I started a few prototypes in the past but I didn't pushed through. Having some time off, and the heatwave discouraging me from spending too much time outside, I finally pushed through and worked on [ocamlformat-preview](https://guillaumepetiot.com/ocamlformat-preview/).

The code of `ocamlformat-preview` is [available on github](https://github.com/gpetiot/ocamlformat-preview). It lives outside of the main `ocamlformat` repository because (to my opinion) it doesn't make much sense to distribute it with `ocamlformat`. Also it was made on my free time and keeping it separate allows me to design it the way I wish, and more easily refuse to implement features that don't interest me.

## About the implementation

First, at the time of writing this, `ocamlformat-preview` is based on a branch of `ocamlformat` that is not merged yet. Because it's based on more unmerged work, that has been a bit delayed due to summer break.

I had to tinker a bit with the Ocamlformat options, as there is currently no way of iterating on all options. I exported a new type in `Config_option.mli` that looks like this:

```ocaml
type typ = Int | Bool | Range | Ocaml_version | Choice of string list

module UI : sig
  type 'config t =
    { names: string list
    ; values: typ
    ; doc: string
    ; update: 'config -> string -> updated_from -> 'config }
end
```

and we provide a way to build these `'a UI.t`:

```ocaml
(* val to_ui : 'a t -> config UI.t *)
let to_ui option =
  let update conf str from =
    match option.parse str with
    | Ok x -> option.update conf x from
    | Error _ -> conf
  in
  UI.{names= option.names; values= option.values; doc= option.doc; update}
```

We then make sure that each option created correctly sets its type information. We then export these `'a UI.t` from `Conf.t`:

```ocaml
(*
  module UI : sig
    val profile : t Config_option.UI.t
    val fmt_opts : t Config_option.UI.t list
    val opr_opts : t Config_option.UI.t list
  end
*)
module UI = struct
  let profile = C.to_ui profile

  let opr_opts =
    let open Operational in
    [C.to_ui ocaml_version; C.to_ui range]

  let fmt_opts =
    let open Formatting in
    [ (* ... *) ]
end
```

Finally, `ocamlformat-preview` iters on these options to generate the HTML, and takes into consideration the selected values when reformatting the provided code. [js_of_ocaml](https://github.com/ocsigen/js_of_ocaml) does the heavy lifting regarding the HTML and Javascript generation. And voila!
In the following weeks I will bring `ocamlformat`'s API up to speed and maybe improve the webpage a bit.

I'm not sure many people will find this interesting but this was fun to make.
