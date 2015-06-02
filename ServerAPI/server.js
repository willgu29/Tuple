var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

//var nsp = io.of('/chatroom');

app.get('/*', function (req, res, next) {
	console.log("DIRECTORY + URL: ", __dirname, req.url);
	next();
});

app.get('/', function (req, res) {
	res.sendFile(__dirname + '/index.html');
});
app.get('/chatroom', function (req, res) {
	res.sendFile(__dirname + '/index.html');
});
io.on('connection', function(socket){
  console.log('a user connected');

  socket.on('chat message', function(msg){
    console.log('message: ' + msg);
    io.emit('chat message', msg);
  });

  socket.on('disconnect', function(){
    console.log('user disconnected');
  });
});


http.listen(3331, function(){
  console.log('listening on *:3331');
});
app.get('/jquery.js', function (req, res) {
	res.sendFile(__dirname + req.url);
});

app.get('/css/:cssFile', function (req, res) {
	console.log("CSS");
	res.sendFile(__dirname + req.url);
});
app.get('/js/:jsFile', function (req, res) {
	res.sendFile(__dirname + req.url);
});
app.get('/font-awesome/css/:fontPath', function (req, res) {
	res.sendFile(__dirname + req.url);
});
app.get('/font-awesome/fonts/:fontPath', function (req, res) {
	res.sendFile(__dirname + req.url);
});
app.get('/img/:imgName', function (req, res) {
	res.sendFile(__dirname + req.url);
});
