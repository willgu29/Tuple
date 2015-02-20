exports.sendPushNotification = function(inviter,timeToEat,diningHallInt, hostUsername, deviceToken, message, response)
{
	var query =  new Parse.Query(Parse.Installation);
	query.equalTo('deviceToken', deviceToken);
	Parse.Push.send({
		where: query,
		data: {
			alert: message,
			sound: "default",
			hostUsername: hostUsername,
			inviter: inviter
		}
	}, {
		success: function(){
			//Push success!
			response.success();
		},
		error: function(error){
			//handle error
			response.error(error);
		}
	});
};