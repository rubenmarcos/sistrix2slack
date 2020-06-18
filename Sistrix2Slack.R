library(tidyverse)
require("httr")
library("xml2")

options(scipen = 999)

# SISTRIX

# API Connection details + Creation of API URLs to be checked
# As an example, data for domain elpais.com and path elpais.com/tecnologia/ in Spain have been taken. 
# Change names for the site/paths you would like to track.
base <- "https://api.sistrix.com/domain.sichtbarkeitsindex"
domain <- "?domain=elpais.com&country=ES&daily=true&history=true&num=1"
tech <- "?path=https://elpais.com/tecnologia/&country=ES&daily=true&history=true&num=1"
mobile <- "&mobile=true"
key <- "&-YOUR_API_KEY_HERE-"

sistrixURLmobile <- paste0(base,domain,mobile,key)
sistrixURLdesktop <- paste0(base,domain,key)
sistrixURLtechmobile <- paste0(base,tech,mobile,key)
sistrixURLtechdesktop <- paste0(base,tech,key)

visibility_mobile <- read_xml(sistrixURLmobile)
visibility_desktop <- read_xml(sistrixURLdesktop)
visibility_tech_mobile <- read_xml(sistrixURLtechmobile)
visibility_tech_desktop <- read_xml(sistrixURLtechdesktop)

# Extract data from XML and assign them to a variable
date <- as.character(as.Date(xml_attrs(xml_child(xml_child(visibility_mobile, 2), 1))[2]))
index_mobile <- as.character(xml_attrs(xml_child(xml_child(visibility_mobile, 2), 1))[3])
index_desktop <- as.character(xml_attrs(xml_child(xml_child(visibility_desktop, 2), 1))[3])
index_tech_mobile <- as.character(xml_attrs(xml_child(xml_child(visibility_tech_mobile, 2), 1))[3])
index_tech_desktop <- as.character(xml_attrs(xml_child(xml_child(visibility_tech_desktop, 2), 1))[3])


# GOOGLE SHEETS

library(googlesheets)
library(googleAuthR)

# Create a token and store it on a rds file to be used recurrently.
# Uncomment next two lines to do so.
# my_token <- gs_auth(new_user = TRUE)
# saveRDS(my_token, "gs_my_token.rds")

# Call the token file (be careful of using the right path)
gs_auth(token = "gs_my_token.rds", new_user = FALSE)

# Select the proper Google Spreadsheet document
visibility_google_sheets <- gs_key("MY_SPREADSHEET_KEY")

# Fill a dummy first row on the spreadsheet as it requires a first row to add following ones. 
# After the first registry is inserted, feel free to delete it, as next rows will be added automatically.
# Create headers as Date, Desktop, Mobile, Tech - Desktop or Tech - Mobile (will be required on the ) 
gs_add_row(visibility_google_sheets, ws = "Visibility", input = c(date, as.numeric(index_desktop), as.numeric(index_mobile), as.numeric(index_tech_desktop), as.numeric(index_tech_mobile)))

visibility_sheet <- visibility_google_sheets %>% gs_read(ws = "Visibility") %>% filter(row_number() > (n()-2)) %>% mutate(Date = as.Date(Date, "%d/%m/%Y"))

difference <- ((visibility_sheet[2,2:5]-visibility_sheet[1,2:5])/visibility_sheet[1,2:5])*100


# SLACK

library(slackr)

# Work on your Slack environment first and make some tests before launching this script
slackr_setup()

# Compose strings for the different KPIs
date <- paste0("Sistrix Today: *",visibility_sheet$Date[2],"*")
desktop_general <- paste0("* ","Desktop: *",visibility_sheet$Desktop[2],"* - Daily Change: *",round(diferencia$Desktop,2),"%*")
mobile_general <- paste0("* ","Mobile: *",visibility_sheet$Mobile[2],"* - Daily Change: *",round(diferencia$Mobile,2),"%*")
desktop_tech <- paste0("* ","Desktop - Tech: *",visibility_sheet$`Tech - Desktop`[2],"* - Daily Change: *",round(diferencia$`Tech - Desktop`,2),"%*")
mobile_tech <- paste0("* ","Mobile - Tech: *",visibility_sheet$`Tech - Mobile`[2],"* - Daily Change: *",round(diferencia$`Tech - Mobile`,2),"%*")


# Paste all the strings on a single message and send it to any Slack channel (create the channel first)
slackr_msg(paste(date,desktop_general,mobile_general,desktop_tech,mobile_tech,sep="\n"), channel = "#sistrix")

# DON´T FORGET TO SCHEDULE THE EXECUTION OF THIS FILE IN ORDER TO RECEIVE AUTOMATED UPDATES
