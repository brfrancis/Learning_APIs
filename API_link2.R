ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

ipak(c("httr","jsonlite","httpuv"))

username <- "8001b815e24cc393c15a99c9bd9f601b"
password <- "e96c27076ca83b47fec1fb10a291e5cb"

base <- "https://api.intrinio.com/"
endpoint <- "prices"
stock <- "AAPL"

call1 <- paste(base,endpoint,"?","ticker","=", stock, sep="")

get_prices <- GET(call1, authenticate(username,password, type = "basic"))
get_prices_text <- content(get_prices, "text")
get_prices_json <- jsonlite::fromJSON(get_prices_text,flatten = TRUE)
get_prices_df <- as.data.frame(get_prices_json)
get_prices_json <- fromJSON(get_prices_text, flatten = TRUE)
get_prices_df <- as.data.frame(get_prices_json)
pages <- get_prices_json$total_pages

for(i in 2:pages){
  call_add <- paste(base,endpoint,"?","ticker","=", stock,"&","page_number=", i, sep="")
  get_prices_add <- GET(call_add, authenticate(username,password, type = "basic"))
  get_prices_text_add <- content(get_prices_add, "text")
  get_prices_json_add <- jsonlite::fromJSON(get_prices_text_add, flatten = TRUE)
  get_prices_df_add <- as.data.frame(get_prices_json_add)
  get_prices_df <- rbind(get_prices_df, get_prices_df_add)
}