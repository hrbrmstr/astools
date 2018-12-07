#' Parses Arbitrary RouteViews "Prefix-to-AS" Files
#'
#' CAIDA maintains current & historical IPv4/IPv6 Prefix-to-Autonomous System (AS)
#' mappings that have been derived from [RouteViews](http://www.routeviews.org) data.
#'
#' See [the datasets repository](http://data.caida.org/datasets/routing/routeviews-prefix2as>)
#' for usage and citation information.
#'
#' @md
#' @param rv_fil path to a CAIDA Prefix-to-AS file. This will be processed with [path.expand()].
#' @references <http://data.caida.org/datasets/routing/routeviews-prefix2as>
#' @return a data frame (tibble) with "`cidr`" and "`asn`" columns.
#' @seealso routeviews_latest
#' @export
#' @examples \dontrun{
#' # you should cache this vs directly pull OR cache after pulling to avoid
#' # wasting CAIDA bandwidth
#'
#' parse_routeviews("http://data.caida.org/datasets/routing/routeviews-prefix2as/2018/12/routeviews-rv2-20181203-1200.pfx2as.gz")
#' }
parse_routeviews <- function(rv_fil) {

  rv_fil <- path.expand(rv_fil)

  if (file.exists(rv_fil)) {

    xdf <- readr::read_tsv(rv_fil, col_names = c("cidr", "mask", "asn"), col_types = "ccc")

    xdf$cidr <- sprintf("%s/%s", xdf$cidr, xdf$mask)

    xdf$mask <- NULL

    cbind.data.frame(
      xdf, iptools::range_boundaries(xdf$cidr)
    ) -> xdf

    xdf$range <- NULL

    class(xdf) <- c("tbl_df", "tbl", "data.frame")

    xdf

  } else {
    NULL
  }

}
