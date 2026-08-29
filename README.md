# 🧬 Genome Assembly Pipeline

A modular **Nextflow DSL2 pipeline** for performing **de novo genome assembly** from paired-end FASTQ sequencing data.

The pipeline performs:

1. Quality control using **FastQC**
2. Read trimming and filtering using **fastp**
3. Genome assembly using **SPAdes**
4. Assembly quality assessment using **QUAST**
5. Genome completeness assessment using **BUSCO**

The pipeline uses Docker containers, so users do not need to manually install each bioinformatics tool.

---

## 🚀 Pipeline Workflow

```text
Paired-End FASTQ Files
          │
          ▼
       FASTQC
          │
          ▼
       fastp --> REFASTQC
          
          │
          ▼
       SPAdes
          │
          ├──────────────► QUAST
          │
          └──────────────► BUSCO
```

## ⚙️ Requirements

Before running the pipeline, install:

- Java
- Nextflow
- Docker

### Install Nextflow

You can install Nextflow using:

```bash
curl -s https://get.nextflow.io | bash
```

Move it to a location in your PATH if required:

```bash
sudo mv nextflow /usr/local/bin/
```

Check the installation:

```bash
nextflow -version
```

### Install Docker

Follow the Docker installation instructions for your operating system.

After installation, verify Docker:

```bash
docker --version
```

Test Docker:

```bash
docker run hello-world
```

## 📥 Clone the Repository

Clone this repository:

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
```

Move into the project directory:

```bash
cd Genome_assembly
```

## 🧬 Input Data

The pipeline accepts paired-end FASTQ files.

Your reads should follow a naming pattern similar to:

```text
sample_1.fastq
sample_2.fastq
```

or:

```text
sample_R1.fastq
sample_R2.fastq
```

Example:

```text
Data/raw_reads/
├── SRR2589044_1.fastq
└── SRR2589044_2.fastq
```

The pipeline dynamically accepts the input location using the `--input` parameter.

You do not need to permanently store sequencing data inside the pipeline repository. You can provide reads from any directory.

## ▶️ Running the Pipeline

Example:

```bash
nextflow run main.nf \
  --input '/path/to/reads/*_{1,2}.fastq' \
  --output '/path/to/output' \
  --busco_lineage bacteria_odb10
```

Example using the current directory structure:

```bash
nextflow run main.nf \
  --input 'Data/raw_reads/*_{1,2}.fastq' \
  --output '/home/user/Documents/assembly_result' \
  --busco_lineage bacteria_odb10
```

## 📌 Pipeline Parameters

### `--input`

Specifies the location of paired-end FASTQ files.

Example:

```text
--input 'Data/raw_reads/*_{1,2}.fastq'
```

Nextflow automatically groups:

```text
sample_1.fastq
sample_2.fastq
```

as one paired-end sample.

### `--output`

Specifies where the final results will be saved.

Example:

```text
--output '/home/user/Documents/assembly_result'
```

You can choose any output directory.

Example:

```text
--output results
```

or:

```text
--output /home/user/Desktop/genome_results
```

### `--busco_lineage`

Specifies the BUSCO lineage dataset used to evaluate genome completeness.

Example:

```text
--busco_lineage bacteria_odb10
```

| Genome type | Lineage dataset |
|---|---|
| Bacterial genomes | `bacteria_odb10` |
| Fungal genomes | `fungi_odb10` |
| Eukaryotic genomes | `eukaryota_odb10` |
| Vertebrate genomes | `vertebrata_odb10` |
| Insect genomes | `insecta_odb10` |

You must provide a valid BUSCO lineage dataset.

❌ Incorrect example:

```text
--busco_lineage bacteria0db10
```

The above is incorrect because the lineage name uses `0db` instead of `_odb`.

✅ Correct example:

```text
--busco_lineage bacteria_odb10
```

### Finding Available BUSCO Lineages

You can check available BUSCO lineage datasets using:

```bash
busco --list-datasets
```

Since this pipeline uses Docker, BUSCO datasets may also be downloaded automatically when required.

You can find more information about BUSCO datasets in the official BUSCO documentation.

## 🧪 Example Command

For bacterial paired-end sequencing reads:

```bash
nextflow run main.nf \
  --input 'Data/raw_reads/*_{1,2}.fastq' \
  --output '/home/user/Documents/assembly_results' \
  --busco_lineage bacteria_odb10
