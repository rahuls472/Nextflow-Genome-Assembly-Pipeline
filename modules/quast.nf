process QUAST {

    cpus 2

    container "staphb/quast:latest"

    publishDir "${params.output}/quast_results", mode: "copy"

    input:
    tuple val(sample_id), path(contigs)

    output:
    path("${sample_id}_quast"), emit: report

    script:
    """
    quast.py \
        ${contigs} \
        -o ${sample_id}_quast \
        --threads ${task.cpus}
    """
}