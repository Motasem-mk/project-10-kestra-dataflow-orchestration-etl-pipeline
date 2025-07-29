# 🍷 BottleNeck ETL Pipeline – Kestra Project

This project implements a production-grade, automated ETL workflow for **BottleNeck**, a premium wine distributor. The ETL is built using [Kestra](https://kestra.io), and it orchestrates tasks from ingesting raw Excel files to producing cleaned analytics, premium wine detection, and S3 data exports.

---

## 🚀 Project Context

BottleNeck collects monthly sales, ERP, and mapping data from various systems in Excel format. The objective of this project is to:

- ✅ Automate the ingestion, cleaning, and merging of ERP, Web, and Liaison datasets
- ✅ Compute per-product revenues and identify premium wines using statistical models
- ✅ Export results to Excel and CSV formats
- ✅ Upload final reports to Amazon S3
- ✅ Add robust error handling and monitoring

---

## 🧠 Problem Statement

The current manual processing of sales data is time-consuming and error-prone. Key issues include:

- ❌ Duplicate records in ERP and Web datasets  
- ❌ No automation for merging, revenue aggregation, or premium flagging  
- ❌ No pipeline to extract and report results  
- ❌ No alerting or dead-letter capture on pipeline failure  

---

## ⚙️ Tech Stack & Tools

| Component        | Tool                        |
|------------------|-----------------------------|
| Orchestration    | [Kestra](https://kestra.io) |
| Data Processing  | DuckDB, Python (Pandas)     |
| Storage          | Amazon S3                   |
| Notification     | SendGrid (email alerts)     |
| Containerization | Docker, Docker Compose      |

---

## 🗺️ ETL Pipeline Topology (Mermaid Diagram)

```mermaid
graph TD
    A[Trigger: Monthly cron] --> B[Download Excel files from S3]
    B --> C[Clean & dedupe ERP (DuckDB)]
    B --> D[Clean & dedupe Web (DuckDB)]
    B --> E[Clean & dedupe Liaison (DuckDB)]
    C --> F[ERP row count test]
    D --> G[Web row count test]
    E --> H[Liaison row count test]
    F --> I[Merge datasets (DuckDB)]
    G --> I
    H --> I
    I --> J[Compute revenue column]
    J --> K[Aggregate revenue by product]
    K --> L[Export to Excel with summary]
    J --> M[Flag premium wines (z-score)]
    M --> N[Extract premium wines]
    M --> O[Extract ordinary wines]
    L --> P[Upload to S3]
    N --> P
    O --> P
    P --> Q[✔ Done]

    subgraph ERROR HANDLING
        R[Failure: any task]
        R --> S[Save execution context to S3]
        R --> T[Send SendGrid email alert]
    end

    style Q fill:#b5f7a4,stroke:#333,stroke-width:2px
    style R fill:#fdd,stroke:#f66,stroke-width:2px
```

---

## 📦 Output Artifacts

| File Name                     | Description                           |
|------------------------------|----------------------------------------|
| `revenue_per_product.xlsx`   | Excel report with product & summary    |
| `premium_wines.csv`          | List of premium (vintage) wines        |
| `ordinary_wines.csv`         | Remaining wines                        |
| `merged_with_revenue.csv`    | Cleaned, enriched source data          |

All files are exported to an **S3 bucket** under the `extracts/` prefix.

---

## 🛡 Error Handling

This project includes a robust two-layer error-handling system:

1. **Dead Letter S3 Logging**  
   - On failure, the full `execution` context is saved to `s3://my-kestra-bucket/dead-letter/...`

2. **SendGrid Email Alert**  
   - An email is sent to the administrator with the flow ID, execution ID, and failure timestamp.

> These ensure quick diagnostics and pipeline observability in case of failure.

---

## 🧪 Data Validations

- ERP cleaned row count must be **825**
- Web cleaned row count must be **714**
- Liaison cleaned row count must be **825**
- Premium wines must equal **30** entries (`z-score > 2`)
- Total revenue must equal exactly **€70,568.60**

---

## ▶️ How to Run

1. Make sure you are in the `bottleneck/` folder.
2. Build the Python Docker image:

```bash
docker build -t kestra-python-deps:latest -f Dockerfile .
```

3. Launch the services:

```bash
docker compose up -d
```

4. Go to [http://localhost:8080](http://localhost:8080)
5. Import the flow (`p10_kestra_dataflow_orchestration_pipeline`) from the UI or API.
6. Click "Run Flow" to trigger it manually or wait for the monthly cron trigger.

---

## 👤 Maintainer

**Motasem Abualqumboz**  
📧 motasemmkamz@gmail.com

---

## 📁 Project Structure

```
bottleneck/
├── docker-compose.yml
├── Dockerfile
├── application.yml
├── erp.xlsx
├── web.xlsx
├── liaison.xlsx
└── README.md
```

---

## 📜 License

MIT License – Use freely, improve openly.