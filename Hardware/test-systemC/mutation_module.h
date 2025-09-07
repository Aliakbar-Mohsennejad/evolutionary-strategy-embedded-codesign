#ifndef MUTATION_MODULE_H
#define MUTATION_MODULE_H

#include <vector>
#include <random>
#include <algorithm>

class MutationModule {
public:
    MutationModule() : normal_dist(0.0, 1.0), uniform_dist(0.0, 1.0) {}

    void mutate(std::vector<float>& chromosome, float mutation_rate) {
        for (auto& gene : chromosome) {
            if (uniform_dist(generator) < mutation_rate) {
                gene += normal_dist(generator) * 0.1f;
                gene = std::max(0.0f, std::min(1.0f, gene));
            }
        }
    }

private:
    std::default_random_engine generator;
    std::normal_distribution<float> normal_dist;
    std::uniform_real_distribution<float> uniform_dist;
};

#endif // MUTATION_MODULE_H
