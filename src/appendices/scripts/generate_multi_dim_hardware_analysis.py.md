## `generate_multi_dim_hardware_analysis.py`

```python
import polars as pl
import matplotlib.pyplot as plt
import seaborn as sns
import glob
import os
from datetime import datetime

# Configuration
results_dir = "development/uni/2025-project/pdhd/scripts/benchlam/results"
output_dir = "development/uni/2025-report/graphs"
os.makedirs(output_dir, exist_ok=True)

# Hardware Metadata Mapping
# ws-raretower: 24GB VRAM + 32GB RAM = 56GB Total
# minifridge: 16GB VRAM + 64GB RAM = 80GB Total
hardware_map = {
    "ws-raretower": {"vram": 24, "ram": 32, "total": 56},
    "minifridge": {"vram": 16, "ram": 64, "total": 80}
}

csv_files = glob.glob(os.path.join(results_dir, "benchmark_results_*.csv"))
data_list = []

print(f"Processing {len(csv_files)} files...")

for file in csv_files:
    try:
        if os.path.getsize(file) < 10:
            continue

        basename = os.path.basename(file)
        parts = basename.replace("benchmark_results_", "").replace(".csv", "").split("_")

        if len(parts) >= 1:
            host = parts[0]
            if host not in hardware_map:
                continue

            df = pl.read_csv(file)
            if df.height == 0:
                continue

            # Retrieve hardware specs for this host
            specs = hardware_map[host]

            df = df.with_columns([
                pl.lit(host).alias("host"),
                pl.lit(specs['vram']).alias("vram_gb"),
                pl.lit(specs['ram']).alias("ram_gb"),
                pl.lit(specs['total']).alias("total_gb")
            ])
            data_list.append(df)
    except Exception as e:
        print(f"Error in {os.path.basename(file)}: {e}")

if not data_list:
    print("No valid benchmark data found.")
    exit(1)

full_df = pl.concat(data_list).to_pandas()

# 2. Plotting: 2x2 Grid
# Row 1: Latency (VRAM vs Total)
# Row 2: Correctness (VRAM vs Total)
fig, axes = plt.subplots(2, 2, figsize=(16, 12))
plt.subplots_adjust(hspace=0.4, wspace=0.3)

# Plot 1: VRAM vs Latency
sns.stripplot(data=full_df, x='vram_gb', y='latency', hue='host', ax=axes[0, 0], jitter=True, palette='Set1', size=6)
axes[0, 0].set_title("VRAM (GB) vs Latency (s)", fontweight='bold')
axes[0, 0].set_xticks([16, 24])

# Plot 2: Total RAM vs Latency
sns.stripplot(data=full_df, x='total_gb', y='latency', hue='host', ax=axes[0, 1], jitter=True, palette='Set1', size=6)
axes[0, 1].set_title("Total Memory (GB) vs Latency (s)", fontweight='bold')
axes[0, 1].set_xticks([56, 80])

# Plot 3: VRAM vs Correctness
sns.stripplot(data=full_df, x='vram_gb', y='correctness_score', ax=axes[1, 0], hue='host', jitter=True, palette='Set1', size=6)
axes[1, 0].set_title("VRAM (GB) vs Correctness (%)", fontweight='bold')
axes[1, 0].set_ylim(0, 1.1)
axes[1, 0].set_xticks([16, 24])

# Plot 4: Total RAM vs Correctness
sns.stripplot(data=full_df, x='total_gb', y='correctness_score', ax=axes[1, 1], hue='host', jitter=True, palette='Set1', size=6)
axes[1, 1].set_title("Total Memory (GB) vs Correctness (%)", fontweight='bold')
axes[1, 1].set_ylim(0, 1.1)
axes[1, 1].set_xticks([56, 8_0])

# Global cleanup
for ax in axes.flat:
    ax.get_legend().remove() # Remove duplicate legends
    ax.grid(True, linestyle='--', alpha=0.6)

# Add a single unified legend to the bottom
handles, labels = axes[0, 0].get_legend_handles_labels()
fig.legend(handles, labels, loc='lower center', ncol=2, fontsize=12)

output_path = os.path.join(output_dir, "multi_dim_hardware_impact_analysis.png")
plt.savefig(output_path, bbox_inches='tight', dpi=300)
print(f"Successfully generated multi-dimensional analysis: {output_path}")

```
