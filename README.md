# Open Identity Governance

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![Keycloak](https://img.shields.io/badge/Keycloak-4D4D4D?logo=keycloak&logoColor=white)
![OpenFGA](https://img.shields.io/badge/OpenFGA-Authorization-blue)
![OPA](https://img.shields.io/badge/OPA-Policy%20as%20Code-7B42BC)
![Falco](https://img.shields.io/badge/Falco-Runtime%20Security-00A98F)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC)

**A hands-on Kubernetes IAM and DevSecOps security lab combining identity, authorization, policy enforcement and runtime security.** — Identity (Keycloak), Authorization (RBAC + OpenFGA), Policy-as-Code (OPA), Runtime Security (Falco) and Observability (Prometheus/Grafana).

> Built to demonstrate hands-on IAM, Kubernetes security and DevSecOps engineering practices — not a proprietary product clone.

---

## Highlights

- Designed and tested a **least-privilege Kubernetes RBAC model** (Developer / Analyst / Administrator) with an automated test suite covering 15+ allow/deny scenarios
- Deploying **Keycloak** as a centralized OIDC identity provider, backed by PostgreSQL
- Architecture planned for **fine-grained authorization (OpenFGA)**, **policy enforcement (OPA/Gatekeeper)** and **runtime threat detection (Falco)**
- Infrastructure-as-code and CI/CD approach (Terraform, Jenkins) for reproducibility
- Git workflow with feature branches, small commits, and documentation delivered alongside each security layer

## Architecture

```text
Users → Keycloak (IAM/OIDC) → Kubernetes RBAC → Workloads
                                     │
                    ┌────────────────┼────────────────┐
                OpenFGA            OPA              Falco
          (fine-grained authz)  (policy)     (runtime detection)
                    └────────────────┴────────────────┘
                          Prometheus / Grafana
```

## Tech Stack

| Layer | Tools |
|---|---|
| Identity & Access | Keycloak, Kubernetes RBAC, OpenFGA, OPA/Gatekeeper |
| Security | Falco, least-privilege design, Kubernetes Secrets |
| Infrastructure | Kubernetes, Minikube, Docker, Terraform |
| CI/CD & Automation | Git, GitHub, Jenkins, Bash |
| Observability | Prometheus, Grafana, PostgreSQL |

## What's Implemented

**Kubernetes RBAC** — three roles enforcing least privilege (e.g. Developer/Analyst cannot read Secrets or create RoleBindings), validated by an automated test script:
```bash
./tests/rbac-test.sh
```
Design details: `docs/security/rbac-model.md`

**Identity Management** — Keycloak namespace, PostgreSQL backend and Kubernetes deployment in progress, preparing OIDC integration with cluster authorization.

## Roadmap

- [x] RBAC model + automated security tests
- [x] Keycloak/PostgreSQL foundation
- [ ] OIDC integration & identity-to-role mapping
- [ ] OpenFGA authorization model
- [ ] OPA/Gatekeeper policies
- [ ] Falco runtime security
- [ ] Prometheus/Grafana dashboards
- [ ] Terraform + Jenkins CI/CD

## Scope

Independent technical portfolio project. Some elements (e.g. the full-access Administrator role) are simplified for lab purposes; a production deployment would add hardened secrets management, network policies, audit logging and formal security review.

## Author

**Scève Aivanhov Nguetse** — Mechanical Engineer transitioning into Cloud Security / DevSecOps
Interests: IAM & Identity Governance, Kubernetes, Cybersecurity, Infrastructure as Code

[nguetseaivanhov@gmail.com]