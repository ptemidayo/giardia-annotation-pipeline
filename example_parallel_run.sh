#!/bin/bash
# Example: Parallel batch processing of Giardia genomes using GNU Parallel
# Place this script in the examples/ directory

# =============================================================================
# PARALLEL BATCH ANNOTATION SCRIPT
# =============================================================================
# This script demonstrates parallel processing of multiple genomes using
# GNU Parallel, which can significantly speed up annotation of many genomes.
#
# REQUIREMENTS:
#   - GNU Parallel (install: sudo apt-get install parallel)
#   - Sufficient CPU cores and RAM
#
# USAGE:
#   ./example_parallel_run.sh [max_jobs]
#
# Example:
#   ./example_parallel_run.sh 4    # Run 4 genomes simultaneously

set -e

# =============================================================================
# CONFIGURATION
# =============================================================================

# Maximum number of genomes to process in parallel
# Default: 2 (adjust based on your system resources)
MAX_JOBS="${1:-2}"

# Threads per genome (total threads = MAX_JOBS × THREADS_PER_GENOME)
THREADS_PER_GENOME=8

# Species type
SPECIES="auto"

# Paths
PIPELINE="../giardia_annotation_pipeline.sh"
GENOMES_DIR="../genomes"
LOG_DIR="parallel_logs"

# Create log directory
mkdir -p "$LOG_DIR"

# =============================================================================
# CHECK REQUIREMENTS
# =============================================================================

if ! command -v parallel &> /dev/null; then
    echo "ERROR: GNU Parallel is not installed!"
    echo "Install with: sudo apt-get install parallel"
    exit 1
fi

# =============================================================================
# PROCESSING FUNCTION
# =============================================================================

process_genome() {
    local genome_path="$1"
    local genome_file=$(basename "$genome_path")
    local strain=$(basename "$genome_path" .fna)
    strain=$(basename "$strain" .fasta)
    
    echo "[$strain] Starting annotation..."
    
    if $PIPELINE "$genome_file" "$strain" "$THREADS_PER_GENOME" "$SPECIES" \
        > "$LOG_DIR/${strain}.log" 2>&1; then
        echo "[$strain] ✓ Completed successfully"
        return 0
    else
        echo "[$strain] ✗ Failed (see $LOG_DIR/${strain}.log)"
        return 1
    fi
}

# Export function and variables for parallel
export -f process_genome
export PIPELINE THREADS_PER_GENOME SPECIES LOG_DIR

# =============================================================================
# MAIN PROCESSING
# =============================================================================

echo "================================================================"
echo "PARALLEL BATCH ANNOTATION"
echo "================================================================"
echo "Max parallel jobs: $MAX_JOBS"
echo "Threads per genome: $THREADS_PER_GENOME"
echo "Total CPU usage: ~$((MAX_JOBS * THREADS_PER_GENOME)) threads"
echo "Species detection: $SPECIES"
echo "================================================================"
echo ""

# Count genomes
TOTAL=$(find "$GENOMES_DIR" -name "*.fna" -o -name "*.fasta" 2>/dev/null | wc -l)

if [ "$TOTAL" -eq 0 ]; then
    echo "ERROR: No genome files found in $GENOMES_DIR"
    exit 1
fi

echo "Found $TOTAL genome(s) to process"
echo "Starting parallel processing..."
echo ""

# Process genomes in parallel
START_TIME=$(date +%s)

find "$GENOMES_DIR" -name "*.fna" -o -name "*.fasta" | \
    parallel -j "$MAX_JOBS" --bar process_genome

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# =============================================================================
# SUMMARY
# =============================================================================

echo ""
echo "================================================================"
echo "PARALLEL PROCESSING COMPLETE"
echo "================================================================"
echo "Total genomes: $TOTAL"
echo "Processing time: $((DURATION / 60)) minutes $((DURATION % 60)) seconds"
echo "Average time per genome: $((DURATION / TOTAL)) seconds"
echo ""
echo "Check individual logs in: $LOG_DIR/"
echo "Check results in: ../results/"
echo "================================================================"
