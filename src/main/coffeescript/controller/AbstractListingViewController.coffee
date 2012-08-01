#    
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
#
Ext.define( 'Addressbook.controller.AbstractListingViewController',
  extend: 'Addressbook.controller.BaseViewController'
  requires: [ 'Addressbook.config.AddressbookEventMap',
              'Addressbook.controller.BaseViewController',
              'Addressbook.util.MessageBus']
  mixins: [ 'Deft.mixin.Injectable' ]
  inject: [ 'appConfig' ,'messageBus']

  control:
    view: true
    grid:
      itemdblclick: 'openEditor'
    filterTxt:
      change: 'updateFilter'
    refreshBtn:
      click: 'onRefresh'
    addPlaceBtn:
      click: 'onAddPlace'
    addPersonBtn:
      click: 'onAddPerson'
    changeModeBtn:
      click: 'switchDisplayMode'

  config:
    listingStore: true
    filterFields: true

  init: ->
    @callParent( arguments )

  onRefresh: (button) ->
    @getView().setLoading( 'Loading data from server' )
    @listingStore.load(
      scope: this
      callback: (records, operation, store) ->
        @getView().setLoading(false)
    )

  updateFilter: (control, value) ->
    @listingStore.filterByKeyword(value, @getFilterFields())
    if Ext.isDefined(Ext.global.console)
      Ext.global.console.log('Applying filter:' + value)

  switchDisplayMode: (button) ->

  openEditor: (view, record) ->

  onAddPlace: ->
    @openPlaceEditor(null)

  onAddPerson: ->
    @openPersonEditor(null)

  openPlaceEditor: (record) ->
    @getMessageBus().fireEvent(@getEventMap().OPEN_EDITOR_PLACE, record)

  openPersonEditor: (record) ->
    @getMessageBus().fireEvent(@getEventMap().OPEN_EDITOR_PERSON, record)
)