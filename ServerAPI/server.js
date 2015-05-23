var app = require('express')(),
	server = require('http').Server(app),
	io = require('sockiet.io')(server);

var port = process.env.PORT || 3000
app.listen(port);
console.log("Listening on port " + port);


app.get('/', function (req, res) {
	res.sendfile(__dirname + "/index.html");
});

io.on('connection', function (socket) {
	socket.emit('news', {hello : 'world'});
	socket.on('my other event', function (data){
		console.log(data);
	});
});