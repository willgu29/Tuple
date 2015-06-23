var http = require('http');
var express = require('express');
var bodyParser = require('body-parser');
var app = express()
var accountSid = "ACc4488413ed16d035be8301cf96bc5d82";
var authToken = "881191eec139458ae325a12a31d844e9";
var client = require('twilio')(accountSid, authToken);
var Parse = require('parse').Parse;

Parse.initialize("A5W56JpbUSdejJfl15K72x6OfAbUPpPZ2JHXq19c", "E8BVxD5rJicSrCBeEHmDJxv0nuvq35Np3qlH8Lai");

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
	extended: true
}));

app.get('/twilio/sms/', function(req, res) {
	console.log("hi");
});

app.post('/twilio/sms/', function(req,res) {
	if (req.body.Body) {
		//Reply back (via text)
		var numberFormatted = req.body.From;
		var numberContact = numberFormatted.slice(1);
		console.log("Text received from: ", numberContact);
		var query = new Parse.Query("Event");
		if (req.body.Body == "Yes") {
		  console.log("Yes");
		
		  query.find({
		    success: function (events) {
		      var singleEvent = events[events.length-1];
		      singleEvent.addUnique("usersGoing", numberContact);
		      singleEvent.addUnique("usersResponded", numberContact);
		      singleEvent.save(null, {
			success: function(eventObject) {

			}, 
			error: function(eventObject, error) {

			}
		      });
		    }
	
		  });
		} else if (req.body.Body == "No") {
		  console.log("No");
	   	  query.find({
		    success: function (events) {
		      var singleEvent = events[events.length-1];
		      singleEvent.addUnique("usersResponded", numberContact);
		      singleEvent.save(null, {
			success: function(eventObject) {

			},
			error: function(eventObject, error) {

			}
		      });
		    }
		  });
		} else if (req.body.Body == "Status") {
		  console.log("Status");
		  query.find({
		    success: function(events) {
		      var singleEvent = events[events.length-1];
		      var peopleAttending = singleEvent.get("usersGoing");
		      var messageBack = "# people going: " + peopleAttending.length;
		      client.messages.create({
			body: messageBack,
		        to: numberFormatted,
		        from: "+15089288753",
		
		      }, function (err, message) {
			console.log("Error: ", err);
		      });
		    }
		  });
		}
		res.json({received: "yup"});
	} else if (req.body.message) {
	
		console.log(JSON.stringify(req.body));
		var sendTo = "+"+req.body.number;
		var message = req.body.message;
		var additionalInfo = " Text back Yes or No to accept or decline the invitation. Text Status to get the number of people currently attending. When in doubt, text your friend for more details! (or get an iPhone..)"
		client.messages.create({
			body: message,
			to: sendTo,
			from: "+15089288753"
		}, function (err, message) {
			console.log("Error: " + JSON.stringify(err));
			console.log("Message: " + JSON.stringify(message));		
		});
		res.json({received: "yes"});
	}
});

app.listen(3120);
