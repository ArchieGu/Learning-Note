# Type of Data, Database, and Workloads

## Types of Data

### Structured Data

Follows a predefined schema; often in a tabular form

Typical examples:

1. CRM and ERP systems
2. Administrative systems

Tabular:

- Data is organized in tables
- A table contains records
- Records conform to a schema
- Tables have a primary key (unique identify a record)
- Tables can have foreign keys (form relations between tables)

### Unstructured Data

No predefined structure; no notion of fields, labels or types

Typical examples:

1. Videos
2. Images
3. Audio files

Much harder to automatically process; Often processed using Machine Learning Techniques to generate more structured data.

### Semi-structured Data

Is not necessarily tabular in nature; yet has an observable structure

Typical examples:

1. Log files
2. Data export / import formats (XML, CSV)

Has an observable structure and can be processed by computer, but no schema; Is not tabular in nature; Shape of data can change over time

## Databases

### Relational Databases

Used for storing structured data in tables

Are created and queried using the ***Structured Query Language (SQL)***

SQL is a declarative language (Don't need to write instructions on how to execute a query)

Have a schema that describes all tables,fields, field types, and relations between tables.

Examples: Microsoft SQL Server, MySQL (open source and free), PostgreSQL (open source and free)

### Non-relational Databases

Data is stored in *collections* or *containers*

Don't follow a predefined schema

Different types available:

- Document database
- Wide-column store
- Key-value store
- Graph database

Example: Redis (High performance, in-memory database; Often used for caching); Cassandra (Free, open-source, wide-column store, Highly distributed); Azure CosmosDB (Globally distributed, multi-model database)

## Workloads

### Transactional

Support high volumes of read and writes to support information systems like CRMs, tracking software or record keeping.

High volume of record-keeping transactions (OLTP)

Transaction； unsplittable set of updates; Adheres to the ACID properties

### Analytical 

Support queries for getting insights or an overview over large amounts of data for KPIs, analysis, reports and business intelligence.

Lower volume of read-only queries

Batch-based (warehousing) or streaming data (OLAP)
