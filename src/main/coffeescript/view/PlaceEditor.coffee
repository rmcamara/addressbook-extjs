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
              'Addressbook.controller.PlaceEditorViewController']
  mixins: [ 'Deft.mixin.Controllable',
            'Deft.mixin.Injectable' ]
  inject: ['placesStore']
  controller: 'Addressbook.controller.PlaceEditorViewController'

  layout: 'anchor'
  config:
    model: true

  initComponent: ->
    me = this
    @setTitle(@getModel().get('name'))
    Ext.applyIf( me,
      items: [

      ]
    )

    me.callParent( arguments )
