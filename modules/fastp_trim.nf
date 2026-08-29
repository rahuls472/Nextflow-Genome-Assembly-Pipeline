#!/usr/bin/env nextflow

process FASTP {
    container "biocontainers/fastp:v0.19.6dfsg-1-deb_cv1"
    publishDir "${params.output}/fastp", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_trimmed_R1.fastq.gz"), path("${sample_id}_trimmed_R2.fastq.gz"), emit: trimmed_reads
    path("${sample_id}_fastp.html"), emit: html_report
    path("${sample_id}_fastp.json"), emit: json_report

    script:
    """
    fastp \\
        -i ${reads[0]} \\
        -I ${reads[1]} \\
        -o ${sample_id}_trimmed_R1.fastq.gz \\
        -O ${sample_id}_trimmed_R2.fastq.gz \\
        -h ${sample_id}_fastp.html \\
        -j ${sample_id}_fastp.json \\
        --thread ${task.cpus}
    """
}