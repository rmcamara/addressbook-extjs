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
Ext.define( 'Addressbook.controller.PeopleEditorViewController',
  extend: 'Addressbook.controller.BaseViewController'
  requires: [
    'Addressbook.config.AddressbookEventMap'
    'Addressbook.controller.BaseViewController'
    'Addressbook.util.MessageBus'
    'Addressbook.view.LocationLinkWindow'
  ]
  mixins: [ 'Deft.mixin.Injectable' ]
  inject: [ 'appConfig' ,'messageBus', 'personStore']

  control:
    personForm: true
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
      @personStore.add(model)
      @personStore.sync(
        callback: =>
          @setModel(model)
          @reload()
          @getView().setLoading(false)

        success: (batch)=>
          newModel = batch.operations[0].records[0]
          @getMessageBus().fireEvent(@getEventMap().OPEN_EDITOR_PERSON, newModel)
          @getView().destroy()
      )

    else
      model = @personStore.getById(@getView().getModel().getId())
      @getForm().updateRecord(model)
      @personStore.sync(
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
    linkPopup = Ext.create('Addressbook.view.LocationLinkWindow',
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
        @personStore.remove(@getView().getModel())
        @personStore.sync(
          callback: =>
            @getView().setLoading(false)
          success: =>
            @getView().destroy()
        )

  getForm: () ->
    @getPersonForm().getForm()

  reload: () ->
    model = @getModel();
    @getForm().loadRecord(model)
    @getCurrentDetailsPanel().update('<pre>'+model.toHtmlString()+ '</pre>')
    @getView().setTitle(model.get('firstname') + ' ' + model.get('lastname'))
    @getAssociatedItemsGrid().reconfigure(model.places())

  refreshAssociated: ->
    model = @getModel()
    @personStore.load(
      scope: this
      callback: ->
        model = @personStore.getById(@getView().getModel().getId())
        @getAssociatedItemsGrid().reconfigure(model.places())
    )
)