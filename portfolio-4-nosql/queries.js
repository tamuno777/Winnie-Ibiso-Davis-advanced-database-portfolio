// Find Tech books
{ "category": "Tech" }

// Books with 2 or more copies
{ "copies_available": { "$gte": 2 } }

// Books with a 5-star review (nested field)
{ "reviews.rating": 5 }

// Out of stock books
{ "copies_available": 0 }

// Aggregation: books and copies per category
[ { $group: { _id: "$category", total_books: { $sum: 1 }, total_copies: { $sum: "$copies_available" } } } ]