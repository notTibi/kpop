up:
	docker-compose up -d

run:
	docker exec -it kpop-postgres-1 /bin/bash

dbrun:
	docker exec -it kpop-postgres-1 psql -U postgres

down:
	docker-compose down
