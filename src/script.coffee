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
    apiKey = getApiKey()
    payload = makePayload(data_uri)
    makeRequest(apiKey, payload, data_uri)
    # document.getElementById('results').innerHTML =
        # '<h2>Here is your large image:</h2>' + '<img src="' + data_uri + '"/>'
    document.getElementById('results_table')

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

makeRequest = (apiKey, payload, data_uri) ->
  url = 'https://vision.googleapis.com/v1/images:annotate?key='+apiKey
  http = new XMLHttpRequest()
  http.open('POST', url, true)

  http.setRequestHeader('Content-Type', 'application/json')
  http.onreadystatechange = ->
    if (http.readyState == 4 && http.status == 200)
      console.log(http.responseText)
      receiveApiResponse(http.responseText, data_uri)

  http.send(JSON.stringify(payload))

receiveApiResponse = (responseText, data_uri) ->
  table = document.getElementById('results_table')
  row = document.createElement('div')
  row.className = "row"
  left = document.createElement('div')
  left.className = "col-md-6"
  img = document.createElement('img')
  img.setAttribute('src', data_uri)
  left.appendChild(img)
  right = document.createElement('div')
  right.className = "col-md-6"
  right.innerText = prettyPrint(responseText)
  row.appendChild(left)
  row.appendChild(right)
  table.insertBefore(row, table.firstChild)

prettyPrint = (responseText) ->
  response = JSON.parse(responseText)
  face = response["responses"][0]["faceAnnotations"][0]
  str = ""
  str += "Joy likelihood: " + face["joyLikelihood"] + "\n"
  str += "Sorrow Likelihood: " + face["sorrowLikelihood"] + "\n"
  str += "Anger Likelihood: " + face["angerLikelihood"] + "\n"
  str += "Surprise Likelihood: " + face["surpriseLikelihood"] + "\n"
  str += "Under-exposed Likelihood: " + face["underExposedLikelihood"] + "\n"
  str += "Blurred Likelihood: " + face["blurredLikelihood"] + "\n"
  str += "Headwear Likelihood: " + face["headwearLikelihood"] + "\n"
  return str

getApiKey = () ->
  window.apiKey ? document.getElementById("api_key").value
