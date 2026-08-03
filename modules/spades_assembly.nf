process SPADES {

    cpus 4

    container "biocontainers/spades:v3.13.0dfsg2-2-deb_cv1"
    publishDir "results/spades_results", mode: "copy"

    input:
    tuple val(sample_id), path(r1), path(r2)

    output:
    tuple val(sample_id), path("${sample_id}_spades/contigs.fasta"), emit: contigs

   script:
    """
    spades.py \
        -1 ${r1} \
        -2 ${r2} \
        -o ${sample_id}_spades \
        -t ${task.cpus}
    """
}