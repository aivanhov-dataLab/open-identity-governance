# Kubernetes RBAC Security Model

## 1. Overview

This document describes the Role-Based Access Control (RBAC) model implemented
in the `open-identity-governance` project.

The objective is to demonstrate how identity, authorization and least-privilege
principles can be implemented in a Kubernetes-based identity governance
environment.

The current implementation uses Kubernetes ServiceAccounts as identities and
Kubernetes RBAC Roles and ClusterRoles as authorization mechanisms.

---

## 2. Security Objectives

The RBAC implementation has the following objectives:

- Enforce least-privilege access.
- Separate responsibilities between users.
- Restrict access to sensitive Kubernetes resources.
- Prevent unauthorized privilege escalation.
- Isolate application workloads within a dedicated namespace.
- Provide a reproducible authorization model.
- Automate authorization testing.

---

## 3. Identity Model

The current laboratory environment uses Kubernetes ServiceAccounts to represent
three logical identities:

| Identity | ServiceAccount | Namespace |
|---|---|---|
| Developer | `developer` | `workloads` |
| Analyst | `analyst` | `workloads` |
| Administrator | `administrator` | `workloads` |

These identities are currently used to validate the authorization model.

In a later stage, Keycloak will provide the centralized identity and
authentication layer.

The architecture will then evolve toward:

```text
User
  |
  v
Keycloak
  |
  v
Authenticated Identity
  |
  v
Kubernetes Authorization
  |
  v
RBAC