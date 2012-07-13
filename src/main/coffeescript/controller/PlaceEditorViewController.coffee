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
    deleteBtn:
      click: 'onDelete'

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
    @getView().setLoading("Saving...")
    if @getIsNew()
      @placesStore.add(model)
      @placesStore.sync(
        callback: =>
          @getView().setLoading(false)
        success: (batch)=>
          newModel = batch.operations[0].records[0]
          @getMessageBus().fireEvent(@getEventMap().OPEN_EDITOR_PLACE, newModel)
          @getView().destroy()
      )

    else
      @placesStore.sync(
        callback: =>
          @getView().setLoading(false)
        success: =>
          @getCurrentDetailsPanel().update('<pre>'+model.toHtmlString()+ '</pre>')
          @getView().setTitle(model.get('name'))
      );

  onDelete: () ->
    Ext.Msg.show(
      title: 'Confirm Delete'
      msg: 'Are you sure you wish to delete this record?'
      buttons: Ext.Msg.YES | Ext.Msg.CANCEL
      fn: @confirmDelete
      scope: @
    )

  confirmDelete: (buttonId) ->
    if (buttonId == 'yes')
      if @getIsNew()
        @getView().destroy()
      else
        @getView().setLoading("Deleting...")
        @placesStore.remove(@getView().getModel())
        @placesStore.sync(
          callback: =>
            @getView().setLoading(false)
          success: =>
            @getView().destroy()
        )

  getForm: () ->
    @getPlaceForm().getForm()
)