```

## 📁 Pipeline Modules

The pipeline is organized into separate Nextflow modules.

```text
Genome_assembly/
│
├── main.nf
├── nextflow.config
│
├── modules/
│   ├── fastqc.nf
│   ├── fastp.nf
│   ├── spades.nf
│   ├── quast.nf
│   └── busco.nf
│
├── Data/
│   └── raw_reads/
│
└── results/
```

## 🔬 Pipeline Steps

### Step 1: FastQC

FastQC performs quality control on the raw sequencing reads.

It provides information about:

- Per base sequence quality
- GC content
- Sequence duplication levels
- Adapter contamination
- Overrepresented sequences

### Step 2: fastp

fastp performs quality filtering and trimming of sequencing reads.

The trimmed reads are used for genome assembly.

### Step 3: SPAdes

SPAdes performs de novo genome assembly.

The cleaned paired-end reads are assembled into contigs.

Important output:

```text
contigs.fasta
```

### Step 4: QUAST

QUAST evaluates the quality of the assembled genome.

It provides metrics such as:

- Number of contigs
- Total assembly length
- Largest contig
- N50
- GC content

### Step 5: BUSCO

BUSCO evaluates genome completeness using conserved single-copy orthologs.

BUSCO categorizes genes into:

- Complete BUSCOs
- Complete and Single-Copy BUSCOs
- Complete and Duplicated BUSCOs
- Fragmented BUSCOs
- Missing BUSCOs

A typical BUSCO result looks like:

```text
C:98.5%
S:97.0%
D:1.5%
F:0.8%
M:0.7%
```

Where:

- **C** = Complete BUSCO genes
- **S** = Single-copy BUSCO genes
- **D** = Duplicated BUSCO genes
- **F** = Fragmented BUSCO genes
- **M** = Missing BUSCO genes

Higher completeness generally indicates a better genome assembly.

## 📊 Output Structure

The results will be published to the directory provided using `--output`.

Example:

```text
assembly_results/
│
├── fastqc/
│
├── fastp/
│
├── spades/
│   └── contigs.fasta
│
├── quast/
│   └── report.html
│
└── busco/
    └── BUSCO_results/
```

The exact output structure may vary depending on the pipeline configuration.

## 🧬 Running Multiple Samples

The pipeline supports multiple paired-end samples.

Example:

```text
reads/
├── sample1_1.fastq
├── sample1_2.fastq
├── sample2_1.fastq
├── sample2_2.fastq
```

Run:

```bash
nextflow run main.nf \
  --input 'reads/*_{1,2}.fastq' \
  --output '/home/user/Documents/results' \
  --busco_lineage bacteria_odb10
```

Nextflow will automatically process the samples.

## 🔄 Resume a Failed Pipeline

If the pipeline stops because of an error, you can resume it after fixing the problem.

Use:

```bash
nextflow run main.nf \
  --input 'Data/raw_reads/*_{1,2}.fastq' \
  --output '/home/user/Documents/assembly_results' \
  --busco_lineage bacteria_odb10 \
  -resume
```

Nextflow will reuse previously completed processes instead of running everything again.

## 🐳 Docker Containers

The pipeline uses Docker containers for reproducibility.

Tools are executed inside containers, including:

- FastQC
- fastp
- SPAdes
- QUAST
- BUSCO

This means users do not need to install these bioinformatics tools manually.

## ⚠️ Important Notes

Make sure your paired-end files follow the expected naming pattern.

For example:

```text
sample_1.fastq
sample_2.fastq
```

or:

```text
sample_R1.fastq
sample_R2.fastq
```

Always provide a valid BUSCO lineage:

```text
--busco_lineage bacteria_odb10
```

Do not use:

```text
bacteria0db10
```

because it is not a valid BUSCO lineage name.

> **Note:** Before committing, make sure your actual BUSCO version supports `bacteria_odb10`. An error like `bacteria0db10` being invalid is a naming typo, but BUSCO dataset availability can also depend on the BUSCO version/container being used.

## 👨‍💻 Author

**Rahul Kumar Singh**

Bioinformatics | NGS Analysis | Nextflow | Docker | Genomics

## 📄 License

This project is intended for educational and research purposes.
