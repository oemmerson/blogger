module Site = struct
  let domain = "https://callmegi.com"
  let title = "Call me Gi"
  let description = ""
end

module Author = struct
  let name = "Guillaume Petiot"
  let email = "guillaume@tarides.com"
end

module Rss = struct
  let title = Site.title
  let link = Site.domain
  let description = ""
  let generator = "yocaml"
end
