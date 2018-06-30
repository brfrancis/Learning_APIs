ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

ipak(c("httr","jsonlite","httpuv"))

oauth_endpoints("github")
myapp <- oauth_app(appname = "Learning_APIs",
                   key = "8c46a98ddd4c6ae1a24e",
                   secret = "57f5cdfc6a523060ef6dd85b4c822a8ac4687ade")

## Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/brfrancis/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))


