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
Ext.define 'Addressbook.view.PlaceEditor',
  extend: 'Ext.panel.Panel'
  alias: 'widget.addressbook-PlaceEditor'
  requires: [ 'Ext.panel.Panel',
              'Addressbook.model.Place',
              'Addressbook.store.PlacesStore',
              'Addressbook.controller.PlaceEditorViewController',
              'Addressbook.data.states',
              'Addressbook.view.controls.Zipcode'
              'Addressbook.view.controls.Telephone'
  ]
  mixins: [ 'Deft.mixin.Controllable',
            'Deft.mixin.Injectable' ]
  inject: ['placesStore']
  controller: 'Addressbook.controller.PlaceEditorViewController'

  layout:
    type: 'hbox'
    align: 'stretch'

  config:
    model: true
    isNew: false

  initComponent: ->
    me = this
    @setTitle(if @getModel().get('name') then @getModel().get('name') else 'New Place')
    Ext.applyIf( me,
      bodyPadding: 5
      items: [
        itemId: 'placeForm'
        xtype: 'form'
        flex: 1
        defaultType: 'textfield'
        frame: true
        title: 'Places Editor'
        fieldDefaults:
          labelAlign: 'right'
          labelWidth: 100
          msgTarget: 'side'
          width: 450

        items: [
          fieldLabel: 'Location Name'
          name: 'name'
          allowBlank: false
        ,
          fieldLabel: 'Address'
          name: 'address'
          allowBlank: false
        ,
          fieldLabel: 'Address2'
          name: 'address2'
        ,
          fieldLabel: 'City'
          name: 'city'
        ,
          xtype: 'combobox'
          fieldLabel: 'State'
          name: 'state'
          store: Ext.create('Ext.data.ArrayStore',
            fields: ['abbr', 'state'],
            data : Addressbook.data.states
          )
          valueField: 'abbr'
          displayField: 'state'
          queryMode: 'local'
          typeAhead: true
          emptyText: 'Select a state...'
          allowBlank: false
          forceSelection: true
        ,
          xtype: 'zipcode'
          name: 'zipcode'
        ,
          xtype: 'telephone'
          fieldLabel: 'Phone'
          name: 'phone'
        ,
          xtype: 'textareafield'
          fieldLabel: 'Details'
          name: 'details'
          height: 200
        ]
        dockedItems:[
          xtype: 'toolbar'
          dock: 'bottom'
          layout:
            type: 'hbox'
            align: 'stretch'
            pack: 'end'
          items: [
            itemId: 'linkBtn'
            text: 'Link to...'
          ,
            itemId: 'deleteBtn'
            text: 'Delete'
          ,
          '->'
          ,
            itemId: 'saveBtn'
            text: 'Save'
            formBind: true
            disabled: true
          ]
        ]
      ,
        xtype: 'container'
        frame: false
        flex: 1
        padding: "0 0 0 10"
        layout:
          type: 'vbox'
          align: 'stretch'
        items:[
          xtype: 'panel'
          itemId: 'currentDetailsPanel'
          title: 'Current Details'
          padding: '0 0 5 0'
          flex: 2
          bodyPadding: '20'
        ,
          xtype: 'panel'
          title: 'Associated Items'
          padding: "5 0 0 0"
          flex: 3
        ]
      ]
    )

    me.callParent( arguments )
