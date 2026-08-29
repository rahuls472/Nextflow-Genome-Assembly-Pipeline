include {FASTQC} from "./modules/fastqc.nf"
include {FASTP} from "./modules/fastp_trim.nf"
include {SPADES} from "./modules/spades_assembly.nf"
include {QUAST} from "./modules/quast.nf"
include {BUSCO} from "./modules/busco.nf"
include {REFASTQC} from "./modules/refastqc.nf"
params.output = "results"
params.busco_lineage = null


workflow {

    reads_ch = Channel.fromFilePairs(params.input)
    

    FASTQC(reads_ch)

    FASTP(reads_ch)

    REFASTQC(FASTP.out.trimmed_reads)

    SPADES(FASTP.out.trimmed_reads)

    QUAST(SPADES.out.contigs)

    BUSCO(SPADES.out.contigs)
}