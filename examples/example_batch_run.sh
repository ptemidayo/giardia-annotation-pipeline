#!/bin/bash
# Example: Batch processing multiple Giardia genomes
# Place this script in the examples/ directory

# =============================================================================
# BATCH ANNOTATION SCRIPT
# =============================================================================
# This script demonstrates how to annotate multiple Giardia genomes
# in batch mode using the annotation pipeline.

set -e  # Exit on error

# =============================================================================
# CONFIGURATION
# =============================================================================

# Number of CPU threads to use per genome
THREADS=16

# Species type (auto, intestinalis, muris)
SPECIES="auto"

# Path to the pipeline script (adjust if needed)
PIPELINE="../giardia_annotation_pipeline.sh"

# Genomes directory
GENOMES_DIR="../genomes"

# Log directory
LOG_DIR="batch_logs"
mkdir -p "$LOG_DIR"

# =============================================================================
# FUNCTIONS
# =============================================================================

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_DIR/batch_processing.log"
}

# =============================================================================
# MAIN PROCESSING
# =============================================================================

log_message "Starting batch annotation processing"
log_message "Pipeline: $PIPELINE"
log_message "Threads per genome: $THREADS"
log_message "Species detection: $SPECIES"
log_message "=========================================="

# Counter for tracking progress
TOTAL=0
SUCCESS=0
FAILED=0

# Get total number of genomes
TOTAL=$(find "$GENOMES_DIR" -name "*.fna" -o -name "*.fasta" | wc -l)
log_message "Found $TOTAL genome(s) to process"

# Process each genome file
for genome_path in "$GENOMES_DIR"/*.fna "$GENOMES_DIR"/*.fasta; do
    # Check if file exists (handles case where no files match)
    [ -e "$genome_path" ] || continue
    
    # Extract strain name from filename (remove path and extension)
    genome_file=$(basename "$genome_path")
    strain=$(basename "$genome_path" .fna)
    strain=$(basename "$strain" .fasta)
    
    log_message "Processing: $strain"
    log_message "  File: $genome_file"
    
    # Run pipeline
    if $PIPELINE "$genome_file" "$strain" "$THREADS" "$SPECIES" \
        > "$LOG_DIR/${strain}_pipeline.log" 2>&1; then
        SUCCESS=$((SUCCESS + 1))
        log_message "  ✓ SUCCESS: $strain completed"
    else
        FAILED=$((FAILED + 1))
        log_message "  ✗ FAILED: $strain (check $LOG_DIR/${strain}_pipeline.log)"
    fi
    
    log_message "  Progress: $((SUCCESS + FAILED))/$TOTAL"
    log_message "---"
done

# =============================================================================
# SUMMARY
# =============================================================================

log_message "=========================================="
log_message "BATCH PROCESSING COMPLETE"
log_message "=========================================="
log_message "Total genomes: $TOTAL"
log_message "Successful: $SUCCESS"
log_message "Failed: $FAILED"
log_message "Success rate: $(echo "scale=1; $SUCCESS * 100 / $TOTAL" | bc)%"

if [ $FAILED -gt 0 ]; then
    log_message ""
    log_message "Failed genomes - check logs in $LOG_DIR/"
    exit 1
else
    log_message ""
    log_message "All genomes processed successfully!"
    exit 0
fi
