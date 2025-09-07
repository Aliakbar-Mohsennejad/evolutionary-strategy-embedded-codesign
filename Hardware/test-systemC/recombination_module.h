#ifndef RECOMBINATION_MODULE_H
#define RECOMBINATION_MODULE_H

#include <vector>
#include <random>
#include <utility>
#include <algorithm>

class RecombinationModule {
public:
    RecombinationModule() : uniform_dist(0.0, 1.0) {}

    std::pair<std::vector<float>, std::vector<float>> recombine(
        const std::vector<float>& parent1,
        const std::vector<float>& parent2,
        float recombination_rate,
        int chromosome_length) {

        std::vector<float> child1 = parent1;
        std::vector<float> child2 = parent2;

        if (uniform_dist(generator) < recombination_rate) {
            int crossover_point = uniform_dist(generator) * (chromosome_length - 1);
            for (int i = crossover_point; i < chromosome_length; ++i) {
                std::swap(child1[i], child2[i]);
            }
        }

        return { child1, child2 };
    }

private:
    std::default_random_engine generator;
    std::uniform_real_distribution<float> uniform_dist;
};

#endif // RECOMBINATION_MODULE_H
