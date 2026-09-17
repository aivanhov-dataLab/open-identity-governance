Keycloak
   │
   ▼
PostgreSQL
   │
   ▼
PersistentVolumeClaim
   │
   ▼
PersistentVolume

1. Create Realm
2. Create IAM roles
3. Create test users
4. Delete PostgreSQL pod
5. Kubernetes recreates PostgreSQL pod
6. PVC remains Bound
7. Keycloak data remains available