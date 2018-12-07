#' Retrieve an historical `asnames.txt` from local cache
#'
#' Looks for and loads a `date` timestamped `asnames.txt` from "`~/.asnames`".
#'
#' You can see available `asnames.txt` files via `list.files("~/.asnames")` and
#' read/parse arbitrary `asnames.txt` files with [parse_asnames()].
#'
#' @md
#' @param date character (ISO date) or `Date` of `asnames.txt` to read from "`~/.asnames`";
#' @return data frame (tibble) with "`asn`", "`handle`", "`asinfo`", "`iso2c`"
#' @export
#' @references <https://bgp.potaroo.net/as6447/asnames.txt>
#' @seealso asnames_current
#' @seealso parse_asnames
#' @examples \dontrun{
#'    read_asname("2018-12-05")
#' }
read_asnames <- function(date = Sys.Date()) {

  if (!dir.exists("~/.asnames")) {

    message("~/.asnames directory does not exist. Run asnames_current() to create & prime it.")
    suppressMessages(asnames_current())

  } else {

    as_fil <- file.path("~/.asnames", sprintf("%s-asnames.txt", as.character(as.Date(date))))

    if (!file.exists(as_fil)) stop("Cannot find an asnames.txt file with that timestamp", call.=FALSE)

    parse_asnames(as_fil)

  }

}
