# code pulled from the incomparable Julia Silge's blog
# https://juliasilge.com/blog/evaluating-stm/

# Lol jk -- not actually going to use this because I don't
# feel like getting set up with google big query.


# ==== Get Data ====

library(bigrquery)
library(tidyverse)

sql <- "#legacySQL
SELECT
  stories.title AS title,
  stories.text AS text,
FROM
  [bigquery-public-data:hacker_news.full] AS stories
WHERE
  stories.deleted IS NULL
LIMIT
  100000"

hacker_news_raw <- bq_perform_query(sql, project = project, max_pages = Inf)


# ==== Clean Data ====
hacker_news_text <- hacker_news_raw %>%
  as_tibble() %>%
  mutate(title = na_if(title, ""),
         text = coalesce(title, text)) %>%
  select(-title) %>%
  mutate(text = str_replace_all(text, "&#x27;|&quot;|&#x2F;", "'"), ## weird encoding
         text = str_replace_all(text, "<a(.*?)>", " "),             ## links 
         text = str_replace_all(text, "&gt;|&lt;|&amp;", " "),      ## html yuck
         text = str_replace_all(text, "&#[:digit:]+;", " "),        ## html yuck
         text = str_remove_all(text, "<[^>]*>"),                    ## mmmmm, more html yuck
         postID = row_number()) 