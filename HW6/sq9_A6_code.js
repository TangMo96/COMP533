//1.1
db.foodInfo.findOne()

//1.2
db.foodInfo.find({"portion_display_name":"regular Oreo"}).pretty()

//1.3
db.foodInfo.find({"display_name":{$regex:/ice cream/i}, "calories":{$lt:200}}).pretty()

//1.4
db.truckEvent.find({"eventStart":{$lt:'2017-09-07'}}).sort({eventStart:-1}).limit(5).pretty()

//1.5
db.sale.find({"eventId":16}).length()

//1.6.a
db.truckEvent.update({"eventName":"Pi Day"},{$set:{"eventName":"Pie Day"}})

//1.6.b
db.truckEvent.find({"eventName":{$in:["Pi Day", "Pie Day"]}}).pretty()

//1.6.c
db.truckEvent.updateMany({"eventName":"GSA Coffee Break"}, {$set:{"eventName":"GSA Study Break"}})

//1.6.d
db.truckEvent.find({"eventName":{$in: ["GSA Study Break", "GSA Coffee Break"]}}).length()

//1.7.a
db.foodInfo.aggregate([ 
{$lookup: {from: "ingredient", localField: "display_name", foreignField: "ingName", as: "ingredient" } },
{$match: {category: {$regex:/topping/i} } },
{$project: {display_name: 1, portion_display_name: 1, calories: 1} },
{$out: "foodInfoTopping" }
]).pretty() 

//1.7.b
db.ingredient.aggregate([
{$match: {"category" : "topping"}},
{$lookup: {from: "foodInfoTopping", localField: "ingName", foreignField: "display_name", as: "ing"}},
{$unwind: "$ing"},
{$lookup: {from: "unit", localField: "ing.portion_display_name", foreignField: "unitName", as: "cal"}},
{$unwind: "$cal"},
{$project: {"ingId": 1, "ingName": 1, "ing.portion_display_name": 1, "ing.calories": 1, "cal.ounces": 1, "calPerOunce": {$divide: ["$ing.calories", "$cal.ounces"]}}},
{$sort: {"calPerOunce" : -1}},
{$limit: 3}]).pretty();

//2.1
//One advantage of embedding documents within other documents is that embedding documents provide great flexibility for database modeling. For example, in a blog application, there are blogs and comments. Every blog could have many comments. We could embedded comments into blog document, which is more consistent with object model.
//One disadvantage of embedding documents with other documents is that there exists limitation for size of a single documentation. Also, if we embedded huge amount comments into a single blog document, it will have bad influence over efficiency. When MongoDB update documents, it will put the whole document into memory. Therefore, it will be super slow in blog application since there could be huge amount of comments for a pop star’s blog.

//2.2
//We can think of embedded documents as hashes of dictionaries while arrays are a list of values.
//One advantage of using array instead of embedded document is that using array will be faster than using hash tables if you need to fetch most of the elements in the collection.
//One disadvantage of using array rather than embedded document is that embedded documents have named fields, and can embed other documents for rich data representation, and this provide convenience when we want to filter out target information by using a projection. In array, it will be more complex to do such kind of operations.

