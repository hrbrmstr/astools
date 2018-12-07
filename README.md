
# astools

Tools to Work With Autonomous System (‘AS’) Network and Organization
Data

## Description

A collection of utilities for downloading, parsing, reading and
analyzing autonomous system (‘AS’) network and organization data from
various internet sources including ‘CAIDA’ (<https://caida.org>) and
‘BGP Routing Table Analysis Reports’ <https://bgp.potaroo.net>

## What’s Inside The Tin

The following functions are implemented:

  - `asnames_current`: Retrive current ‘asnames.txt’ from
    ‘bgp.poraroo.net’
  - `read_asnames`: Retrieve an historical `asnames.txt` from local
    cache
  - `parse_asnames`: Parse arbitrary ‘asnames.txt’ downloaded from
    ‘bgp.poraroo.net’
  - `parse_asorg2info`: Parses CAIDA ‘asorg2info’ Files
  - `parse_routeviews`: Parses Arbitrary RouteViews “Prefix-to-AS” Files
  - `as_asntrie`: Convert a ‘routeviews’ data frame to a trie
  - `routeviews_latest`: Caches & Returns the latest CAIDA-processed
    RouteViews “Prefix-to-AS” File

## Installation

``` r
devtools::install_github("hrbrmstr/astools")
```

## Usage

``` r
library(astools)
library(tidyverse)

# current verison
packageVersion("astools")
```

    ## [1] '0.1.0'

### RouteViews Prefix-to-AS

``` r
(rv_df <- routeviews_latest())
```

    ## # A tibble: 786,035 x 6
    ##    cidr         asn   minimum_ip maximum_ip  min_numeric max_numeric
    ##    <chr>        <chr> <chr>      <chr>             <dbl>       <dbl>
    ##  1 1.0.0.0/24   13335 1.0.0.0    1.0.0.255      16777216    16777471
    ##  2 1.0.4.0/22   56203 1.0.4.0    1.0.7.255      16778240    16779263
    ##  3 1.0.4.0/24   56203 1.0.4.0    1.0.4.255      16778240    16778495
    ##  4 1.0.5.0/24   56203 1.0.5.0    1.0.5.255      16778496    16778751
    ##  5 1.0.6.0/24   56203 1.0.6.0    1.0.6.255      16778752    16779007
    ##  6 1.0.7.0/24   56203 1.0.7.0    1.0.7.255      16779008    16779263
    ##  7 1.0.16.0/24  2519  1.0.16.0   1.0.16.255     16781312    16781567
    ##  8 1.0.64.0/18  18144 1.0.64.0   1.0.127.255    16793600    16809983
    ##  9 1.0.128.0/17 23969 1.0.128.0  1.0.255.255    16809984    16842751
    ## 10 1.0.128.0/18 23969 1.0.128.0  1.0.191.255    16809984    16826367
    ## # ... with 786,025 more rows

Which can work with `iptools::ip_to_asn()`:

``` r
rv_trie <- as_asntrie(rv_df)

iptools::ip_to_asn(rv_trie, "174.62.167.97")
```

    ## [1] "7922"

### AS Org-to-Info

``` r
parse_asorg2info("~/Data/20180703.as-org2info.txt.gz")
```

    ## $asorg_info
    ## # A tibble: 71,288 x 5
    ##    org_id        changed  org_name                          country source
    ##    <chr>         <chr>    <chr>                             <chr>   <chr> 
    ##  1 01CO-ARIN     20170128 O1.com                            US      ARIN  
    ##  2 111S-ARIN     20170128 One Eleven Internet Services      US      ARIN  
    ##  3 1800CO-2-ARIN 20171130 1-800 Contacts, Inc.              US      ARIN  
    ##  4 1800FL-ARIN   20150409 1-800-Flowers.com, Inc.           US      ARIN  
    ##  5 1800H-ARIN    20160520 1-800-HOSTING, Inc.               US      ARIN  
    ##  6 1881CS-ARIN   20121010 1881CS/XPC                        US      ARIN  
    ##  7 1FBU-ARIN     20180521 1st Financial Bank USA            US      ARIN  
    ##  8 1GPUC-ARIN    20160531 1798 Global Partners (USA), Corp. US      ARIN  
    ##  9 1STP-ARIN     20170816 FIRST STEP INTERNET, LLC          US      ARIN  
    ## 10 1UWEB-ARIN    20170509 1U Web, INC.                      US      ARIN  
    ## # ... with 71,278 more rows
    ## 
    ## $aut_info
    ## # A tibble: 86,933 x 6
    ##    aut   changed  aut_name     org_id         opaque_id                             source
    ##    <chr> <chr>    <chr>        <chr>          <chr>                                 <chr> 
    ##  1 1     20180220 LVLT-1       LPL-141-ARIN   e5e3b9c13678dfc483fb1f819d70883c_ARIN ARIN  
    ##  2 2     20120621 UDEL-DCN     UNIVER-19-ARIN c3a16289a7ed6fb75fec2e256e5b5101_ARIN ARIN  
    ##  3 3     20100927 MIT-GATEWAYS MIT-2-ARIN     d98c567cda2db06e693f2b574eafe848_ARIN ARIN  
    ##  4 4     20120313 ISI-AS       USC-32-ARIN    8c3f2df306a67e97a7abb5a2a0335865_ARIN ARIN  
    ##  5 5     19950808 SYMBOLICS    SYMBOL-16-ARIN 17758c838b246924a54466f28f2b45ef_ARIN ARIN  
    ##  6 6     20120402 BULL-HN      BHIS-Z-ARIN    481b80475499335d51156e7b72507568_ARIN ARIN  
    ##  7 7     ""       ""           @aut-7-RIPE    ""                                    RIPE  
    ##  8 8     19971110 RICE-AS      RICEUN-ARIN    5f676a1dae02fc7cb708558c3ff1d122_ARIN ARIN  
    ##  9 9     20120402 CMU-ROUTER   CARNEG-Z-ARIN  859ff8395a142b506a4aa4425d450e1d_ARIN ARIN  
    ## 10 10    20000418 CSNET-EXT-AS CCICC-ARIN     3fa2e5aa48f205a7696ea6fbcd437cff_ARIN ARIN  
    ## # ... with 86,923 more rows

### AS Names

``` r
asnames_current()
```

    ## # A tibble: 63,453 x 4
    ##    asn   handle       asinfo                                                iso2c
    ##    <chr> <chr>        <chr>                                                 <chr>
    ##  1 1     LVLT-1       Level 3 Parent, LLC                                   US   
    ##  2 2     UDEL-DCN     University of Delaware                                US   
    ##  3 3     MIT-GATEWAYS Massachusetts Institute of Technology                 US   
    ##  4 4     ISI-AS       University of Southern California                     US   
    ##  5 5     SYMBOLICS    Symbolics, Inc.                                       US   
    ##  6 6     BULL-HN      Bull HN Information Systems Inc.                      US   
    ##  7 7     DSTL         DSTL                                                  GB   
    ##  8 8     RICE-AS      Rice University                                       US   
    ##  9 9     CMU-ROUTER   Carnegie Mellon University                            US   
    ## 10 10    CSNET-EXT-AS CSNET Coordination and Information Center (CSNET-CIC) US   
    ## # ... with 63,443 more rows

### Combining RouteViews & AS Names

These are now cached so there is no re-downloading.

``` r
routeviews_latest() %>% 
  left_join(asnames_current())
```

    ## Joining, by = "asn"

    ## # A tibble: 786,035 x 9
    ##    cidr         asn   minimum_ip maximum_ip  min_numeric max_numeric handle            asinfo                     iso2c
    ##    <chr>        <chr> <chr>      <chr>             <dbl>       <dbl> <chr>             <chr>                      <chr>
    ##  1 1.0.0.0/24   13335 1.0.0.0    1.0.0.255      16777216    16777471 CLOUDFLARENET     Cloudflare, Inc.           US   
    ##  2 1.0.4.0/22   56203 1.0.4.0    1.0.7.255      16778240    16779263 GTELECOM-AUSTRAL… Gtelecom-AUSTRALIA         AU   
    ##  3 1.0.4.0/24   56203 1.0.4.0    1.0.4.255      16778240    16778495 GTELECOM-AUSTRAL… Gtelecom-AUSTRALIA         AU   
    ##  4 1.0.5.0/24   56203 1.0.5.0    1.0.5.255      16778496    16778751 GTELECOM-AUSTRAL… Gtelecom-AUSTRALIA         AU   
    ##  5 1.0.6.0/24   56203 1.0.6.0    1.0.6.255      16778752    16779007 GTELECOM-AUSTRAL… Gtelecom-AUSTRALIA         AU   
    ##  6 1.0.7.0/24   56203 1.0.7.0    1.0.7.255      16779008    16779263 GTELECOM-AUSTRAL… Gtelecom-AUSTRALIA         AU   
    ##  7 1.0.16.0/24  2519  1.0.16.0   1.0.16.255     16781312    16781567 VECTANT           ARTERIA Networks Corporat… JP   
    ##  8 1.0.64.0/18  18144 1.0.64.0   1.0.127.255    16793600    16809983 AS-ENECOM         Energia Communications,In… JP   
    ##  9 1.0.128.0/17 23969 1.0.128.0  1.0.255.255    16809984    16842751 TOT-NET           TOT Public Company Limited TH   
    ## 10 1.0.128.0/18 23969 1.0.128.0  1.0.191.255    16809984    16826367 TOT-NET           TOT Public Company Limited TH   
    ## # ... with 786,025 more rows
