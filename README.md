[![Gem Version](https://badge.fury.io/rb/adncv.svg)](http://badge.fury.io/rb/adncv)

# ADNCV

Statistics from your App.net data.

1. [Download](https://account.app.net/settings/content/) your ADN data **before 2017/03/14**.

2. Install: 

`gem install adncv`

3. Run the Gem on the downloaded file:

`adncv -d /path/to/appdotnet-data-you-xxxxx-posts.json`

## Commands

### Display

`adncv -d posts.json`

Displays informations.

Add `-f` for full details (posted links, mentioned users, posts per month, etc):

`adncv -d -f posts.json`

### Export

`adncv -e posts.json`

Exports informations as a JSON file, including full details.

Add `-p` to specify the destination folder path (default: ~):

`adncv -e posts.json -p ~/Documents`

## Content

ADNCV will display/export:

- total posts
- posts without mentions
- posts directed to a user
- posts containing mentions but not directed
- posts containing mentions and are replies
- posts containing mentions and are not replies
- posts containing links
- times your posts have been reposted
- times your posts have been starred
- times your posts have been replied
- list of users you've posted directly to
- list of users you've mentioned
- list of clients you've posted with
- all your posted links
- your monthly posting frequency
