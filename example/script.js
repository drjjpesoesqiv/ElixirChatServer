var socket = new WebSocket("ws://localhost:8080/websocket", "chatserver");

document.addEventListener("DOMContentLoaded", function() {
  document.getElementById("msg_input").addEventListener('keydown', function(e) {
    if (e.keyCode === 13) {
      send(this.value);
      this.value = '';
    }
  });
});

function send(msg) {
  var msg = {
    action: "publish",
    msg: msg
  }
  socket.send(JSON.stringify(msg));
}

function identify() {
  //
}

socket.onmessage = function(e) {
  var msgs = document.getElementById('msgs');
  var json = JSON.parse(e.data);
  if (json.msg != undefined)
    msgs.innerHTML += `<span>${json.id}: ${json.msg}</span>`;
}