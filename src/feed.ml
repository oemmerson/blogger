open Yocaml

let domain = Conf.Rss.link
let feed_url = into domain "feed.xml"

let articles_to_items articles =
  List.map
    (fun (article, url) ->
      Model.Article.to_rss_item (into domain url) article)
    articles
;;

let make ((), articles) =
  Yocaml.Rss.Channel.make
    ~title:Conf.Rss.title
    ~link:domain
    ~feed_link:feed_url
    ~description:Conf.Rss.description
    ~generator:Conf.Rss.generator
    ~webmaster:Conf.Author.email
    (articles_to_items articles)
;;
