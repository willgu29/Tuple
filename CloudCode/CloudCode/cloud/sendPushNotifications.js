exports.sendPushNotification = function(inviter,timeToEat,diningHallInt, hostName, deviceToken, message, response)
{
	var query =  new Parse.Query(Parse.Installation);
	query.equalTo('deviceToken', deviceToken);
	Parse.Push.send({
		where: query,
		data: {
			alert: message,
			sound: "default",
			hostName: hostName,
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