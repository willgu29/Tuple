exports.sendPushNotification = function(inMinutesInt,diningHallInt, hostName, deviceToken, message, response)
{
	var query =  new Parse.Query(Parse.Installation);
	query.equalTo('deviceToken', deviceToken);
	Parse.Push.send({
		where: query,
		data: {
			alert: message,
			sound: "default",
			hostName: hostName,
			inMinutes: inMinutesInt,
			diningHall : diningHallInt
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