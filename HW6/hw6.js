//Quesion 1
db.foodInfo.findOne();

//Question 2
db.foodInfo.find({portion_display_name : "regular Oreo"}).pretty();

//Question 3
db.foodInfo.find({calories: {$lt:200},display_name:{$regex:/ice cream/i}}).pretty();

//Question 4
db.truckEvent.find({eventStart: {$lt: "2017-09-07 00:00:00"}}).sort({eventStart: -1}).limit(5).pretty();

//Question 5
db.sale.find({eventId : 16}).length();

//Question 6
//(a)
db.truckEvent.updateMany({"eventName" : "Pi Day"}, {"$set" : {"eventName" : "Pie Day"}});
//(b)
db.truckEvent.find({ eventName: { $in : ["Pi Day","Pie Day"]}}).pretty();
//(c)
db.truckEvent.updateMany({eventName : "GSA Coffee Break"}, {"$set" : {"eventName" : "GSA Study Break"}});
// 4 records  updated: 
//{ "acknowledged" : true, "matchedCount" : 4, "modifiedCount" : 4 }

//(d)
db.truckEvent.find({ eventName: { $in : ["GSA Coffee Break","GSA Study Break"]}}).length();
// 6 documents found


//Question 7
//(a)
db.foodInfo.aggregate([ {$match:{"category": {$regex:/topping/i}}}, {$project: {_id : 0, "display_name":1, "portion_display_name": 1, "calories":1}}, {$out: "foodInfoToppings"}]);


//(b)
db.foodInfoToppings.aggregate([{$lookup:{from: "ingredient", localField: "display_name", foreignField: "ingName", as: "ingredientInfo"}},{$match:{"ingredientInfo.category": {$regex:/topping/i}}},{$project: {"ingredientInfo":1,"portion_display_name":1,"calories": 1}},{$out: "tmp1"}]);

db.tmp1.aggregate([{$unwind: "$ingredientInfo"},{$project: {"ingredientInfo._id":1, "ingredientInfo.ingName" : 1, "calories":1, "portion_display_name":1}}, {$out: "tmp2"}]);
 
db.tmp2.aggregate([{$lookup:{from: "unit", localField: "portion_display_name", foreignField: "unitName", as: "ouncesInfo"}},{$match:{"ouncesInfo.0.ounces": {$ne : 0.0}}}, {$out: "tmp3"}]);

db.tmp3.aggregate([{$unwind: { path: "$ouncesInfo", includeArrayIndex: "arrayIndex"}}, {$group: { _id: '$ouncesInfo._id', "ingId":{"$first" : "$ingredientInfo._id"}, "ingName":{"$first" : "$ingredientInfo.ingName"},"portion_display_name": {"$first": "$portion_display_name"} ,"calories": { "$first": "$calories"}, ouncesInfo: { $addToSet: '$ouncesInfo.ounces' } } },{$out: "finalResult"}]);

db.tmp4.aggregate([ {$project: { "ingId": 1, "ingName":1, "portion_display_name" : 1,"calories":1, ounces: { $arrayElemAt: [ "$ouncesInfo", 0 ] }}}, {$out: "resultSet"}]);

db.resultSet.aggregate([ {$project: { _id: 1, "ingId": 1, "ingName":1, "portion_display_name" : 1,"calories":1, "ounces": 1, "calPerOunce" : {$divide : ["$calories", "$ounces"]}}}, {$out: "finalResult"}]);

db.finalResult.find({}, {"ingId":1}).sort({_id:1}).forEach(function(doc){db.finalResult.remove({_id:{$gt:doc._id}, ingId:doc.ingId});}); // delete duplicates

db.finalResult.find({},{_id:0}).sort({"calPerOunce": -1}).limit(3).pretty(); // print all result 


// Short Answer
// 1. Advantage:  Embedded documents has named field, it can directly access those fields easily by using dot.
//    Disadvantage: You can't sort those embedded elements, and its order is limited to the insertion order.

// 2. Advantage: It supports more much operations like $in and easy to operate than embedded documents.
//    Disadvantage: If you dont' know the index of the element in array, it will cost more time to search
//                  the matched element then do the updating. While the embedded document has direct acess to that element.




