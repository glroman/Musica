# Recordly

Music Database

Requirements
------------

Recordly will be an application that allows for users to input and store
their record collection.  When complete, the user should be able to view
their record collection, view a list of their "favorite" albums and/or
songs, etc.  Duplicate albums/songs should not be allowed.  They should
be able to "favorite" any of album/song/artist.

The site should have the following functionality:

    - User login
    - Search
    - Views:
        - Albums
          - Individual album view with songs
        - Artists
        - Songs
        - Favorites
            - Albums
            - Artists
            - Songs

Using any language or framework you prefer, please build an application
using testing and best practices.  Make the site have a mix of
traditional CGI forms with page refreshes, as well as at least one each
of an AJAX GET and POST (or some other modification type verb).

Please provide a link for the GitHub repository and deployed url for the
application so that we can see the various portions working.

Please use git as you would if you were working on this in a
professional environment.

STATUS -- 09 Feb 2016
---------------------

The following functionality has been written:

* Database schema (for entire application)
* User authentication
* New user registration
* Adding albums and corresponding artists
* Listing current albums and artists in the user's collection
* Detection of duplicate:
  * Logins
  * (Artist, Album) pairs already added to a user's collection
* Seed data to add two test users and an album to the database.

To test the current system, login as "guest/recordly" or register a new
user.

The following functionality still need to be written:

* Adding songs to an album
* Listing out the details for a single album
* Adding artists, albums, or songs as favorites
* Search through artists, albums, and songs
* Updating Arists, Albums, and Songs (to correct spelling errors)
* Test scripts to automate testing of user functionality


Components
----------

* Sqlite3
* Sequel
* Sinatra
* Slim
