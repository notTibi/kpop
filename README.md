# kpop

## start and restore 

```sh
docker compose up -d
docker exec -it kpop-postgres-1 /bin/bash
psql -U postgres -f /shared/users.sql
psql -U postgres -f /shared/base.sql
```

## dump and finish

```sh
docker exec -it kpop-postgres-1 /bin/bash
pg_dump -U postgres -f /shared/base.sql
exit
docker compose down -v
```

## help

pgAdmin starts at: http://localhost:5001
postgres docs: https://www.postgresql.org/docs/18/index.html

## report

[Link to the report which contains all information about the database.](./raport-bd-pp-tb.pdf)

## todo

- [x] write some sql template for addings everything and for more complex structures use transactions
- [x] some more views?
    - [x] artist view with songs from band when the artist was a part of it
    - [x] band view with albums and songs 
- [x] some more constraints
    - [x] check for negative intervals (tracks and albums)
    - [x] release date (tracks and albums) needs to be after band creation date and/or artist birth (triggers)
    - [x] death after born !
    - [x] joined before left in band members
    - [x] track_nums > 0 in album tracks
    - [x] track num unique for album id
    - [x] not empty title of song or album (not null, not like '', ' ', '\n')
- [x] more users
    - [x] guest, only view
    - [x] editor, has access to functions which we defined.
- [x] insert some data
- [x] add procedures and roles which can only access database using these procedures
