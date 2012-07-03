###
#    Copyright 2012 Ross Camara
#
#    This file is part of Addressbook.
#
#    Addressbook is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    AddressBook is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with addressbook.  If not, see <http://www.gnu.org/licenses/>.
###
Ext.define 'Addressbook.view.PlaceListingPanel',
  extend: 'Ext.panel.Panel'
  alias: 'widget.addressbook-PlaceListingPanel'
  requires: [ 'Ext.panel.Panel',
              'Ext.grid.Panel',
              'Addressbook.model.Place',
              'Addressbook.store.PlacesStore']
  mixins: [ 'Deft.mixin.Controllable', 'Deft.mixin.Injectable' ]
  inject: ['placesStore']

  layout: 'anchor'
  autoScroll: true

  initComponent: ->
    me = this
    Ext.applyIf( me,
      dockedITems:{
        itemId: 'toolbar'
        dock: 'top'
        height: 34
        layout:
          pack: 'start'
      }
      items: [
        itemId: 'grid'
        anchor: '100%, 100%'
        xtype: 'grid'
        store: @placesStore
        viewConfig:
          emptyText: 'No places defined'
          deferEmptyText: false
        columnLines: true
        columns:[
          header: 'Location Name'
          flex: 2
          maxWidth: 225
          dataIndex: 'name'
        ,
          header: 'City'
          flex: 1
          maxWidth: 120
          dataIndex: 'city'
        ,
          header: 'State'
          width: 50
          dataIndex: 'state'
        ,
          header: 'Zipcode'
          width: 65
          dataIndex: 'zipcode'
          renderer: (value) ->
            Ext.util.Format.leftPad(value, 5, '0')
        ,
          header: 'Details'
          flex: 3
          dataIndex: 'details'
        ]
      ]
    )

    me.callParent( arguments )
