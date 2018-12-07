#' Parses CAIDA `asorg2info` Files
#'
#' Please refer to <http://data.caida.org/datasets/as-organizations/> for
#' the data files, acceptable use information and citation information.
#'
#' @section AS fields:
#'
#' `aut` : the AS number
#' `changed` : the changed date provided by its WHOIS entry
#' `aut_name` : the name provide for the individual AS number
#' `org_id` : maps to an organization entry
#' `opaque_id` : opaque identifier used by RIR extended delegation format
#' `source` : the RIR or NIR database which was contained this entry

#' @section Organization fields:
#'
#' - `org_id` : unique ID for the given organization
#' - `changed` : the changed date provided by its WHOIS entry
#' - `name` : name could be selected from the AUT entry tied to the organization, the AUT entry with the largest customer cone, listed for the organization (if there existed an stand alone organization), or a human maintained file.
#' - `country` : some WHOIS provide as a individual field; inferred if not provided
#' - `source` : the RIR or NIR database which was contained this entry
#'
#' @md
#' @param as_org2info_fil path to an "org2info" file (e.g. `20181001.as-org2info.txt.gz`);
#'        [path.expand()] will be run on this value.
#' @return list with two data frames (tibbles): `asorg_info` containing
#'     "`org_id`", "`changed`", "`org_name`", "`country`", "`source`"; and,
#'     `aut_info` containing "`aut`", "`changed`", "`aut_name`", "`org_id`",
#'     "`opaque_id`", "`source`"
#' @export
#' @references <http://data.caida.org/datasets/as-organizations/>
#' @examples \dontrun{
#' parse_asorg2info("20181001.as-org2info.txt.gz")
#' }
parse_asorg2info <- function(as_org2info_fil) {

  as_org2info_fil <- path.expand(as_org2info_fil)

  if (file.exists(as_org2info_fil)) {

    l <- readr::read_lines(as_org2info_fil)

    db_pos <- which(grepl("^# format", l))

    stats::setNames(
      as.data.frame(
        stri_split_fixed(l[(db_pos[1]+1):(db_pos[2]-1)], "|", 5, simplify = TRUE),
        stringsAsFactors = FALSE
      ),
      c("org_id", "changed", "org_name", "country", "source")
    ) -> asorg_info

    class(asorg_info) <- c("tbl_df", "tbl", "data.frame")

    setNames(
      as.data.frame(
        stri_split_fixed(l[(db_pos[2]+1):length(l)], "|", 6, simplify = TRUE),
        stringsAsFactors = FALSE
      ),
      c("aut", "changed", "aut_name", "org_id", "opaque_id", "source")
    ) -> aut_info

    class(aut_info) <- c("tbl_df", "tbl", "data.frame")

    list(
      asorg_info = asorg_info,
      aut_info = aut_info
    )

  } else {
    NULL
  }

}
