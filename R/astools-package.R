#' Tools to Work With Autonomous System ('AS') Data
#'
#' A collection of utilities for downloading, parsing, reading and analyzing
#' autonomous system ('AS') network and organization data from various internet
#' sources including 'CAIDA' (<https://caida.org>) and 'BGP Routing Table Analysis
#' Reports' <https://bgp.potaroo.net>
#'
#' - URL: <https://gitlab.com/hrbrmstr/astools>
#' - BugReports: <https://gitlab.com/hrbrmstr/astools/issues>
#'
#' @md
#' @name astools
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import stringi
#' @importFrom stats setNames
#' @importFrom iptools range_boundaries
#' @importFrom httr GET write_disk stop_for_status
#' @importFrom readr read_delim read_tsv read_lines
NULL
