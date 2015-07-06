
# install.packages("rvest")

library(rvest)
country_html <- html("http://ec.europa.eu/eurostat/statistics-explained/index.php/Tutorial:Country_codes_and_protocol_order")
country_html2 <- html("http://ec.europa.eu/eurostat/statistics-explained/index.php/Glossary:Country_codes")
c_tables <- country_html %>% html_table()
c_tables2 <- country_html2 %>% html_table()
eu <- c_tables[[2]]
#mw-content-text


c_tables2 <- country_html2 %>% html_table()

titles <- country_html2 %>% 
  html_node("#mw-content-text") %>% 
  html_nodes("b") %>% 
  html_text() %>% 
  .[-c(1:2)]


