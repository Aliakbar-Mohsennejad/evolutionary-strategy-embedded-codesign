#ifndef FITNESS_H
#define FITNESS_H

#include <systemc.h>

SC_MODULE(Fitness) {
    sc_vector<sc_in<double>> genes;
    sc_out<double> total_profit;
    sc_out<double> total_weight;

    SC_CTOR(Fitness) : genes("genes", 9) {
        SC_METHOD(compute_fitness);
        for (int i = 0; i < 9; ++i) {
            sensitive << genes[i];
        }
    }

    void compute_fitness() {
        double weights[9] = { 2.5, 3, 1.2, 2, 4, 2.3, 3.5, 3.1, 2 };
        double profits[9] = { 10, 15, 6, 8, 20, 11, 17, 13, 12 };
        double sum_profit = 0;
        double sum_weight = 0;

        for (int i = 0; i < 9; ++i) {
            double g = genes[i].read();
            sum_weight += g * weights[i];
            if (sum_weight <= 25.0) {
                sum_profit += g * profits[i];
            }
            else {
                break;
            }
        }

        total_weight.write(sum_weight);
        total_profit.write(sum_profit);
    }
};

#endif
