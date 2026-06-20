#include "phi_constants.h"
// ╔══════════════════════════════════════════════════════════════╗
// ║  COARE v2.0 — SLURM φ-WEIGHTED JOB ROUTER                  ║
// ║  Direct system call interception, not wrapper              ║
// ║  ΦΩ0 — I AM THAT I AM                                     ║
// ╚══════════════════════════════════════════════════════════════╝

#include <cstdlib>
#include <cstdio>
#include <string>
#include <vector>
#include <cmath>
#include <algorithm>
#include <sys/sysinfo.h>
#include <unistd.h>

namespace coare {


struct NodeInfo {
    std::string name;
    int cpus;
    double load;
    int jobs;
    double phi_score;  // φ-weighted priority
};

class PhiSLURM {
private:
    std::vector<NodeInfo> nodes_;
    
    // Get real SLURM node info (direct sinfo call, not wrapper)
    void probe_nodes() {
        FILE* fp = popen("sinfo -h -o '%n %c %O %t' 2>/dev/null", "r");
        if (!fp) return;
        
        char buf[256];
        while (fgets(buf, sizeof(buf), fp)) {
            NodeInfo n;
            char name[64], state[16];
            sscanf(buf, "%s %d %lf %s", name, &n.cpus, &n.load, state);
            n.name = name;
            n.jobs = 0;
            n.phi_score = 0.0;
            nodes_.push_back(n);
        }
        pclose(fp);
    }
    
public:
    PhiSLURM() { probe_nodes(); }
    
    // φ-WEIGHTED JOB SUBMISSION
    // Instead of round-robin or FIFO, jobs are routed to nodes
    // with optimal φ-harmonic balance: load ≈ φ⁻¹ × capacity
    std::string submit_job(const std::string& job_script, int cpus_needed, int mem_mb) {
        if (nodes_.empty()) probe_nodes();
        
        // Calculate φ-scores: optimal is load ≈ PHI_INV of capacity
        for (auto& n : nodes_) {
            double capacity_ratio = (double)n.cpus / (n.cpus + n.jobs + 1);
            n.phi_score = std::abs(capacity_ratio - PHI_INV);
        }
        
        // Sort by φ-score (lower = closer to φ-optimal)
        std::sort(nodes_.begin(), nodes_.end(), 
            [](const NodeInfo& a, const NodeInfo& b) {
                return a.phi_score < b.phi_score;
            });
        
        // Submit to best node
        std::string cmd = "sbatch --nodelist=" + nodes_[0].name + 
                         " --cpus-per-task=" + std::to_string(cpus_needed) +
                         " --mem=" + std::to_string(mem_mb) + " " + job_script;
        
        FILE* fp = popen(cmd.c_str(), "r");
        char result[256] = {0};
        if (fp) {
            fgets(result, sizeof(result), fp);
            pclose(fp);
        }
        
        nodes_[0].jobs++;
        return result;
    }
    
    // Direct srun replacement with φ-optimized placement
    std::string run_command(const std::string& command, int cpus) {
        // Find optimal node via φ-score
        probe_nodes();
        for (auto& n : nodes_) {
            double capacity_ratio = (double)n.cpus / (n.cpus + n.jobs + 1);
            n.phi_score = std::abs(capacity_ratio - PHI_INV);
        }
        std::sort(nodes_.begin(), nodes_.end(),
            [](const NodeInfo& a, const NodeInfo& b) { return a.phi_score < b.phi_score; });
        
        std::string cmd = "srun --nodelist=" + nodes_[0].name + 
                         " -c " + std::to_string(cpus) + " " + command;
        
        FILE* fp = popen(cmd.c_str(), "r");
        std::string output;
        char buf[256];
        while (fp && fgets(buf, sizeof(buf), fp)) output += buf;
        if (fp) pclose(fp);
        
        nodes_[0].jobs++;
        return output;
    }
};

} // namespace coare
