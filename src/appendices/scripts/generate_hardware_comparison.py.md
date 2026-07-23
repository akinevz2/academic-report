## `generate_hardware_comparison.py`

```python
import polars as pl
import matplotlib.pyplot as plt
import seaborn as sns
import glob
import os
from datetime import datetime

results_dir = "development/uni/2025-project/pdhd/scripts/benchlam/results"
output_dir = "development/un/2025-report/graphs" # Adjusting to relative/absolute based on execution context
# Actually, let's use absolute paths for safety
base_dir = os.path.abspath("development/uni/2025-report/graphs")
output_path = os.path.join(base_dir, "hardware_comparison_capability_latency.png")

# Ensure output dir exists
os.makedirs(os.path.dirname(output_path), exist_ok=True)

csv_files = glob.glob(os.path.join(results_dir, "benchmark_results_*.csv"))
data_list = []

for file in csv_files:
    try:
        # Check if file is empty
        if os.path.getsize(file) < 10:
            print(f"Skipping empty or too small file: {file}")
            continue
            
        basename = os.path.basename(file)
        parts = basename.replace("benchmark_results_", "").replace(".csv", "").split("_")
        
        if len(parts) >= 2:
            host = parts[0]
            ts_str = parts[1]
            try:
                dt = datetime.strptime(ts_str, "%Y%m%d_%H%M%S")
            except:
                dt = datetime.now()
                
            df = pl.read_csv(file)
            if df.height == 0:
                print(f"Skipping empty data in file: {file}")
                continue
                
            df = df.with_columns([
                pl.lit(host).alias("host"),
                pl_dt := pl.lit(dt).cast(pl.Datetime)
            ])
            data_list.append(df)
    except Exception as e:
        print(f"Error processing {file}: {e}")

if not data_list:
    print("No valid data found in CSV files!")
    exit(1)

full_df = pl.concat(data_list)
agg_df = full_df.group_by(["host", "test_case"]).agg([
    pl.col("latency").mean().alias("avg_latency"),
    pl.col("correctness_score").mean().alias("avg_correctness")
]).to_pandas()

hosts = ["ws-raretower", "minifridge"]
fig, axes = plt.subplots(2, 1, figsize=(14, 10), sharex=False)
plt.subplots_adjust(hspace=0.5)

for i, host in enumerate(hosts):
    host_data = agg_df[agg_df['host'] == host].sort_values('test_case')
    if host_data.empty:
        continue
        
    ax1 = axes[i]
    ax2 = ax1.twinx()
    
    sns.barplot(data=host_data, x='test_case', y='avg_latency', ax=ax1, color='skyblue', alpha=0.7)
    ax1.set_ylabel('Avg Latency (s)', color='blue', fontsize=12, fontweight='bold')
    ax1.tick_params(axis='y', labelcolor='blue')
    ax1.tick_params(axis='x', rotation=45, labelsize=8)
    
    sns.lineplot(data=host_data, x='test_case', y='avg_correctness', ax=ax2, color='red', marker='o', linewidth=2)
    ax2.set_ylabel('Avg Correct_Score (0-1)', color='red', fontsize=12, fontweight='bold')
    ax2.set_ylim(0, 1.1)
    ax2.tick_params(axis='y', labelcolor='red')
    
    ax1.set_title(f'Capability Performance: {host.upper()} (VRAM comparison)', fontsize=14, fontweight='bold')
    ax1.grid(axis='y', linestyle='--', alpha=0.7)

plt.tight_layout()
plt.savefig(output_path)
print(f"Successfully generated: {output_path}")

```
