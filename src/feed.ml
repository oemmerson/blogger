open Yocaml

let domain = "https:/callmegi.com"
let feed_url = into domain "feed.xml"

let articles_to_items articles =
  List.map
    (fun (article, url) ->
      Model.Article.to_rss_item (into domain url) article)
    articles
;;

let make ((), articles) =
  Yocaml.Rss.Channel.make
    ~title:"callmegi.com"
    ~link:domain
    ~feed_link:feed_url
    ~description:"Articles about what I learn and what I build"
    ~generator:"yocaml"
    ~webmaster:"guillaume@tarides.com"
    (articles_to_items articles)
;;
