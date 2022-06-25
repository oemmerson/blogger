module Site : sig
  val domain : string
  val title : string
  val description : string
end

module Author : sig
  val name : string
  val email : string
end

module Rss : sig
  val title : string
  val link : string
  val description : string
  val generator : string
end
