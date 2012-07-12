###*
* Application configuration class, including endpoint lookup and runtime setting for mock vs. live data access.
###
Ext.define( 'Addressbook.config.AppConfig',

  statics:
    MOCK_DATA_ENV: 'mockdata'
    PRODUCTION_ENV: 'production'
    PACKAGE: 'Addressbook'

  config:
    environment: null
    username: null
    password: null

    # Specify data endpoints for a mock data environment. If no match found, attempt to use the defaults.
    mockdata:
      endpoints:
        authentication:
          url: 'data/authentication.json'
        placesRequestRead:
          url: 'data/places/read.json'
        placesRequestCreate:
          url: 'data/places/create.json'
        placesRequestUpdate:
          url: 'data/places/update.json'
        placesRequestDestroy:
          url: 'data/places/destroy.json'
      defaults:
        urlPrefix: 'data/'
        urlSuffix: '.json'
        dataRoot: ''

    # Specify data endpoints for production environment. If no match found, attempt to use the defaults.
    production:
      endpoints:
        authentication:
          url: 'services/login.php'
        placesRequestRead:
          url: 'services/places/read.php'
        placesRequestCreate:
          url: 'services/places/create.php'
        placesRequestUpdate:
          url: 'services/places/update.php'
        placesRequestDestroy:
          url: 'services/places/destroy.php'
      defaults:
        urlPrefix: 'services/'
        urlSuffix: '.json'
        dataRoot: ''


  constructor: ( cfg ) ->
    if cfg?.environment and Addressbook.config.AppConfig?[ cfg.environment ]
      @setEnvironment( Addressbook.config.AppConfig[ cfg.environment ] )
    else
      @setEnvironment( Addressbook.config.AppConfig.PRODUCTION_ENV )


  ###*
  * Given an endpoint name, returns the URL and root JSON data element for that endpoint.
  * @param {string} Endpoint name
  * @return {Object} Object with keys [url] and [root]
  ###
  getEndpoint: ( endpointName ) ->
    environmentConfig = @[ @getEnvironment() ]
    endpoints = environmentConfig.endpoints
    defaults = environmentConfig.defaults

    if endpoints?[ endpointName ]
      result =
        url: endpoints[ endpointName ].url
        root: endpoints[ endpointName ]?.root ? defaults.dataRoot
    else
      result =
        url: defaults.urlPrefix + endpointName + defaults.urlSuffix
        root: defaults.dataRoot
)