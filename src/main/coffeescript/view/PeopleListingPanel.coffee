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
Ext.define 'Addressbook.view.PeopleListingPanel',
  extend: 'Ext.panel.Panel'
  alias: 'widget.addressbook-PeopleListingPanel'
  requires: [
    'Ext.panel.Panel'
    'Ext.grid.Panel'
    'Ext.ux.RowExpander'
    'Addressbook.model.Person'
    'Addressbook.store.PersonStore'
    'Addressbook.controller.PeopleListingViewController'
    'Addressbook.view.controls.AssociatedRowExpander'
    'Ext.grid.column.Date'
  ]
  mixins: [ 'Deft.mixin.Controllable', 'Deft.mixin.Injectable' ]
  inject: ['personStore']
  controller: 'Addressbook.controller.PeopleListingViewController'

  layout: 'anchor'
  autoScroll: true

  initComponent: ->
    me = this
    Ext.applyIf( me,
      items: [
        itemId: 'grid'
        anchor: '100%, 100%'
        xtype: 'grid'
        store: @personStore
        viewConfig:
          emptyText: 'No people defined'
          deferEmptyText: false
        columnLines: true
        plugins: [
          ptype: 'assocrowexpander'
          rowBodyTpl: [
            '<div class="assocrow-people">'
            '<tpl for="places">'
            '<b>&mdash;</b> <i>{name} </i><br/>'
            '</tpl>'
            '</div>'
          ]
        ]
        columns:[
          header: 'First Name'
          flex: 2
          maxWidth: 225
          dataIndex: 'firstname'
        ,
          header: 'Last Name'
          flex: 2
          maxWidth: 225
          dataIndex: 'lastname'
        ,
          header: 'Title'
          flex: 1
          maxWidth: 60
          dataIndex: 'title'
        ,
          xtype: 'datecolumn'
          header: 'Birthday'
          flex: 1
          maxWidth: 150
          dataIndex: 'birth'
          renderer: Ext.util.Format.dateRenderer('M-d-Y')
        ,
          header: 'Details'
          flex: 3
          dataIndex: 'details'
        ]
        dockedItems:[
          xtype: 'toolbar'
          items:[
            'Filter:'
          ,
            itemId: 'filterTxt'
            text: 'filter'
            xtype: 'textfield'
            flex: 2
            maxWidth: 400
            emptyText: "Enter filter keywords..."
          ,
            xtype:'tbspacer'
            flex: 1
          ,
            itemId: 'changeModeBtn'
            text: 'Mode'
            tooltip: 'Switch to places view'
          ,
            itemId: 'refreshBtn'
            text: 'Refresh'
            tooltip: 'Refresh Records'
            icon: './resources/themes/images/default/grid/refresh.gif'
          ,
            xtype:'tbspacer'
            width: 20
          ,
            xtype: 'tbseparator'
          ,
            xtype:'tbspacer'
            width: 20
          ,
            itemId: 'editRecordBtn'
            text: 'Edit'
            icon: './resources/images/edit.png'
          ,
            itemId: 'addPersonBtn'
            text: 'Person'
            icon: './resources/images/addPerson.png'
          ,
            itemId: 'addPlaceBtn'
            text: 'Place'
            icon: './resources/images/addPlace.png'
          ]
        ]
      ]
    )

    me.callParent( arguments )
