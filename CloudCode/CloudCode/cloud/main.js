
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var PushNotifications = require('cloud/sendPushNotifications.js');

Parse.Cloud.define("hello", function(request, response) {
	if (request.params.deviceTokenArray){
		var deviceTokenArray = request.params.deviceTokenArray;
		var arrayLength = deviceTokenArray.length;
		var hostUsername = request.params.hostUsername;
		var timeToEat = request.params.timeToEat;
		var diningHall = request.params.diningHall;
		var inviter = request.params.inviter;
		var messageString = inviter + " would like to eat at " + timeToEat;
		for (var i = 0; i < arrayLength; i++)
		{
			PushNotifications.sendPushNotification(inviter, timeToEat,diningHall,hostUsername,deviceTokenArray[i], messageString, {
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
