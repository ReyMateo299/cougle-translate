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
| `scripts/` | Remote-state bootstrap (`bootstrap-state.sh`) and secret scanning (`check-secrets.sh`) |
| `data/` | EMEA dataset download and preprocessing (raw data lives in S3, not git) |
| `models/translation/` | NLLB-200 translation |
| `models/ner/` | NER entity tagging and preservation guardrail |
| `models/confidence/` | Confidence-tier scoring and human-review routing |
| `evaluation/` | Translation quality and hallucination evaluation |
| `notebooks/` | Exploration |
| `tests/` | pytest suite (`pytest` from the repo root) |
| `.github/workflows/ci.yml` | CI: Terraform fmt/validate, secret scan, pytest |

All resource names are prefixed with `cougle-translate` (`var.project`).

## Getting started

Prerequisites: Terraform >= 1.5, AWS CLI v2 configured for `us-east-1` (`aws sts get-caller-identity` should succeed), Docker, Python 3.11+, and `awslocal` (`pip install awscli-local`) for LocalStack.

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
pytest
```

```bash
# Validate the modules locally against LocalStack (free)
make local-validate

# One-time per AWS account: create the remote-state bucket and lock table
bash scripts/bootstrap-state.sh

# Deploy to AWS
cd infrastructure/environments/dev
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when you're done working. SageMaker endpoints and Studio kernels bill by the hour. Run `bash scripts/check-secrets.sh` before pushing.
