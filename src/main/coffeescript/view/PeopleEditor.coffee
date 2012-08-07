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
Ext.define 'Addressbook.view.PeopleEditor',
  extend: 'Ext.panel.Panel'
  alias: 'widget.addressbook-PeopleEditor'
  requires: [ 'Ext.panel.Panel',
              'Addressbook.model.Person',
              'Addressbook.store.PersonStore',
              'Addressbook.controller.PeopleEditorViewController',
              'Addressbook.data.titles',
              'Addressbook.view.controls.Telephone'
  ]
  mixins: [ 'Deft.mixin.Controllable',
            'Deft.mixin.Injectable' ]
  inject: ['personStore']
  controller: 'Addressbook.controller.PeopleEditorViewController'

  layout:
    type: 'hbox'
    align: 'stretch'

  config:
    model: true
    isNew: false

  initComponent: ->
    me = this
    @setTitle(if @getModel().get('firstname') then @getModel().get('firstname') else 'New Person')
    Ext.applyIf( me,
      bodyPadding: 5
      items: [
        itemId: 'personForm'
        xtype: 'form'
        flex: 1
        defaultType: 'textfield'
        frame: true
        title: 'Person Editor'
        fieldDefaults:
          labelAlign: 'right'
          labelWidth: 100
          msgTarget: 'side'
          width: 450

        items: [
          xtype: 'combobox'
          fieldLabel: 'Title'
          name: 'title'
          queryMode: 'local'
          typeAhead: true
          emptyText: 'Select a title...'
          allowBlank: true
          forceSelection: false
          store: Ext.create('Ext.data.ArrayStore',
                            fields: ['val'],
                            data : Addressbook.data.titles
          )
          valueField: 'val'
          displayField: 'val'
        ,
          fieldLabel: 'First Name'
          name: 'firstname'
          allowBlank: false
        ,
          fieldLabel: 'Last Name'
          name: 'lastname'
        ,
          fieldLabel: 'Email'
          name: 'email'
          vtype: 'email'
        ,
          fieldLabel: 'Cell'
          xtype: 'telephone'
          name: 'cell'
        ,
          fieldLabel: 'Birthday'
          xtype: 'datefield'
          name: 'birth'
          maxValue: new Date()
          format: 'M-d-Y'
          altFormats: 'm-d-y, Y/m/d, m/d/y, m/d/Y'
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
          xtype: 'grid'
          itemId: 'associatedItemsGrid'
          title: 'Associated Items'
          padding: "5 0 0 0"
          flex: 3
          store: @getModel().places()
          viewConfig:
            emptyText: 'No linked locations'
            deferEmptyText: false
          columns:[
            height: 0
            flex: 1
            dataIndex: 'state'
            sortable: false
            renderer: (value, metaData, record) ->
              record.toHtmlString()
          ]
        ]
      ]
    )

    me.callParent( arguments )
