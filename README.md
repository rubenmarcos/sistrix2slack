# sistrix2slack
Make SEO information from Sistrix available to your teams on Slack on a quick and easy way.

## - Main goal:
One of the main goals as an analyst is to keep your teams updated on results and new developments. One of the most common requests from my colleages is (literally) "I would like to be updated at the beginning of the day on what happened yesterday". So you, as an analyst, create a nice Excel report and place it on a daily folder, automate a dashboard or send a daily e-mail at the beginning of the day. 

The results: After an initial shock of amaze, in a few days the Excel report is ignored, someone forget about the nice dashboard or -in the worst case scenario- the same person who requested the information on a daily e-mail ask for not receiveing it again as it's interfering with other mails on my e-mail box.

On this scenario, I found Slack as a great tool for automating and sending basic information to different members in the company. The analyst can create an specific channel -so no interfering with e-mails-, decide which person in the organisation has access to it and automate a selected amount of information to be distributed every day. As it's a common communication tool in the company it's available anytime without visiting an specific folder and the fact of having it handy means it's not easily forgotten as some of those wonderful DataStudio dashboards you may create.

In this example, we combine R, GoogleSheets, the Sistrix API and Slack in order to provide SEO and marketing departments daily updated information on a specific Slack channel.   

## - Potential uses:

The main use of this tool is saving time to all the people in the company working with Sistrix visibility data and be able to be the first raising flags in case of big changes on rankings forced by updates on Google. Instead of spending the first 30 minutes of the day checking manually indexes on the site, the SEO and the analysts can acceed the basic data (global, directory specific or competitors) and the daily changes on a specific channel.

Apart from that an historical record is kept on a Google Spreadsheets document, making it a great source for creating historical evolution dashboards. 

## - Requirements:
- R.
- Packages: tidyverse, httr, xml2, googlesheets, googleAuthR, slackr.
- API key from Sistrix and available API quota.
- Google Spreadsheet for storing historical data.

## - How does it work?:
- Get your API key from Sistrix, look at the instructions and create some URLs in order to make available the data you need (can use the browser as a test area for the URLs).
- Create a Google Spreadsheets document and name the main tab with a recognisable title (you will use it on the script).
- Install slackr, configure your environment (https://cran.r-project.org/web/packages/slackr/slackr.pdf) and make some tests before launching the script.
- Create a private channel on Slack for this data -you can also send it to other existing channels, but I warn you... at some point someone will complain of getting too many messages- and provide access to the users you consider will require this information.
