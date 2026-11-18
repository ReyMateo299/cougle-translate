# COUGle Translate

**Zero-Hallucination Clinical Translation Engine** — CS 401R (Engineering the AI Enterprise) final project, deployed on AWS.

## Business problem

**Company:** Intermountain Health Care

When a patient is discharged, they leave with clinical instructions. If the patient speaks another language, those instructions are translated and reviewed by humans, which takes significant time and resources. We propose a trustworthy, zero-hallucination translation engine that automates most of this process.

We expect the techniques we use to prevent hallucinations here to carry over to other MLOps areas that have hallucination problems.

## AI approach

- **Translation model:** NLLB-200 (or a similar open-source model).
- **Named entity recognition (NER) guardrail:** tag clinically significant entities (medication names, doctor names, dosage amounts, etc.) and preserve them across translation, so the model cannot alter them.
- **Confidence tiers (under consideration):** a decision model (e.g. Jev) ranks each translation into a confidence tier, and low-confidence translations go to a human reviewer.

## Data

[EMEA dataset from OPUS](https://opus.nlpl.eu/datasets/EMEA): a free, trusted parallel corpus of medical documents.

## Why it's hard

Transformer-based translation models hallucinate, especially smaller models that haven't been fine-tuned. A hospital or clinic cannot use an unreliable translation model, because mistranslations have serious consequences. Clinics must also comply with strict regulations, and turning this automation into a product clinics can actually rely on is a serious challenge.

## Repo layout

| Path | Contents |
|------|----------|
| `infrastructure/` | Terraform modules (`vpc`, `storage`, `iam`, `sagemaker`) and the `dev` and `local` environments |
| `docker-compose.yml`, `Makefile` | LocalStack validation (`make local-validate`) |
| `scripts/` | Remote-state bootstrap, verification, and secret scanning |
| `aws-account-setup.md` | AWS account, tooling, and cost-control setup |

All resource names are prefixed with `cougle-translate` (`var.project`).
