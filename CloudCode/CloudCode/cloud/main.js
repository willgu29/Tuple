
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
var PushNotifications = require('cloud/sendPushNotifications.js');

Parse.Cloud.define("hello", function(request, response) {
	if (request.params.deviceTokenArray){
		var deviceTokenArray = request.params.deviceTokenArray;
		var arrayLength = deviceTokenArray.length;
		var hostName = request.params.hostName;
		var inMinutes = request.params.inMinutes;
		var diningHall = request.params.diningHall;
		var messageString = request.params.hostName + " would like to eat in "+ request.params.inMinutes +" minutes!";
		for (var i = 0; i < arrayLength; i++)
		{
			PushNotifications.sendPushNotification(inMinutes,diningHall,hostName,deviceTokenArray[i], messageString, {
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
