#ifndef EVOLUTIONARY_STRATEGY_H
#define EVOLUTIONARY_STRATEGY_H

#include <systemc.h>
#include <vector>
#include "mutation_module.h"
#include "recombination_module.h"

SC_MODULE(EvolutionaryStrategy) {
    // پورت‌های ورودی/خروجی
    sc_in<bool> clk;
    sc_in<bool> start;
    sc_out<bool> done;
    sc_in<sc_uint<32>> data_in;
    sc_out<sc_uint<32>> data_out;
    sc_in<bool> data_valid;
    sc_out<bool> data_ready;

    // پارامترها
    float recombination_rate;
    float mutation_rate;
    int chromosome_length;

    // ماژول‌های مجزا
    MutationModule mutator;
    RecombinationModule recombinator;

    SC_CTOR(EvolutionaryStrategy) {
        chromosome_length = 8;
        SC_THREAD(process);
        sensitive << clk.pos();
    }

    std::vector<std::vector<float>> process_parents(
        const std::vector<std::vector<float>>&parents,
        float rec_rate, float mut_rate) {

        recombination_rate = rec_rate;
        mutation_rate = mut_rate;

        std::vector<std::vector<float>> offspring;

        for (size_t i = 0; i < parents.size(); i += 2) {
            auto children = recombinator.recombine(
                parents[i], parents[i + 1], recombination_rate, chromosome_length);

            mutator.mutate(children.first, mutation_rate);
            mutator.mutate(children.second, mutation_rate);

            offspring.push_back(children.first);
            offspring.push_back(children.second);
        }

        return offspring;
    }

private:
    void process() {
        while (true) {
            wait();  // انتظار برای کلاک
        }
    }
};

#endif // EVOLUTIONARY_STRATEGY_H
