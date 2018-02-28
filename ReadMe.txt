On the navigation panel there're 3 buttons:

	+: to add a new feed item
	X: to "delete" the first item
	O: to update the first' item content

All of this is done by sending new data from the respective JSON files to Firebase Database.

"ADD" operation will create a new feed item always with the same content but different ID (it'll be +1).
"DELETE" operation, since by definition it's not happening, will replace the content of the feed item with type "DELETE" and for the visuals some other fields as well.
"UPDATE" operation, also will replace the content of the feed item.

The app is responding to APS notifications. In real life I would assume the server responsible for updating the data will also issue a notification when needed. For the sake of testing you could send a new notification with the following command:

curl -H "Content-Type: application/json" \
     -H "Authorization: Bearer BEE12294BE82A3D54AA235B26BFDD0E" \
     -X POST "https://52df483e-a134-4da2-a2cd-46cfed83ac67.pushnotifications.pusher.com/publish_api/v1/instances/52df483e-a134-4da2-a2cd-46cfed83ac67/publishes" \
     -d '{"interests":["HubrickApp"],"apns":{"aps":{"alert":{"title":"","body":"New content is available"}}}}'

And please let me know if everything is working fine here since I don't have second device to test with.

The app is working perfectly on the simulator but not the push nopification part. For that, I've created a TestFlight build (lease let me know if you've received an invitation).
