# CRM DB Cleaner
**TLDR;** I want to clean my CRM Database, especially the duplicate entries on the email_conversation table.

## Description
This simple application is merely just find duplicate entries when testing the database functionality for my other project. The steps are as simply as:
1. Find the entities that duplicated (email_trace_id as the key).
2. Find the associated Ids of the duplicated email_trace_id for the email_conversation database, and save one for future exclusion.
3. Delete all duplicated entries except with the ids that has been saved earlier in the step 2.

## Caveat
This is my first and only attempt to try zig, expect some sloppy implementation since this is just experimental.

## Versions
- Zig **version 0.11.0**.
- PostgreSql **version 15 >**.

## Depencies
- [pgz](https://github.com/star-tek-mb/pgz) : Postgres driver written in pure zig

> **Note:** Since **Zig** build system (version 0.11.0) requires **tar.gz**, I clone then tag it to publish the `"temporary version"` that I can pull for my dependency.

## How to run
```sh
zig-build
zig-out/bin/crmdb-cleaner
```
