#' Parse arbitrary `asnames.txt` downloaded from `bgp.poraroo.net`
#'
#' If you don't want [asnames_current()] and [read_asnames())] to manage
#' `asnames.txt` files for you, you can use this function to parse `asnames.txt`
#' files you've downloaded and manage via other means.
#'
#' @md
#' @param as_fil path to an `asnames.txt` file. [path.expand()] will be run on this value
#' @return data frame (tibble) with "`asn`", "`handle`", "`asinfo`", "`iso2c`"
#' @export
#' @references <https://bgp.potaroo.net/as6447/asnames.txt>
#' @seealso asnames_current
#' @seealso read_asnames
#' @examples \dontrun{
#'    parse_asnames("/tmp/asnames.txt")
#' }
parse_asnames <- function(as_fil) {

  as_fil <- path.expand(as_fil)
  if (!file.exists(as_fil)) stop("File not found.", call.=FALSE)

  suppressWarnings(xdf <- stringi::stri_read_lines(as_fil, fallback_encoding = "UTF-8"))

  as.data.frame(
    stringi::stri_split_regex(xdf, "[[:space:]]+", 2, simplify = TRUE),
    stringsAsFactors = FALSE
  ) -> xdf

  xdf$iso2c <- stringi::stri_match_last_regex(xdf$V2, ",[[:space:]]+([[:alnum:]]+)$")[,2]
  xdf$V2 <- stringi::stri_replace_last_regex(xdf$V2, ",[[:space:]]+([[:alnum:]]+)$", "")
  xdf$handle <- stringi::stri_match_first_regex(xdf$V2, "^[[:upper:][:digit:]-]+")[,1]
  xdf$V2 <- stringi::stri_trim_both(stri_replace_first_regex(xdf$V2, "^[[:upper:][:digit:]-]+", ""))
  xdf$V2 <- stringi::stri_replace_first_regex(xdf$V2, "^[[:space:]]*-[[:space:]]*", "")
  xdf$V2 <- stringi::stri_trim_both(xdf$V2)
  xdf$V2 <- ifelse(xdf$V2 == "", xdf$handle, xdf$V2)
  xdf$V1 <- gsub("^AS", "", xdf$V1)

  xdf <- stats::setNames(xdf[,c(1,4,2,3)], c("asn", "handle", "asinfo", "iso2c"))

  class(xdf) <- c("tbl_df", "tbl", "data.frame")

  xdf

}
