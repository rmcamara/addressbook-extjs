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
Ext.define( 'Addressbook.controller.PlaceEditorViewController',
  extend: 'Addressbook.controller.BaseViewController'
  requires: [ 'Addressbook.config.AddressbookEventMap',
              'Addressbook.controller.BaseViewController',
              'Addressbook.util.MessageBus' ]
  mixins: [ 'Deft.mixin.Injectable' ]
  inject: [ 'appConfig' ,'messageBus', 'placesStore']

  control:
    placeForm: true
    currentDetailsPanel: true
    saveBtn:
      click: 'onSave'

  config:
    view: null
    messageBus: null
    isNew: false

  init: ->
    model = @getView().getModel()
    @setIsNew(@getView().getIsNew())
    if !@getView().getIsNew()
      @getForm().loadRecord(model)
      # Ext.global.console.log(model.toHtmlString())
      @getCurrentDetailsPanel().update('<pre>'+model.toHtmlString()+ '</pre>')

    @callParent( arguments )

  onSave: () ->
    model = @getView().getModel()
    if !@getForm().isValid()
      return

    @getForm().updateRecord(model)
    if @getIsNew()
      @placesStore.add(model)
      @placesStore.sync(
        success: =>
          @getMessageBus().fireEvent(@getEventMap().OPEN_EDITOR_PLACE, @getView().getModel())
          @getView().destroy()
      )

    else
      @placesStore.sync(
        success: =>
          @getCurrentDetailsPanel().update('<pre>'+model.toHtmlString()+ '</pre>')
          @getView().setTitle(model.get('name'))
      );


  getForm: () ->
    @getPlaceForm().getForm()
)