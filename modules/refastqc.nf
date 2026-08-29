#!/usr/bin/env nextflow

process REFASTQC {
    container "biocontainers/fastqc:v0.11.9_cv8"
    publishDir "${params.output}/Refastqc_reports", mode: "copy"

    input:
    tuple val(sample), path(read1), path(read2)

    output:
    path "*.html", emit: html
    path "*.zip",  emit: zip

    script:
    """
    fastqc -o . -t ${task.cpus} ${read1} ${read2}
    """
}