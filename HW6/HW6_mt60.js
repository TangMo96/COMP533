//1.1
db.foodInfo.findOne();
//1.2
db.foodInfo.find({"portion_display_name": "regular Oreo"}).pretty
//1.3
db.foodInfo.find({"display_name":{$regex:/ice cream/i},"calories":{$lt:200}}).pretty();
//1.4
db.truckEvent.find({"eventStart":{$lt:'2017-09-07'}}).sort({eventStart:-1}).limit(5).pretty()
//1.5
db.sale.find({"eventId":16}).length()
//1.6(a)
db.truckEvent.update({"eventName":"Pi Day"},{$set:{"eventName":"Pie Day"}})
//1.6(b)
db.truckEvent.find({"eventName":{$in:["Pi Day", "Pie Day"]}}).pretty()
//1.6(c)
db.truckEvent.updateMany({"eventName":"GSA Coffee Break"}, {$set:{"eventName":"GSA Study Break"}})
//1.6(d)
db.truckEvent.find({"eventName":{$in: ["GSA Study Break", "GSA Coffee Break"]}}).length()
//1.7(a)
db.foodInfo.aggregate([ {$match:{"category": {$regex:/topping/i}}}, {$project: {_id : 0, "display_name":1, "portion_display_name": 1, "calories":1}}, {$out: "foodInfoToppings"}]);
//1.7(b)
db.ingredient.aggregate([
{$match: {"category" : "topping"}},{$lookup: {from: "foodInfoTopping", localField: "ingName", foreignField: "display_name", as: "ing"}},
{$unwind: "$ing"},{$lookup: {from: "unit", localField: "ing.portion_display_name", foreignField: "unitName", as: "cal"}},
{$unwind: "$cal"},{$project: {"ingId": 1, "ingName": 1, "ing.portion_display_name": 1, "ing.calories": 1, "cal.ounces": 1, "calPerOunce": {$divide: ["$ing.calories", "$cal.ounces"]}}},
{$sort: {"calPerOunce" : -1}},{$limit: 3}]).pretty();
//2.1
//advantage: Can easily get aim documents because of name field; Easy for management
//disadvantage:Cost of memory; The order of embedded documents is fixed.
//2.2
//advantage: With array we can have more operations like $in and others.
//disadvantage: With embedded documents, we can easily get aim document. While with array we should know the index otherwise we have to search.