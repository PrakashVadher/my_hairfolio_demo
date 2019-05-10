# Hairfolio API

This application provides web and API access to the [Hairfolio](https://api.hairfolio.tech) architecture.

## Installation

Install dependencies for the application. Instructions below are for OSX via homebrew:

```console
$ brew install postgresql
$ brew services start postgresql
$ brew install puma/puma/puma-dev
$ sudo puma-dev -setup
$ puma-dev -install
$ cd ~/.puma-dev && ln -s ~/hairfolio
```

And then configure the application environment from the project directory:

```console
$ cp config/secrets.example.yml config/secrets.yml
$ cp config/application.example.yml config/application.yml
```

And then execute:

```console
$ bundle
$ rake db:setup
```

## Testing

```console
$ spring spec
```

## Usage

The application will be spawned by puma dev and made available at [http://hairfolio.dev](http://hairfolio.dev).

### Restarting

Puma dev currently has a quirk of requiring a touch and remove for restarting the server:

```console
$ touch tmp/restart.txt && rm tmp/restart.txt
```

## Deployment

The app is hosted on Heroku at [http://hairfolio-prod.herokuapp.com](http://hairfolio-prod.herokuapp.com):

```console
git push heroku master
```
