# Refresh the list of RPubs documents shown at marce10.github.io/projects/
# Scrapes https://rpubs.com/marcelo-araya-salas and writes static/projects/docs.json
# with the direct AWS (S3) link of each document. Run from the project root:
#   Rscript scripts/update_projects.R

library(rvest)

profile <- "https://rpubs.com/marcelo-araya-salas"
page <- read_html(profile)
tiles <- html_elements(page, ".pubtile")

docs <- lapply(tiles, function(x) {
  thumb <- html_attr(html_element(x, "img.pubthumb"), "src")
  s3 <- URLdecode(sub(".*[?&]url=([^&]+).*", "\\1", thumb))
  s3 <- sub("^http://", "https://", s3)

  list(
    title = trimws(html_text(html_element(x, "h5"))),
    desc = trimws(html_text(html_element(x, ".desc"))),
    date = html_attr(html_element(x, "time"), "datetime"),
    url = s3,
    rpubs = html_attr(html_element(x, "a"), "href"),
    thumb = thumb
  )
})

docs <- docs[order(sapply(docs, `[[`, "date"), decreasing = TRUE)]

dir.create("static/projects", showWarnings = FALSE, recursive = TRUE)
jsonlite::write_json(docs, "static/projects/docs.json", auto_unbox = TRUE, pretty = TRUE)

message(length(docs), " documents written to static/projects/docs.json")
