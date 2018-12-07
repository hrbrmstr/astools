#' Caches & Returns  the latest CAIDA-processed RouteViews "Prefix-to-AS" File
#'
#' CAIDA maintains current & historical IPv4/IPv6 Prefix-to-Autonomous System (AS)
#' mappings that have been derived from [RouteViews](http://www.routeviews.org) data.
#' This function figures the most current file, caches it and returns a data frame.
#'
#' You can see available, historical files via `list.files("~/.routeviews")` and
#' read/parse arbitrary prefix-to-AS CAIDA RouteViews files with [parse_routeviews()].
#'
#' See [the datasets repository](http://data.caida.org/datasets/routing/routeviews-prefix2as>)
#' for usage and citation information.
#'
#' @md
#' @note A "`~/.routeviews`" directory will be created if it does not exist.
#' @references <http://data.caida.org/datasets/routing/routeviews-prefix2as>
#' @return a data frame (tibble) with "`cidr`" and "`asn`" columns.
#' @seealso parse_routeviews
#' @export
#' @examples \dontrun{
#' routeviews_latest()
#' }
routeviews_latest <- function() {

  tdy <- Sys.Date()

  year <- format(tdy, "%Y")
  month <- format(tdy, "%m")

  data_dir <- sprintf("http://data.caida.org/datasets/routing/routeviews-prefix2as/%02s/%02s/", year, month)

  httr::GET(
    url = data_dir,
  ) -> res

  httr::stop_for_status(res)

  doc <- httr::content(res)

  hrefs <- rvest::html_nodes(doc, xpath=".//a[contains(@href, 'as.gz')]")
  hrefs <- rvest::html_attr(hrefs, "href")
  hrefs <- sort(hrefs)

  rv_url <- file.path(data_dir, tail(hrefs, 1))
  rv_fil <- file.path("~/.routeviews", tail(hrefs, 1))

  if (!dir.exists("~/.routeviews")) {
    dir.create("~/.routeviews")
  }

  try(httr::GET(url = rv_url, httr::write_disk(rv_fil)) -> res, silent = TRUE)

  parse_routeviews(rv_fil)

}
