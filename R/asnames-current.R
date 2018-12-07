#' Retrive current `asnames.txt` from `bgp.poraroo.net`
#'
#' @md
#' @note This function creates "`~/.asnames`" and stores a timestamped copy of
#'       the file in it. These are ~2MB in size so you should peridically
#'       clean out "`~/.asnames`" to reclaim disk space.
#' @return data frame (tibble) with "`asn`", "`handle`", "`asinfo`", "`iso2c`"
#' @export
#' @references <https://bgp.potaroo.net/as6447/asnames.txt>
#' @seealso read_asnames
#' @seealso parse_asnames
#' @examples \dontrun{
#' asnames_current()
#' }
asnames_current <- function() {

  asnames_url <- "https://bgp.potaroo.net/as6447/asnames.txt"

  tdy <- as.character(Sys.Date())

  as_fil <- file.path("~/.asnames", sprintf("%s-asnames.txt", tdy))

  if (!dir.exists("~/.asnames")) {
    message("Creating ~/.asnames to hold timestamped asnames.txt downloads...")
    dir.create("~/.asnames")
  }

  try(httr::GET(url = asnames_url, httr::write_disk(as_fil)) -> res, silent = TRUE)

  if (file.exists(as_fil)) {
    read_asnames(tdy)
  } else {
    NULL
  }

}
