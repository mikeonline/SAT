FiresDB = new (Mongo.Collection)('Fires')
if Meteor.isClient
  Template.map.onCreated ->
    GoogleMaps.ready 'map', (map) ->
      google.maps.event.addListener map.instance, 'click', (event) ->
        if Meteor.isCordova
        else
        FiresDB.insert
          lat: event.latLng.lat()
          lng: event.latLng.lng()
        new google.maps.InfoWindow({
          content: "BLA"
        }).open(map,marker)
        return
      FiresDB.find().observe
        added: (document) ->
          marker = new (google.maps.Marker)(
            draggable: not Meteor.isCordova
            animation: google.maps.Animation.DROP
            position: new (google.maps.LatLng)(document.lat, document.lng)
            map: map.instance
            id: document._id)
          google.maps.event.addListener marker, 'dragend', (event) ->
            FiresDB.update marker.id, $set:
              lat: event.latLng.lat()
              lng: event.latLng.lng()
            return
          FiresDB[document._id] = marker
          return
        changed: (newDocument, oldDocument) ->
          FiresDB[newDocument._id].setPosition
            lat: newDocument.lat
            lng: newDocument.lng
          return
        removed: (oldDocument) ->
          FiresDB[oldDocument._id].setMap null
          google.maps.event.clearInstanceListeners FiresDB[oldDocument._id]
          delete FiresDB[oldDocument._id]
          return
      return
    return
  Meteor.startup ->
    GoogleMaps.load()
    return
  Template.map.helpers mapOptions: ->
    if GoogleMaps.loaded()
      MyLocation = {
        lat : "-33.833",
        lng : "117.159"
      }
      if navigator.geolocation.getCurrentPosition is not null
        MyLocation = Geolocation.latLng
      return {
      center: new (google.maps.LatLng)(MyLocation.lat, MyLocation.lng)
      zoom: 14
      }
  return