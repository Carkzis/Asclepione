# Asclepione
An app to keep track of the nation's vaccination uptake!

# Description
This is an app that obtains vaccination data from the Coronavirus Open Data API (APIv1) (link in acknowledgments), stores it in a local database on the device and displays it to the user. Currently, it displays the third vaccinations doses taken in a day, the cumulative third vaccination doses taken within a week and the vaccination uptake percentage of the third dose, all within England.  At the time of writing (14 April 2021), this was the latest dose widely available to the population; the fourth dose is only available to older and vulnerable people.  In future, the data for the rest of the UK could be displayed, as well as showing data by first, second and third dose, as well as future doses as they become more widely available.

## Dependencies
* Xcode 13.1 or higher.
* iOS 15.0 or higher.

## Installing
* You can download the code from the Asclepione repository by clicking "Code", then "Download ZIP".
* You can then install this from within Xcode onto an emulator or a mobile device (iOS 15.0 or higher) via the play button in the top right-hand corner.

## Executing the program
* You can run the app off a suitable emulator/mobile device.
* On opening the app, it will automatically attempt to obtain vaccination data from the Coronavirus Open Data API (APIv1).
* Before any data has been obtained, there will be placeholder items displayed ("???" for both country and date, and a zero value for the vaccination data itself), as shown below.

    <img src="https://github.com/Carkzis/Asclepione/blob/main/Screenshots/asclepione_awaiting_data.png?raw=true" width="300" />	
    
* On successfully obtaining data from the REST API, it will be stored in a local database, and the latest item will be displayed on the screen.
* You can click the "Refresh data?" button, will will reattempt obtaining data from the REST API.

    <img src="https://github.com/Carkzis/Asclepione/blob/main/Screenshots/asclepione_screenshot.png?raw=true" width="300" />

## Authors
Marc Jowett (carkzis.apps@gmail.com)

## Version History
* 1.0
  * Initial Release.  See [commits](https://github.com/Carkzis/Asclepione/commits/main).

## Acknowledgements
* Coronavirus Open Data API (APIv1) (https://api.coronavirus.data.gov.uk/v1/data) for providing the data.
* NHS, for all the amazing work them have done for us.
