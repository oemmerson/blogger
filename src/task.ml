open Yocaml
module Metaformat = Yocaml_yaml
module Markup = Yocaml_markdown
module Template = Yocaml_jingoo

let css_target target = "css" |> into target
let pub_target target = "pub" |> into target
let javascript_target target = "js" |> into target
let images_target target = "images" |> into target
let template file = add_extension file "html" |> into "templates"
let post_template = template "post"
let layout_template = template "layout"
let blog_template = template "blog"
let post_target file target = Model.article_path file |> into target
let binary_update = Build.watch Sys.argv.(0)
let blog_html target = "blog.html" |> into target
let blog_md = "blog.md" |> into "pages"
let rss_feed target = "feed.xml" |> into target
let tag_file tag target = Model.tag_path tag |> into target
let tag_template = template "tag"

let move_css target =
  process_files
    [ "css" ]
    File.is_css
    (Build.copy_file ~into:(css_target target))
;;

let move_javascript target =
  process_files
    [ "js" ]
    File.is_javascript
    (Build.copy_file ~into:(javascript_target target))
;;

let move_images target =
  process_files
    [ "images" ]
    File.is_image
    (Build.copy_file ~into:(images_target target))
;;

let move_pdf target =
  process_files
    [ "pub" ]
    File.is_pdf
    (Build.copy_file ~into:(pub_target target))
;;

let process_posts target =
  process_files [ "blog" ] File.is_markdown (fun file ->
    let open Build in
    create_file
      (post_target file target)
      (binary_update
      >>> Metaformat.read_file_with_metadata (module Model.Article) file
      >>> Markup.content_to_html ()
      >>> Template.apply_as_template (module Model.Article) post_template
      >>> Template.apply_as_template (module Model.Article) layout_template
      >>^ Stdlib.snd))
;;

let merge_posts_with_page ((meta, content), posts) =
  let title = Metadata.Page.title meta in
  let description = Metadata.Page.description meta in
  let site =
    Model.Site.make
      ~domain:Conf.Site.domain
      ~title:Conf.Site.title
      ~description:Conf.Site.description
  in
  Model.Articles.make ?title ?description posts site, content
;;

let merge_with_page (meta, content) =
  let title = Metadata.Page.title meta in
  let description = Metadata.Page.description meta in
  let site =
    Model.Site.make
      ~domain:Conf.Site.domain
      ~title:Conf.Site.title
      ~description:Conf.Site.description
  in
  Model.Page.make ?title ?description site, content
;;

let generate_feed target =
  let open Build in
  let* posts_arrow = Collection.Articles.get_all (module Metaformat) "blog" in
  create_file
    (rss_feed target)
    (binary_update >>> posts_arrow >>^ Feed.make >>^ Rss.Channel.to_rss)
;;

let generate_tags target =
  let* deps, tags = Collection.Tags.compute (module Metaformat) "blog" in
  let tags_string = List.map (fun (i, s) -> i, List.length s) tags in
  let mk_meta tag posts () = Model.Tag.make tag posts tags_string, "" in
  List.fold_left
    (fun program (tag, posts) ->
      let open Build in
      program
      >> create_file
           (tag_file tag target)
           (init deps
           >>> binary_update
           >>^ mk_meta tag posts
           >>> Template.apply_as_template (module Model.Tag) tag_template
           >>> Template.apply_as_template (module Model.Tag) layout_template
           >>^ Stdlib.snd))
    (return ())
    tags
;;

let generate_posts target =
  let open Build in
  let* articles_arrow =
    Collection.Articles.get_all (module Metaformat) "blog"
  in
  create_file
    (blog_html target)
    (binary_update
    >>> Metaformat.read_file_with_metadata (module Metadata.Page) blog_md
    >>> Markup.content_to_html ()
    >>> articles_arrow
    >>^ merge_posts_with_page
    >>> Template.apply_as_template (module Model.Articles) blog_template
    >>> Template.apply_as_template (module Model.Articles) layout_template
    >>^ Stdlib.snd)
;;

let generate_pages target =
  let open Build in
  process_files
    [ "pages/" ]
    (function
     | "blog.md" | "tags.md" -> false
     | x -> File.is_markdown x)
    (fun file ->
      let fname = basename file in
      let html = replace_extension fname "html" |> into target in
      create_file
        html
        (binary_update
        >>> Metaformat.read_file_with_metadata (module Metadata.Page) file
        >>> Markup.content_to_html ()
        >>^ merge_with_page
        >>> Template.apply_as_template (module Model.Page) layout_template
        >>^ Stdlib.snd))
;;
