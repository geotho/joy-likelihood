Webcam.set
  width: 320
  height: 240
  dest_width: 320
  dest_height: 240
  image_format: 'jpeg'
  jpeg_quality: 90
Webcam.attach '#my_camera'

window.take_snapshot = ->
  Webcam.snap (data_uri) ->
    apiKey = window.apiKey
    payload = makePayload(data_uri)
    makeRequest(apiKey, payload)
    document.getElementById('results').innerHTML = '<h2>Here is your large image:</h2>' + '<img src="' + data_uri + '"/>'

makePayload = (dataUri) ->
  commaIdx = dataUri.indexOf(",")
  dataUri = dataUri.substring(commaIdx+1)
  payload =
    requests: [
      image:
        content: dataUri
      features: [
        type: "FACE_DETECTION"
        maxResults: 1
      ]
    ]

makeRequest = (apiKey, payload) ->
  url = "https://vision.googleapis.com/v1/images:annotate?key="+apiKey
  http = new XMLHttpRequest()
  http.open("POST", url, true)

  http.setRequestHeader("Content-Type", "application/json")
  http.onreadystatechange = ->
    if (http.readyState == 4 && http.status == 200)
      console.log(http.responseText)

  http.send(JSON.stringify(payload))
