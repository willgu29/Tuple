
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var PushNotifications = require('cloud/sendPushNotifications.js');

Parse.Cloud.define("hello", function(request, response) {
	if (request.params.deviceTokenArray){
		var deviceTokenArray = request.params.deviceTokenArray;
		var arrayLength = deviceTokenArray.length;
		var hostUsername = request.params.hostUsername;
		var event = request.params.event;
		var eventTime = request.params.eventTime;
		var eventLocation = request.params.eventLocation;
		var inviter = request.params.inviter;
		//var messageString = inviter + " would like to eat at " + timeToEat;
		var messageString = "You've received a new event invite!";
		for (var i = 0; i < arrayLength; i++)
		{
			PushNotifications.sendPushNotification(inviter, event, eventLocation, eventTime ,hostUsername,deviceTokenArray[i], messageString, {
				success: function(){

				},
				error: function(error){
					response.error(error);
				}
			});
		}
		response.success();
	}
});
