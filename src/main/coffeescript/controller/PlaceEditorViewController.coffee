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
  requires: [
    'Addressbook.config.AddressbookEventMap'
    'Addressbook.controller.BaseViewController'
    'Addressbook.util.MessageBus'
    'Addressbook.view.PeopleLinkWindow'
  ]
  mixins: [ 'Deft.mixin.Injectable' ]
  inject: [ 'appConfig' ,'messageBus', 'placesStore']

  control:
    placeForm: true
    currentDetailsPanel: true
    associatedItemsGrid: true
    saveBtn:
      click: 'onSave'
    deleteBtn:
      click: 'onDelete'
    linkBtn:
      click: 'onLink'


  config:
    view: null
    messageBus: null
    isNew: false
    model: null

  init: ->
    @setModel(@getView().getModel())
    @setIsNew(@getView().getIsNew())
    if !@getView().getIsNew()
      @reload()

    @callParent( arguments )

  onSave: () ->
    if !@getForm().isValid()
      return

    @getView().setLoading("Saving...")
    if @getIsNew()
      model = @getView().getModel()
      @getForm().updateRecord(model)
      @placesStore.add(model)
      @placesStore.sync(
        callback: =>
          @setModel(model)
          @reload()
          @getView().setLoading(false)

        success: (batch)=>
          newModel = batch.operations[0].records[0]
          @getMessageBus().fireEvent(@getEventMap().OPEN_EDITOR_PLACE, newModel)
          @getView().destroy()
      )

    else
      model = @placesStore.getById(@getView().getModel().getId())
      @getForm().updateRecord(model)
      @placesStore.sync(
        callback: =>
          @getView().setLoading(false)
        success: =>
          @setModel(model)
          @reload()

      );

  onDelete: () ->
    Ext.Msg.show(
      title: 'Confirm Delete'
      msg: 'Are you sure you wish to delete this record?'
      buttons: Ext.Msg.YES | Ext.Msg.CANCEL
      fn: @confirmDelete
      scope: @
    )

  onLink: () ->
    linkPopup = Ext.create('Addressbook.view.PeopleLinkWindow',
      locationId: @getModel().getId()
    )
    linkPopup.on('beforedestroy', @refreshAssociated, @)
    linkPopup.show()

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

  reload: () ->
    model = @getModel();
    @getForm().loadRecord(model)
    @getCurrentDetailsPanel().update('<pre>'+model.toHtmlString()+ '</pre>')
    @getView().setTitle(model.get('name'))
    @getAssociatedItemsGrid().reconfigure(model.people())

  refreshAssociated: ->
    model = @getModel()
    @placesStore.load(
      scope: this
      callback: ->
        model = @placesStore.getById(@getView().getModel().getId())
        @getAssociatedItemsGrid().reconfigure(model.people())
    )
)