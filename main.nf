include {FASTQC} from "./modules/fastqc.nf"
include {FASTP} from "./modules/fastp_trim.nf"
include {SPADES} from "./modules/spades_assembly.nf"
include {QUAST} from "./modules/quast.nf"
include {BUSCO} from "./modules/busco.nf"
include {REFASTQC} from "./modules/refastqc.nf"
params.output = "results"
params.busco_lineage = null


workflow {
    if (!params.input) {
        error """Please provide input reads using the --input parameter.
        Example: nextflow run main.nf --input 'Data/raw_reads/*_{1,2}.fastq'"""
    }

    reads_ch = Channel.fromFilePairs(params.input).
        map { sample_id, reads -> tuple(sample_id, reads) }

    if (size(reads_ch) == 1) {
        error "Please provide paur-end reads for each sample. Single-end reads are not supported."
    }
    

    FASTQC(reads_ch)

    FASTP(reads_ch)

    REFASTQC(FASTP.out.trimmed_reads)

    SPADES(FASTP.out.trimmed_reads)

    QUAST(SPADES.out.contigs)

    BUSCO(SPADES.out.contigs)
}