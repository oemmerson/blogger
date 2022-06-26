module Site = struct
  let domain = "guillaumepetiot.com"
  let title = "Guillaume Petiot"
  let description = ""
end

module Author = struct
  let name = "Guillaume Petiot"
  let email = "hello@guillaumepetiot.com"
end

module Rss = struct
  let title = Site.title
  let link = "https://" ^ Site.domain
  let description = ""
  let generator = "yocaml"
end
