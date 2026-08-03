process BUSCO {

    cpus 4
    memory '6 GB'

    container "staphb/busco:latest"

    publishDir "results/busco_results", mode: "copy"

    input:
    tuple val(sample_id), path(contigs)

    output:
    path("${sample_id}_busco"), emit: report

    script:
    """
    busco \
        -i ${contigs} \
        -o ${sample_id}_busco \
        -m genome \
        -l ${params.busco_lineage} \
        --cpu ${task.cpus}
    """
}