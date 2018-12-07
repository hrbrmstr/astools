#' Convert a `routeviews` data frame to a trie
#'
#' @param x a `routeviews` data frame read in with [routeviews_current()] or
#'        [parse_routeviews()]
#' @param ... ignored (for now)
#' @return an `routeviews_asntrie`
#' @export
#' @examples \dontrun{
#' rv_df <- routeviews_latest()
#' rv_trie <- as_asntrie(rv_df)
#' iptools::ip_to_asn(rv_trie, "174.62.167.97")
#' }
as_asntrie <- function(x, ...) {
  UseMethod("as_asntrie", x)
}

#' @export
as_asntrie.default <- function(x, ...) {
  as_asntrie.routeviews(x, ...)
}

#' @export
as_asntrie.routeviews <- function(x, ...) {

  cidr_split <- stringi::stri_split_fixed(x$cidr, "/", 2, simplify = TRUE)

  ip <- cidr_split[,1]
  mask <- cidr_split[,2]

  prefix <- stringi::stri_sub(iptools::ip_to_binary_string(ip), 1, mask)

  triebeard::trie(prefix, x$asn)

}
