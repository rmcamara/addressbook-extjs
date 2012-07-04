###*
* Mixin to dynamically filter a collection based on a search term and the property names to match against.
###
Ext.define( "Addressbook.util.Filterable",


  ###*
  * Filters a collection by keyword search term
  * @param {string} Keyword / Search term to match
  * @param {array} Array of property names to match with the keyword
  ###
  filterByKeyword: ( keyword, fieldNames ) ->
    regex = new RegExp( '^.*(?:' + keyword + ').*$', 'i' )
    @clearFilter()

    @filter(
      Ext.create( 'Ext.util.Filter',
        filterFn: ( thisModel ) =>
          match = false

          for propertyName in fieldNames
            if regex.test( String( thisModel.get( propertyName ) ) )
              match = true
              break

          return match
      )
    )

)