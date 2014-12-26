# ADNCV

Statistics from your App.net data.

1. [Download](https://account.app.net/settings/content/) your ADN data

2. Install: 

`gem install adncv`

3. Run the Gem on the downloaded file:

```
adncv /path/to/appdotnet-data-you-xxxxx-posts.json
```  

## Commands

### Display

`adncv -d posts.json`

Displays informations.

### Export

`adncv -e posts.json`

Exports informations as a JSON file, including all your posted links and mentioned users.