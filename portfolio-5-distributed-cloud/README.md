# Distributed and Cloud Database Exercise

## Case Study

This exercise is based on the City University Library Management System used in my previous portfolio tasks. The system manages books, members, borrowing records and fines. For this part, I focused on how a cloud database can help make the library catalogue more available and reliable.

## Cloud Deployment

I used MongoDB Atlas to explore how the library catalogue could be hosted in the cloud. MongoDB Atlas provides a managed database service, meaning that some of the database infrastructure and maintenance are handled by the provider.

The deployment was intended to use the free tier on a cloud provider, with the region selected during cluster setup. The cluster configuration and connection test are documented in the screenshots, `screenshots/atlas-cluster.png` and `screenshots/db-hello.png`.

The aim was to understand how a database can run in a cloud environment instead of depending only on a database installed on a local computer.

## Replication

Replication means keeping copies of the same data on multiple database servers. In a MongoDB replica set, one server normally acts as the primary, while the other servers act as secondaries and copy changes from the primary.

The primary handles write operations, while the secondaries maintain copies of the data. If the primary becomes unavailable, the remaining eligible members can take part in electing a new primary. This process is called failover.

I used `db.hello()` to inspect the replica set information. The output showed the replica set name and the host information returned by the cluster. These details help confirm how the database is configured.

For the library, replication is useful because a problem affecting one server does not necessarily make the catalogue unavailable. However, this depends on the cluster configuration, the health of the remaining members and whether an election can take place successfully.

## Consistency

Consistency is important because the database should not confirm a write before the required level of acknowledgement has been reached.

I tested a write operation using `writeConcern: { w: "majority" }`. This setting requests acknowledgement after the write has been applied on the calculated majority of the replica set's voting members. I recorded the test in `screenshots/write-majority.png`.

Using majority write concern helps reduce the risk of a confirmed write being lost during certain failover situations. However, it can take longer than a write that requires acknowledgement from only the primary, especially when network delays occur.

For the library system, this is useful for information that should be stored reliably. The setting does not replace proper transaction design, but it provides an additional level of protection for database writes.

## Sharding Design

Sharding is a way of distributing data across multiple servers to support larger datasets and heavier workloads. I considered how it could be applied to the library database, although this part was only a design because the selected free-tier deployment did not provide the sharding setup needed for the exercise.

For the books collection, I considered using a hashed ISBN shard key. Hashing can help distribute documents more evenly across shards and can be useful when searching by a specific ISBN. However, range-based queries on ISBN may not benefit in the same way because hashed keys do not preserve the original ordering.

For the loans collection, I considered using `member_id` as the shard key. This could help with queries that retrieve loans for a particular member. However, the distribution of member IDs and the number of loans per member would need to be considered to avoid uneven workloads.

I would avoid using category as the only shard key because a library usually has a limited number of categories, and some categories may contain many more books than others. This could lead to uneven data distribution and make the design less effective.

Overall, the choice of shard key should depend on the queries the system runs most often, the amount of data and how evenly the workload can be distributed.

## Consistency Versus Availability

The balance between consistency and availability depends on what the user is trying to do.

For borrowing the last available copy of a book, I would prioritise consistency. The system must not allow two members to successfully borrow a single available copy. This relates to my earlier portfolio on transactions and row locking, where I explored how concurrent borrowing operations can cause problems.

For catalogue searches and reading book reviews, availability is more important. If a user wants to search for a book, it is useful for the catalogue to remain accessible even when part of the system experiences a problem. Depending on the replication and read settings, a secondary may be able to serve a read, although its data may not include the latest write.

This does not mean that availability is always more important for searches or that consistency is guaranteed simply by choosing a particular database. The actual behaviour depends on the database configuration and the operation being performed.

## Overall Architecture

For the proposed system, I would use PostgreSQL to manage members, loans and fines because these records depend on relationships and reliable transactions. MongoDB Atlas would be used for the book catalogue, where a document-based structure can provide flexibility for book details and related information.

This arrangement would allow each database to handle the tasks it is suited for. However, using two databases also introduces extra work, such as keeping related information synchronised and managing connections between the systems. The architecture would therefore need clear rules about which database is responsible for each type of data.

## Limitations

The main limitation of the free-tier deployment is that it has restrictions on storage, available resources and supported cluster features. The sharding section was therefore treated as a design rather than a working implementation.

Another limitation is that replication does not prevent every type of failure or replace backups. The system would still need proper monitoring, access controls and a backup plan to protect the library's records.

## Reflection

This exercise helped me understand how replication allows database servers to maintain copies of data and how failover can help a service continue running when a primary server becomes unavailable. I also learnt that majority write concern provides stronger acknowledgement requirements, although it can add some delay to writes.

The part I found a little confusing was understanding the difference between replication and sharding. I now understand that replication is mainly about maintaining copies of data, while sharding distributes data across multiple servers to handle larger workloads. Both can support a reliable database system, but they solve different problems.