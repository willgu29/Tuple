
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var PushNotifications = require('cloud/sendPushNotifications.js');

Parse.Cloud.define("hello", function(request, response) {
	if (request.params.deviceTokenArray){
		var deviceTokenArray = request.params.deviceTokenArray;
		var arrayLength = deviceTokenArray.length;
		var hostName = request.params.hostName;
		var timeToEat = request.params.timeToEat;
		var diningHall = request.params.diningHall;
		var inviter = request.params.inviter;
		var messageString = inviter + ": eat at" + timeToEat+ "?";
		for (var i = 0; i < arrayLength; i++)
		{
			PushNotifications.sendPushNotification(inviter, timeToEat,diningHall,hostName,deviceTokenArray[i], messageString, {
				success: function(){

				},
				error: function(error){
					response.error(error);
				}
			});
		}
		response.success();
	}
	response.error();
});
