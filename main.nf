include {FASTQC} from "./modules/fastqc.nf"
include {FASTP} from "./modules/fastp_trim.nf"
include {SPADES} from "./modules/spades_assembly.nf"
include {QUAST} from "./modules/quast.nf"
include {BUSCO} from "./modules/busco.nf"




workflow {

    reads_ch = Channel.fromFilePairs(params.raw_reads)

    FASTQC(reads_ch)

    FASTP(reads_ch)

    SPADES(FASTP.out.trimmed_reads)

    QUAST(SPADES.out.contigs)

    BUSCO(SPADES.out.contigs)
}