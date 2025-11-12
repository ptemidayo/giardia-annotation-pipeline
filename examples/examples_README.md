# Examples Directory

This directory contains example scripts demonstrating different ways to use the Giardia annotation pipeline.

## 📋 Available Examples

### 1. **example_batch_run.sh** - Sequential Batch Processing
Process multiple genomes one at a time (sequential).

**Features:**
- Processes genomes sequentially
- Comprehensive logging
- Progress tracking
- Error handling

**Usage:**
```bash
cd examples
chmod +x example_batch_run.sh
./example_batch_run.sh
```

**When to use:**
- Limited CPU cores (< 16 cores)
- Limited RAM (< 32 GB)
- Small number of genomes (1-5)
- Want to monitor each genome individually

---

### 2. **example_parallel_run.sh** - Parallel Batch Processing
Process multiple genomes simultaneously using GNU Parallel.

**Features:**
- Parallel processing
- Configurable number of concurrent jobs
- Progress bar
- Faster for multiple genomes

**Requirements:**
- GNU Parallel: `sudo apt-get install parallel`
- More CPU cores and RAM

**Usage:**
```bash
cd examples
chmod +x example_parallel_run.sh

# Run 2 genomes in parallel (default)
./example_parallel_run.sh

# Run 4 genomes in parallel
./example_parallel_run.sh 4
```

**When to use:**
- Many CPU cores (32+ cores recommended)
- Sufficient RAM (64+ GB recommended)
- Multiple genomes (5+ genomes)
- Want faster processing time

---

## 🔧 Configuration

Before running the examples, ensure:

1. **Genomes are in the genomes/ directory:**
   ```bash
   mkdir -p ../genomes
   cp your_genomes/*.fna ../genomes/
   ```

2. **Giardia database is set up:**
   ```bash
   mkdir -p ../databases
   # Download and place giardia_proteins.fasta in databases/
   ```

3. **Pipeline script is executable:**
   ```bash
   chmod +x ../giardia_annotation_pipeline.sh
   ```

---

## 📊 Resource Requirements

### Sequential Processing (example_batch_run.sh)

| Genomes | CPU Cores | RAM | Est. Time* |
|---------|-----------|-----|------------|
| 1 | 16 | 16 GB | 1-2 hours |
| 5 | 16 | 16 GB | 5-10 hours |
| 10 | 16 | 16 GB | 10-20 hours |

### Parallel Processing (example_parallel_run.sh)

| Genomes | Jobs | Cores/Job | Total Cores | RAM | Est. Time* |
|---------|------|-----------|-------------|-----|------------|
| 5 | 2 | 8 | 16 | 32 GB | 3-5 hours |
| 10 | 4 | 8 | 32 | 64 GB | 3-5 hours |
| 20 | 4 | 8 | 32 | 64 GB | 5-10 hours |

*Estimated times vary based on genome size and complexity

---

## 💡 Tips

### Optimizing Thread Usage

**Formula:**
```
Total CPU threads = MAX_JOBS × THREADS_PER_GENOME
```

**Example configurations:**

1. **Conservative (32 cores, 64 GB RAM):**
   - MAX_JOBS=2
   - THREADS_PER_GENOME=16
   - Total: 32 threads

2. **Moderate (64 cores, 128 GB RAM):**
   - MAX_JOBS=4
   - THREADS_PER_GENOME=16
   - Total: 64 threads

3. **Aggressive (128 cores, 256 GB RAM):**
   - MAX_JOBS=8
   - THREADS_PER_GENOME=16
   - Total: 128 threads

### Monitoring Progress

**Check logs:**
```bash
# Sequential processing
tail -f batch_logs/batch_processing.log

# Parallel processing
tail -f parallel_logs/*.log
```

**Monitor system resources:**
```bash
htop           # CPU and memory usage
watch -n 1 'ps aux | grep giardia'  # Pipeline processes
```

---

## 🐛 Troubleshooting

### "Permission denied"
```bash
chmod +x *.sh
```

### "Pipeline not found"
Check that the pipeline script path is correct:
```bash
ls -la ../giardia_annotation_pipeline.sh
```

### "Out of memory"
Reduce the number of parallel jobs or threads per genome:
```bash
# Edit the script and reduce:
MAX_JOBS=2
THREADS_PER_GENOME=8
```

### "GNU Parallel not found"
Install GNU Parallel:
```bash
# Ubuntu/Debian
sudo apt-get install parallel

# CentOS/RHEL
sudo yum install parallel

# macOS
brew install parallel
```

---

## 📝 Creating Custom Scripts

You can create custom scripts based on these examples:

```bash
#!/bin/bash
# My custom annotation script

PIPELINE="../giardia_annotation_pipeline.sh"

# Annotate specific genomes with custom parameters
$PIPELINE genome1.fna Strain1 16 intestinalis
$PIPELINE genome2.fna Strain2 16 muris

# Or loop through a specific list
for genome in genome1.fna genome2.fna genome3.fna; do
    strain=$(basename $genome .fna)
    $PIPELINE $genome $strain 16 auto
done
```

---

## 📞 Need Help?

- Check the main [README.md](../README.md)
- Review [Quick Start Guide](../docs/QUICK_START.md)
- See [Troubleshooting](../docs/QUICK_START.md#troubleshooting)
- Open an [Issue](https://github.com/ptemidayo/giardia-annotation-pipeline/issues)

---

**Happy annotating!** 🦠🔬
