
if Meteor.isClient
  Template.map.onCreated ->
    GoogleMaps.ready 'map', (map) ->
      google.maps.event.addListener map.instance, 'click', (event) ->
        Markers.insert
          lat: event.latLng.lat()
          lng: event.latLng.lng()
        return
      markers = {}
      Markers.find().observe
        added: (document) ->
          marker = new (google.maps.Marker)(
            draggable: true
            animation: google.maps.Animation.DROP
            position: new (google.maps.LatLng)(document.lat, document.lng)
            map: map.instance
            id: document._id)
          google.maps.event.addListener marker, 'dragend', (event) ->
            Markers.update marker.id, $set:
              lat: event.latLng.lat()
              lng: event.latLng.lng()
            return
          markers[document._id] = marker
          return
        changed: (newDocument, oldDocument) ->
          markers[newDocument._id].setPosition
            lat: newDocument.lat
            lng: newDocument.lng
          return
        removed: (oldDocument) ->
          markers[oldDocument._id].setMap null
          google.maps.event.clearInstanceListeners markers[oldDocument._id]
          delete markers[oldDocument._id]
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